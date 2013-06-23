//
//  MBFSession.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/21/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFSession.h"
#import "KeychainItemWrapper.h"

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

- (NSString *) email {
    if (! (_email && (_email.length > 0)))
        _email = [[self keychain] objectForKey:(__bridge id)(kSecAttrAccount)];
    return _email;
}

- (void) setEmail:(NSString *) email {
    [[self keychain] setObject:email forKey:(__bridge id)(kSecAttrAccount)];
}

- (NSString *) password {
    if (! (_password && (_password.length > 0)))
        _password = [[self keychain] objectForKey:(__bridge id)(kSecValueData)];
    NSLog(@"password: %@", _password);

    return _password;
}

- (void) setPassword:(NSString *)password {
    [[self keychain] setObject:password forKey:(__bridge id)(kSecValueData)];
}

- (void) login {
    
    if (([[self email] length] > 0) && ([[self password] length] > 0)) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.mailboxforwarding.com/manage/login.php"]];
        [request setHTTPMethod:@"POST"];
        NSString *requestBody = [NSString stringWithFormat:@"action=login&email=%@&password=%@", [self email], [self password]];
        NSLog(@"requestBody: %@", requestBody);
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPShouldHandleCookies:YES];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   NSLog(@"Successful login, I think...");
                                   NSLog(@"response: %@", response);
                               }];
    }
}

@end
