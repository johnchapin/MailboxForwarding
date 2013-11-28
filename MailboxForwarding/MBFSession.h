//
//  MBFSession.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/21/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
#import "MBFItem.h"

@interface MBFSession : NSObject

@property (nonatomic, retain) KeychainItemWrapper *keychain;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

- (void)loginRequest:(void (^)())completionHandler;
- (void)indexRefresh:(void (^)(NSData *data))completionHandler;
- (void)downloadResource:(NSString *) url completionHandler:(void (^)(NSString *filename))completionHandler;

//- (void)statusChangeRequest:(NSString *)mailId newStatus:(NSString *)newStatus completionHandler:(void (^)())completionHandler;

- (void)statusChangeRequest:(NSDictionary *)options completionHandler:(void (^)())completionHandler;

@end