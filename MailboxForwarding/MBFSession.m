//
//  MBFSession.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/21/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFSession.h"
#import "KeychainItemWrapper.h"

static NSString *LOGIN_URL = @"https://www.mailboxforwarding.com/manage/login.php";
static NSString *INDEX_URL = @"https://www.mailboxforwarding.com/manage/index.php";

@implementation MBFSession

@synthesize keychain = _keychain;
@synthesize email = _email;
@synthesize password = _password;

- (KeychainItemWrapper *)keychain {
    if (! _keychain) {
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MBFLogin" accessGroup:nil];
        [_keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    }
    return _keychain;
}

- (NSString *)email {
    if (! (_email && (_email.length > 0)))
        _email = [self.keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    return _email;
}

- (void)setEmail:(NSString *) email {
    [self.keychain setObject:email forKey:(__bridge id)(kSecAttrAccount)];
}

- (NSString *)password {
    if (! (_password && (_password.length > 0)))
        _password = [self.keychain objectForKey:(__bridge id)(kSecValueData)];
    return _password;
}

- (void)setPassword:(NSString *)password {
    _password = password;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL rememberPassword = [defaults boolForKey:@"remember_password"];
    
    if (rememberPassword)
        [self.keychain setObject:password forKey:(__bridge id)(kSecValueData)];
}

- (void)loginRequest:(void (^)())completionHandler {
    if (self.email.length > 0 && self.password.length > 0) {
        NSString *body = [NSString stringWithFormat:@"action=login&email=%@&password=%@", self.email, self.password];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LOGIN_URL]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPShouldHandleCookies = YES;
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   NSLog(@"httpResponse.statusCode: %d", httpResponse.statusCode);
                                   if (completionHandler)
                                       completionHandler();
                               }];
    }
}

- (void)indexRefreshRequest:(void (^)(NSData *data))completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:INDEX_URL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (completionHandler)
                                       completionHandler(data);
                           }];
}

- (void)indexRefresh:(void (^)(NSData *data))completionHandler {
    // MBF website uses session cookies, which live only as long as the app is running.
    //  If we don't have a session cookie, then we need to login again to get one before
    //  making any other requests.
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if ([cookies count] == 0) {
        [self loginRequest:^(){[self indexRefreshRequest:completionHandler];}];
    } else {
        [self indexRefreshRequest:completionHandler];
    }
}

- (void)downloadResource:(NSString *)url completionHandler:(void (^)(NSString *filename))completionHandler {
    // TODO: Move this section into init function
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesFolder = paths[0];
    
    NSArray *pathComponents = [url componentsSeparatedByString:@"/"];
    NSString *lastComponent = [pathComponents lastObject];
    NSString *filename = [cachesFolder stringByAppendingPathComponent:lastComponent];
    
    NSLog(@"downloadResource: %@ -> %@", url, filename);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (! [fileManager fileExistsAtPath:filename]) {
        UIApplication *app = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier bgTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
            // TODO: Something here?
        }];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   int statusCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *arg = (statusCode == 200 && data && [data writeToFile:filename atomically:YES]) ? filename : nil;
                                   if (completionHandler)
                                       completionHandler(arg);
                                   [app endBackgroundTask:bgTaskID];
                               }];
    }
}

- (void)statusChangeRequest:(NSDictionary *)options completionHandler:(void (^)())completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:INDEX_URL]];
    
    NSMutableString *body = [NSMutableString stringWithString:@"action=changeStatus"];
    
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [body appendFormat:@"&%@=%@", key, obj];
        //
    }];
//    NSString *body = [NSString stringWithFormat:(NSString *), ...]
}

- (void)statusChangeRequest:(NSString *)mailId newStatus:(NSString *)newStatus completionHandler:(void (^)())completionHandler {
    NSLog(@"statusChangeRequest/mailId: %@", mailId);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:INDEX_URL]];
        
    NSString *body = [NSString stringWithFormat:@"action=changeStatus&mail[]=%@&statusAction=%@", mailId, newStatus];
    
    NSLog(@"statusChangeRequest/body: %@", body);

    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"statusChangeRequest/bodyData: %@", bodyData);
    
    
    
    request.HTTPBody = bodyData;
    
    request.HTTPMethod = @"POST";
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               int statusCode = [(NSHTTPURLResponse *)response statusCode];
                               
                               NSLog(@"statusChangeRequest/error: %@", error);
                               NSLog(@"statusChangeRequest/statusCode: %d", statusCode);
                               
                               if (completionHandler)
                                   completionHandler();
                           }];
}

- (void)shredRequest:(NSString *)mailId completionHandler:(void (^)())completionHandler {
    [self statusChangeRequest:mailId newStatus:@"shreda" completionHandler:completionHandler];
}

- (void)scanRequest:(NSString *)mailId completionHandler:(void (^)())completionHandler {
    [self statusChangeRequest:mailId newStatus:@"scan" completionHandler:completionHandler];
}

@end
