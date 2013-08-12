//
//  MBFStartupViewController.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBFItemManager.h"

@interface MBFStartupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property MBFItemManager *manager;

- (IBAction)login:(id)sender;

@end
