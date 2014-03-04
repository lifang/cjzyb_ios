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

@interface HomeworkTypeCollctionCell : UICollectionViewCell
///作业任务是否完成
@property (assign,nonatomic) BOOL isFinished;
@property (assign,nonatomic) HomeworkType homeworkType;
@property (strong,nonatomic) NSString *homeWorkRankingName;
@end
