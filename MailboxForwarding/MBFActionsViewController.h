//
//  MBFActionsViewController.h
//  mailboxforwarding
//
//  Created by Johnathan Chapin on 8/20/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBFItem.h"
#import "MBFItemManager.h"

@interface MBFActionsViewController : UIViewController

@property (weak, nonatomic) MBFItemManager *manager;
@property (weak, nonatomic) MBFItem *actionItem;

@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *shredButton;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;
@property (weak, nonatomic) IBOutlet UIButton *addContentsButton;
@property (weak, nonatomic) IBOutlet UIButton *rtsButton;

- (IBAction)scan:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)shred:(id)sender;
- (IBAction)deposit:(id)sender;
- (IBAction)addContents:(id)sender;
- (IBAction)rts:(id)sender;

@end
