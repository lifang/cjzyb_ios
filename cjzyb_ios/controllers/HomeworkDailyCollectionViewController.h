//
//  HomeworkDailyCollectionViewController.h
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkTypeCollctionCell.h"
#import "TaskObj.h"

@protocol HomeworkDailyCollectionViewControllerDelegate ;

/** HomeworkDailyCollectionViewController
 *
 * 所有作业类型
 */
@interface HomeworkDailyCollectionViewController : UICollectionViewController<UICollectionViewDelegate,UICollectionViewDataSource,HomeworkTypeCollctionCellDelegate>
///作业类型数组
@property (strong,nonatomic) TaskObj *taskObj;
@property (weak,nonatomic) id<HomeworkDailyCollectionViewControllerDelegate> delegate;
-(void)resizeItemSize;

@end

@protocol HomeworkDailyCollectionViewControllerDelegate <NSObject>

-(void)homeworkDailyController:(HomeworkDailyCollectionViewController*)controller didSelectedAtIndexPath:(NSIndexPath*)path;
///点击排名按钮
-(void)homeworkDailyController:(HomeworkDailyCollectionViewController*)controller rankingButtonClickedAtIndexPath:(NSIndexPath*)path;
@end