//
//  StudentTableViewCell.m
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "StudentTableViewCell.h"
@interface StudentTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *youyiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinzhunLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiezuLabel;
@property (weak, nonatomic) IBOutlet UILabel *xunsuLabel;

@end
@implementation StudentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
