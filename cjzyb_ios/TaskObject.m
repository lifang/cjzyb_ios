//
//  TaskObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TaskObject.h"

@implementation TaskObject

+(TaskObject *)taskFromDictionary:(NSDictionary *)aDic {
    TaskObject *task = [[TaskObject alloc]init];
    
    [task setTaskId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"id"]]];
    [task setTaskName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"name"]]];
    [task setStart_time:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"start_time"]]];
    [task setEnd_time:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"end_time"]]];
    [task setQuestion_packages_url:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"question_packages_url"]]];
    [task setQuestion_types:[NSMutableArray arrayWithArray:[aDic objectForKey:@"question_types"]]];
    [task setFinish_types:[NSMutableArray arrayWithArray:[aDic objectForKey:@"finish_types"]]];
    
    NSString *date = [[[NSString stringWithFormat:@"%@",[aDic objectForKey:@"start_time"]] componentsSeparatedByString:@"T"] firstObject];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [task setTaskSandboxFolder:[path stringByAppendingPathComponent:date]];

    return task;
}
@end
