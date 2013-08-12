//
//  MBFDetailViewController.m
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/16/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import "MBFDetailViewController.h"
#import "MBFActionsViewController.h"
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
    }
}

- (void)configureEnvelopeView
{
    
//    NSString *content = [NSString stringWithFormat:@"<html><body><img src=\"%@\"/></body></html>", self.detailItem.envelope];
//    NSLog(@"content: %@", content);
//    NSURL *baseUrl = [[NSURL alloc] initWithString:@"foo"];
//    [self.webView loadHTMLString:content baseURL:baseUrl];
    
    [self.webView loadData:[NSData dataWithContentsOfFile:self.detailItem.envelope] MIMEType:@"image/jpeg" textEncodingName:nil baseURL:nil];
    
//    [self.webView loadData:self.detailItem.envelope MIMEType:@"application/jpeg" textEncodingName:@"utf-8" baseURL:nil];
    
//    UIImage *landscape = [UIImage imageWithData:self.detailItem.envelope];
//    
//    // Find out what percent we need to scale down the image
//    //  to fit the width correctly and allow scrolling for the
//    //  height. Note that the landscape height will be the portrait
//    //  width.
//    
//    float scale = landscape.size.height / self.view.bounds.size.width;
//    
//    UIImage *landscapeScaled = [[UIImage alloc] initWithCGImage: landscape.CGImage
//                                                          scale: scale
//                                                    orientation: UIImageOrientationRight];
//    
//    
//    UIImageView *envelopeView = [[UIImageView alloc] initWithImage:landscapeScaled];
//    
//    [self.scrollView addSubview:envelopeView];
//    
//    self.scrollView.contentSize = envelopeView.frame.size;
//    self.scrollView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
//    self.scrollView.contentOffset = CGPointMake(0, -30);
}

- (void)configureScanView
{
    NSData *scan = [NSData dataWithContentsOfFile:self.detailItem.scan];
    [self.webView loadData:scan MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
}

- (void)configureView
{
    if (self.detailItem) {
        self.title = [NSString stringWithFormat:@"%@ %@", self.detailItem.received, self.detailItem.type];
        
        self.statusLabel.text = self.detailItem.status;
        
        if (self.detailItem.scan) {
            [self configureScanView];
        } else {
            [self configureEnvelopeView];
        }
    }
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    [self.manager addScanToItem:self.detailItem completionHandler:^{
        [self configureView];
    }];
    
    [self configureView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showActions"]) {        
        [segue.destinationViewController setActionItem:self.detailItem];
        [segue.destinationViewController setManager:self.manager];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
