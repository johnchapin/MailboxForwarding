//
//  MBFActionsViewController.m
//  mailboxforwarding
//
//  Created by Johnathan Chapin on 8/20/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFItem.h"
#import "MBFActionsViewController.h"

@interface MBFActionsViewController ()

@end

@implementation MBFActionsViewController

- (IBAction)scan:(id)sender {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"action", @"changeStatus",
                             @"mail[]", self.actionItem.mailId,
                             @"statusAction", @"scan", nil];
    
    [self.manager.session statusChangeRequest:options completionHandler:^{
        [self.manager refresh:NULL];
    }];
}

- (IBAction)forward:(id)sender {
    // TODO: Capture forwarding address and carrier options
    // [self.manager.session statusChangeRequest:@"mailId" newStatus:@"forward" completionHandler:NULL];
}

- (IBAction)shred:(id)sender {
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             @"action", @"changeStatus",
//                             @"mail[]", self.actionItem.mailId,
//                             @"statusAction", @"shreda", nil];
//    
//    [self.manager.session statusChangeRequest:options completionHandler:^{
//        [self.manager refresh:NULL];
//    }];
}

//action:changeStatus
//statusAction:deposit
//mail[]:10699845
//forwardName:
//forwardCountrySelect:0
//forwardCountry:
//forwardAddress:
//forwardCity:
//forwardState:
//forwardZip:
//forwardShipSpeed:2
//forwardInst:
//forwardCustoms:
//forwardPhone:
//depositBank:UA
//depositBankname:
//depositAddress:
//depositCity:
//depositState:
//depositZip:
//depositAccount:121871037
//depositAccountState:VA
//depositShipSpeed:3 - Overnight

- (IBAction)deposit:(id)sender {
    // TODO: Capture deposit address, account info, carrier options
}

- (IBAction)addContents:(id)sender {
}

- (IBAction)rts:(id)sender {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[self.actionItem.status lowercaseString] isEqualToString:@"pending scan"]) {
        self.scanButton.userInteractionEnabled = NO;
        self.scanButton.enabled = NO;
        [self.scanButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
