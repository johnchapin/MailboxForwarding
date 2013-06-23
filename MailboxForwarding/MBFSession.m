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
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MBFLoginInfo" accessGroup:nil];
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
    _email = email;
}

- (NSString *) password {
    if (! (_password && (_password.length > 0)))
        _password = [[self keychain] objectForKey:(__bridge id)(kSecValueData)];
    return _password;
}

- (void) setPassword:(NSString *)password {
    [[self keychain] setObject:password forKey:(__bridge id)(kSecValueData)];
    _password = password;
}

@end
