//
//  HomeworkRankingTableViewCell.h
//  cjzyb_ios
//
//  Created by david on 14-3-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkRankingTableViewCell : UITableViewCell
///分数
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
///名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
///排名
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
///头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end
