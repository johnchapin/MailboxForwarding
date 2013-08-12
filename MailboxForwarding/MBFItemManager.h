//
//  MBFItemManager.h
//  mailboxforwarding
//
//  Created by Johnathan Chapin on 8/20/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBFItem.h"
#import "MBFSession.h"

@interface MBFItemManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) MBFSession *session;

- (void) addScanToItem:(MBFItem *)item completionHandler:(void (^)())completionHandler;
- (void) refresh:(void (^)())completionHandler;

@end
