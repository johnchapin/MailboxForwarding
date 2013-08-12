//
//  MBFStartupViewController.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFStartupViewController.h"

@implementation MBFStartupViewController

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
	// Do any additional setup after loading the view.
    if (self.manager.session.email.length > 0)
        self.emailAddressTextField.text = self.manager.session.email;
        
    self.passwordTextField.delegate = self;
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    self.manager.session.email = self.emailAddressTextField.text;
    self.manager.session.password = self.passwordTextField.text;
    
    [self.passwordTextField resignFirstResponder];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.activityIndicator.hidden = NO;
    
    [self.manager.session loginRequest:^(){
        [self.manager refresh:NULL];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return NO;
}

@end
