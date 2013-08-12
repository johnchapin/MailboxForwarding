//
//  MBFDetailViewController.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBFItem.h"
#import "MBFItemManager.h"

@interface MBFDetailViewController : UIViewController

@property (weak, nonatomic) MBFItemManager *manager;

@property (weak, nonatomic) MBFItem *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
