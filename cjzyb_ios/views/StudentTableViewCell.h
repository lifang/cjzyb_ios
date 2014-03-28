//
//  StudentTableViewCell.h
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *youyiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinzhunLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiezuLabel;
@property (weak, nonatomic) IBOutlet UILabel *xunsuLabel;
@end
