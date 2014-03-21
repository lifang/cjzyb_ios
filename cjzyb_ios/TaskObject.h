//
//  TaskObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskObject : NSObject

@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *start_time;//起始时间
@property (nonatomic, strong) NSString *end_time;//结束时间
@property (nonatomic, strong) NSMutableArray *question_types;
@property (nonatomic, strong) NSMutableArray *finish_types;
@property (nonatomic, strong) NSString *question_packages_url;// 包的下载路径
@property (nonatomic, strong) NSString *answer_packages_url;// 包的下载路径

+(TaskObject *)taskFromDictionary:(NSDictionary *)aDic;
@end
