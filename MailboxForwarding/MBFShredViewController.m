//
//  MBFShredViewController.m
//  mailboxforwarding
//
//  Created by Johnathan Chapin on 9/24/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFShredViewController.h"

@interface MBFShredViewController ()

@end

@implementation MBFShredViewController

- (IBAction)shredArchive:(id)sender {
    // nop
}

- (IBAction)shredDelete:(id)sender {
    // nop
}

- (IBAction)cancel:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
