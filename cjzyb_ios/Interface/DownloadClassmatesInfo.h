//
//  DownloadClassmatesInfo.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** DownloadClassmatesInfo
 *
 * 加载同班同学信息及成就
 */
@interface DownloadClassmatesInfo : NSObject
/**
 * @brief 获取同班同学和老师信息
 *
 * @param  userId 当前用户id，classID 用户所在班级
 *
 * @return classmatesArray 同班同学信息
 */
+(void)downloadClassmatesinfoWithUserId:(NSString*)userId withClassId:(NSString*)classID withSuccess:(void(^)(NSArray *classmatesArray))success withError:(void (^)(NSError *error))failure;
@end
