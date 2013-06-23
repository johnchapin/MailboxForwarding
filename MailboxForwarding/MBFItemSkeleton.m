//
//  MBFItemSkeleton.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/23/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFItemSkeleton.h"

static NSRegularExpression *idsRegex;

@implementation MBFItemSkeleton

@synthesize jsonArray = _jsonArray;
@synthesize scanId = _scanId;
@synthesize envelopeId = _envelopeId;

+ (void) initialize
{
    idsRegex = [NSRegularExpression regularExpressionWithPattern:@"value=\"([0-9]+)\" id=\"([A-Za-z0-9]+)\"" options:0 error:nil];
}

- (MBFItemSkeleton *)initWithJsonArray:(NSArray *)jsonArray
{
    _jsonArray = jsonArray;
    [self setIds];
    return self;
}

- (void) setIds
{
    if (self.scanId.length == 0 || self.envelopeId.length == 0)
    {
        NSString *idsStr = [_jsonArray objectAtIndex:1];
        NSTextCheckingResult *idsResult = [idsRegex firstMatchInString:idsStr options:0 range:NSMakeRange(0, [idsStr length])];
        _scanId = [idsStr substringWithRange:[idsResult rangeAtIndex:1]];
        _envelopeId = [idsStr substringWithRange:[idsResult rangeAtIndex:2]];
    }
}
//
//- (NSString *)scanId
//{
//    [self setIds];
//    return _scanId;
//}
//
//- (NSString *)envelopeId
//{
//    [self setIds];
//    return _envelopeId;
//}


@end
