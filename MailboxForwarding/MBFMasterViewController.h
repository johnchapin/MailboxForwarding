//
//  MBFMasterViewController.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBFSession.h"
#import "MBFItemManager.h"

@interface MBFMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// @property (weak, nonatomic) MBFSession *session;
@property (weak, nonatomic) MBFItemManager *manager;

@end
