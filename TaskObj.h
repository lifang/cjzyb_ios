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
///后台任务显示的备注信息
@property (strong,nonatomic) NSString *taskName;
@property (strong,nonatomic) NSString *taskStartDate;
@property (strong,nonatomic) NSString *taskEndDate;
///题包下载路径
@property (strong,nonatomic) NSString *taskFileDownloadURL;
///历史记录中答案的json文件下载路径
@property (strong,nonatomic) NSString *taskAnswerFileDownloadURL;
///卡片数量
@property (assign,nonatomic) int taskKnowlegeCount;
///这个任务包含的作业类型HomeworkTypeObj
@property (strong,nonatomic) NSArray *taskHomeworkTypeArray;
@end
