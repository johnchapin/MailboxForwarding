//
//  MBFShredViewController.h
//  mailboxforwarding
//
//  Created by Johnathan Chapin on 9/24/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBFItem.h"
#import "MBFItemManager.h"

@interface MBFShredViewController : UIViewController

@property (weak, nonatomic) MBFItemManager *manager;
@property (weak, nonatomic) MBFItem *actionItem;

@property (weak, nonatomic) IBOutlet UIButton *shredArchiveButton;
@property (weak, nonatomic) IBOutlet UIButton *shreadDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)shredArchive:(id)sender;
- (IBAction)shredDelete:(id)sender;
- (IBAction)cancel:(id)sender;

@end
