//
//  TaskObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-1.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** TaskObj
 *
 * 学生任务对象,包含多个作业类型
 */
@interface TaskObj : NSObject
@property (strong,nonatomic) NSString *taskID;
@property (strong,nonatomic) NSString *taskName;
@property (strong,nonatomic) NSString *taskStartDate;
@property (strong,nonatomic) NSString *taskEndDate;
@property (strong,nonatomic) NSString *taskFileDownloadURL;
///这个任务包含的作业类型HomeworkTypeObj
@property (strong,nonatomic) NSArray *taskHomeworkTypeArray;
@end
