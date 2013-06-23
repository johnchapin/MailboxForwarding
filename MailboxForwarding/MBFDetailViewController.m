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
    if (self.detailItem) {
        self.title = [NSString stringWithFormat:@"%@ %@", self.detailItem.received, self.detailItem.type];
        
        self.statusLabel.text = self.detailItem.status;
        self.mailboxIdLabel.text = self.detailItem.mailboxId;
        self.scanIdLabel.text = self.detailItem.scanId;
    
        UIImage *landscape = [UIImage imageWithData:self.detailItem.envelope];
                
        // Find out what percent we need to scale down the image
        //  to fit the width correctly and allow scrolling for the
        //  height. Note that the landscape height will be the portrait
        //  width.
        
        float scale = landscape.size.height / self.view.bounds.size.width;
        
        UIImage *landscapeScaled = [[UIImage alloc] initWithCGImage: landscape.CGImage
                                                       scale: scale
                                                 orientation: UIImageOrientationRight];

        
        UIImageView *envelopeView = [[UIImageView alloc] initWithImage:landscapeScaled];
        
        [self.scrollView addSubview:envelopeView];
        
        self.scrollView.contentSize = envelopeView.frame.size;
        self.scrollView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
        self.scrollView.contentOffset = CGPointMake(0, -30);
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
