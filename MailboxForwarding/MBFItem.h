//
//  Item.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/23/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MBFItem : NSManagedObject

@property (nonatomic, retain) NSString * envelopeId;
@property (nonatomic, retain) NSData * envelope;
@property (nonatomic, retain) NSString * received;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * mailboxId;
@property (nonatomic, retain) NSData * scan;
@property (nonatomic, retain) NSString * scanId;

@end
