//
//  MBFItemSkeleton.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/23/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBFItemSkeleton : NSObject

@property (nonatomic, retain) NSArray * jsonArray;
@property (nonatomic, retain) NSString * envelopeId;
@property (nonatomic, retain) NSString * scanId;

- (MBFItemSkeleton *) initWithJsonArray:(NSArray *)jsonArray;

@end
