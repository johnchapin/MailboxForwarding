//
//  MBFTableViewCell.h
//  MailboxForwarding
//
//  Created by Johnathan Chapin on 6/18/13.
//  Copyright (c) 2013 Boostrot, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBFTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *envelopeImage;

@end
