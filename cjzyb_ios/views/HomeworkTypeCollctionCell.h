//
//  HomeworkTypeCollctionCell.h
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkTypeObj.h"
/** HomeworkTypeCollctionCell
 *
 * 作业类型
 */
@protocol HomeworkTypeCollctionCellDelegate;
@interface HomeworkTypeCollctionCell : UICollectionViewCell
///作业任务是否完成
@property (assign,nonatomic) BOOL isFinished;
///排名按钮
@property (weak, nonatomic) IBOutlet UIButton *rankingButton;
///排名按钮出现
@property (assign,nonatomic) BOOL isShowRankingBtn;

@property (assign,nonatomic) HomeworkType homeworkType;
@property (weak,nonatomic) id <HomeworkTypeCollctionCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *path;
@end

@protocol HomeworkTypeCollctionCellDelegate <NSObject>

-(void)homeworkTypeCollctionCell:(HomeworkTypeCollctionCell*)cell rankingButtonClickedAtIndexPath:(NSIndexPath*)path;

@end