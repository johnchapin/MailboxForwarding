//
//  MBFDetailViewController.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFDetailViewController.h"
#import "MBFItem.h"

@interface MBFDetailViewController ()
- (void)configureView;
@end

@implementation MBFDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(MBFItem *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    
    NSLog(@"configureView");
    NSLog(@"self.detailItem: %@", self.detailItem);
    
    if (self.detailItem) {
        NSLog(@"Found detailItem: %@", self.detailItem.envelopeId);
        self.title = [NSString stringWithFormat:@"%@ %@", self.detailItem.received, self.detailItem.type];
        self.statusLabel.text = self.detailItem.status;
        self.mailboxIdLabel.text = self.detailItem.mailboxId;
        self.envelopeIdLabel.text = self.detailItem.envelopeId;
        self.scanIdLabel.text = self.detailItem.scanId;
        self.envelopeImage.image = [UIImage imageWithData:self.detailItem.envelope];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
