//
//  HomeworkDaoInterface.h
//  cjzyb_ios
//
//  Created by david on 14-3-22.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskObj.h"
/** HomeworkDaoInterface
 *
 * 作业和作业类型管理
 */
@interface HomeworkDaoInterface : NSObject
/**
 * @brief 获取当天的任务
 *
 * @param  userId 当前用户id，classID 用户所在班级
 *
 * @return taskObj 当天任务对象
 */
+(void)downloadCurrentTaskWithUserId:(NSString*)userId withClassId:(NSString*)classID withSuccess:(void(^)(TaskObj *taskObj))success withError:(void (^)(NSError *error))failure;

/**
 * @brief 获取历史的任务
 *
 * @param  userId 当前用户id，classID 用户所在班级,currentTaskId 有值排除当前任务，没有值获取所有任务
 *
 * @return taskObjArr 历史任务对象数组
 */
+(void)downloadHistoryTaskWithUserId:(NSString*)userId withClassId:(NSString*)classID withCurrentTaskID:(NSString*)currentTaskId withSuccess:(void(^)(NSArray *taskObjArr))success withError:(void (^)(NSError *error))failure;

/**
 * @brief 根据日期获取任务
 *
 * @param  userId 当前用户id，classID 用户所在班级
 *
 * @return taskObjArr 任务对象数组
 */
+(void)searchTaskWithUserId:(NSString*)userId withClassId:(NSString*)classID withSelectedDate:(NSDate*)selectedDate withSuccess:(void(^)(NSArray *taskObjArr))success withError:(void (^)(NSError *error))failure;
@end
