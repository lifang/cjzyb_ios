//
//  HomeworkHistoryCollectionCell.h
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkDailyCollectionViewController.h"
/** HomeworkHistoryCollectionCell
 *
 * 查看所有的历史记录
 */
@interface HomeworkHistoryCollectionCell : UICollectionViewCell
@property (nonatomic,strong) HomeworkDailyCollectionViewController *dailyCollectionViewController;
@end
