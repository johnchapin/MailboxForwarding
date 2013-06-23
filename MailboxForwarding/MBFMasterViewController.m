//
//  MBFMasterViewController.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFMasterViewController.h"
#import "MBFTableViewCell.h"
#import "MBFDetailViewController.h"
#import "MBFItem.h"

@interface MBFMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MBFMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void) handleRefresh:(id)sender
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSLog(@"%@",path);
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"Ext.grid.dummyData = (.*]]);" options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    
    
    NSString *jsonStr = [content substringWithRange:[result rangeAtIndex:1]];
    NSString *cleanJsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"['" withString:@"[\""];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"','" withString:@"\",\""];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"']" withString:@"\"]"];
    cleanJsonStr = [cleanJsonStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    
    NSData *jsonData = [cleanJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    // 23713,
//    "<input type=\"checkbox\" name=\"mail[]\" value=\"10653953\" id=\"GnxlQtwGotL5cCzZ1lQkelcI2qPYi\">",
//    "2013-06-17",
//    "<img src=\"https://www.mailboxforwarding.com/files/tbm/GnxlQtwGotL5cCzZ1lQkelcI2qPYi.jpg\" height=\"70\" onClick=\"javascript:tbm(\\'GnxlQtwGotL5cCzZ1lQkelcI2qPYi\\');\">",
//    Letter,
//    Scanned,
//    "<a href=\"pdfviewer.php?id=10653953\" target=\"_blank\"><b>View Scan</b></a>"
    
    NSArray *entry;
    for(entry in [json subarrayWithRange:NSMakeRange(0, 5)])
    {
        [self insertNewItemFromJson:entry];
    }
    
    [self.refreshControl endRefreshing];
}

- (void)insertNewItemFromJson:(NSArray *)jsonEntry
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    MBFItem *item = [[MBFItem alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    item.mailboxId = [jsonEntry objectAtIndex:0];
    item.received = [jsonEntry objectAtIndex:2];
    item.type = [jsonEntry objectAtIndex:4];
    item.status = [jsonEntry objectAtIndex:5];
    
    NSString *idsStr = [jsonEntry objectAtIndex:1];
    NSError *regexError;
    NSRegularExpression *idsRegex = [NSRegularExpression regularExpressionWithPattern:@"value=\"([0-9]+)\" id=\"([A-Za-z0-9]+)\"" options:0 error:&regexError];
    NSTextCheckingResult *idsResult = [idsRegex firstMatchInString:idsStr options:0 range:NSMakeRange(0, [idsStr length])];
    
    item.scanId = [idsStr substringWithRange:[idsResult rangeAtIndex:1]];
    item.envelopeId = [idsStr substringWithRange:[idsResult rangeAtIndex:2]];
    
    NSURLRequest *envelopeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.mailboxforwarding.com/files/tbm/%@.jpg", item.envelopeId]]];
    
    [NSURLConnection sendAsynchronousRequest:envelopeRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               item.envelope = data;
                               NSError *saveError;
                               if (![context save:&saveError]) {
                                   NSLog(@"Unresolved error %@, %@", saveError, [saveError userInfo]);
                                   abort();
                               }
                           }];
    
    NSError *saveError;
    if (![context save:&saveError]) {
        NSLog(@"Unresolved error %@, %@", saveError, [saveError userInfo]);
        abort();
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MBFItem *item = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        NSLog(@"item: %@", item);
        [[segue destinationViewController] setDetailItem:item];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MBFItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"received" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Inbox"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(MBFTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MBFItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.dateLabel.text = item.received;
    cell.typeLabel.text = item.type;
    cell.statusLabel.text = item.status;
    cell.envelopeImage.image = [UIImage imageWithData:item.envelope];
}

//- (void)configureCell:(MBFTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.dateLabel.text = [[object valueForKey:@"received"] description];
//    cell.typeStatusLabel.text = [[NSString alloc] initWithFormat:@"%@, %@",
//                                 [[object valueForKey:@"type"] description],
//                                 [[object valueForKey:@"status"] description]];
//    // cell.typeStatusLabel.text = @"Letter, Pending Scan";
//    
//}

@end
