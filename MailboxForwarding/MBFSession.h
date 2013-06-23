//
//  MBFSession.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/21/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface MBFSession : NSObject 

@property (nonatomic, retain) KeychainItemWrapper *keychain;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

@end
