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
/** HomeworkDailyCollectionViewController
 *
 * 所有作业类型
 */
@interface HomeworkDailyCollectionViewController : UICollectionViewController<UICollectionViewDelegate,UICollectionViewDataSource>
///作业类型数组
@property (strong,nonatomic) TaskObj *taskObj;
-(void)resizeItemSize;
@end
