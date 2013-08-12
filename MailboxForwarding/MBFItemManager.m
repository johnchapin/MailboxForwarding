//
//  MBFItemManager.m
//  mailboxforwarding
//
//  Created by Johnathan Chapin on 8/20/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFItemManager.h"

static NSString *ENVELOPE_URL_FMT = @"https://www.mailboxforwarding.com/files/tbm/%@.jpg";
static NSString *SCAN_URL_FMT = @"https://www.mailboxforwarding.com/files/pdf/%@.pdf";

@implementation MBFItemManager

- (id)init {
    self = [super init];
    if (self != nil)
        self.session = [MBFSession alloc];
    return self;
}

- (void)refresh:(void (^)())completionHandler {
    [self.session indexRefresh:^(NSData *data){
        NSArray *candidates = [self parseIndex:data];
        if (candidates.count > 0)
            for (NSArray* candidate in candidates)
                [self addOrUpdateItem:candidate];
    }];
}

- (NSArray *)parseIndex:(NSData *) indexData {
    NSString *content = [[NSString alloc] initWithData:indexData encoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"Ext.grid.dummyData =(.*]]);"
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    
    NSString *jsonStr = [content substringWithRange:[result rangeAtIndex:1]];
    
    NSString *cleanJsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"['" withString:@"[\""];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"']" withString:@"\"]"];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"','" withString:@"\",\""];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"\\'" withString:@"\\\\'"];
    
    NSData *jsonData = [cleanJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *candidates = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error)
        NSLog(@"json error: %@", error);
    
    return candidates;
}

- (void)addEnvelopeToItem:(MBFItem *)item {
    NSLog(@"MBFItemManager/addEnvelopeToItem");
    if (! item.envelope) {
        NSString *envelopeURL = [NSString stringWithFormat:ENVELOPE_URL_FMT, item.envelopeId];
        [self.session downloadResource:envelopeURL completionHandler:^(NSString *filename) {
            if (filename) {
                item.envelope = filename;
                [self saveContext];
            }
        }];
    }
}

- (void)addScanToItem:(MBFItem *)item completionHandler:(void (^)())completionHandler {
    if (! item.scan) {
        NSString *scanURL = [NSString stringWithFormat:SCAN_URL_FMT, item.envelopeId];
        [self.session downloadResource:scanURL completionHandler:^(NSString *filename) {
            if (filename) {
                item.scan = filename;
                [self saveContext];
                
                if (completionHandler)
                    completionHandler();
            }
        }];
    }
}

- (NSString *)parseMailId:(NSString *) input {
    
    NSString *output;
    
    if (input != nil) {
    
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"value=\"([0-9]+)\""
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
        
        NSTextCheckingResult *result = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
        
        if (result != nil)
            output = [input substringWithRange:[result rangeAtIndex:1]];
    }
    
    return output;
}

- (void)addOrUpdateItem:(NSArray *)candidate {
    MBFItemSkeleton *itemSkeleton = [[MBFItemSkeleton alloc] initWithJsonArray:candidate];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MBFItem" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"envelopeId", itemSkeleton.envelopeId];
    
    fetchRequest.predicate = predicate;
    fetchRequest.fetchLimit = 1;
    
    NSError *fetchError;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&fetchError];
    
    MBFItem *item;
    if (items.count == 0)
        item = [[MBFItem alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    else
        item = [items objectAtIndex:0];
    
    item.scanId = itemSkeleton.scanId;
    item.envelopeId = itemSkeleton.envelopeId;
    item.mailboxId = [itemSkeleton.jsonArray objectAtIndex:0];
    item.mailId = [self parseMailId:[itemSkeleton.jsonArray objectAtIndex:1]];
    item.received = [itemSkeleton.jsonArray objectAtIndex:2];
    item.type = [itemSkeleton.jsonArray objectAtIndex:4];
    item.status = [itemSkeleton.jsonArray objectAtIndex:5];
    
    [self addEnvelopeToItem:item];
    
    NSLog(@"item.status = %@", item.status);
    
    [self saveContext];
}

- (void)saveContext {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // TODO: Remove abort from shipping app
        abort();
    }
}

@end
