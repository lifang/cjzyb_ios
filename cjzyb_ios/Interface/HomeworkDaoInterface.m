//
//  HomeworkDaoInterface.m
//  cjzyb_ios
//
//  Created by david on 14-3-22.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkDaoInterface.h"
#import "HomeworkTypeObj.h"
#import "ASIFormDataRequest.h"
@implementation HomeworkDaoInterface

//判断
+(BOOL)compareTimeWithString:(NSString *)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *endDate = [dateFormatter dateFromString:string];
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:nowDate toDate:endDate options:0];
    int hour =[d hour];int day = [d day];int month = [d month];int minute = [d minute];int second = [d second];int year = [d year];
    
    if (year>0 || month>0 || day>0 || hour>0 || minute>0 || second>0) {
        return NO;
    }else
        return YES;
}

+(void)downloadCurrentTaskWithUserId:(NSString*)userId withClassId:(NSString*)classID withSuccess:(void(^)(TaskObj *taskObj))success withError:(void (^)(NSError *error))failure{

    if (!userId || !classID) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/get_newer_task?student_id=%@&school_class_id=%@",kHOST,userId,classID];
    DLog(@"获得班级同学信息url:%@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
        NSArray *taskArr = [dicData objectForKey:@"tasks"];
        NSString *knowlegeCount = [Utility filterValue:[dicData objectForKey:@"knowledges_cards_count"]];
        if (!taskArr || taskArr.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"当前没有任务"}]);
                }
            });
            return;
        }
        
        NSDictionary *taskDic = [taskArr firstObject];
        if (!taskDic || taskDic.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"获取数据失败"}]);
                }
            });
            return;
        }
        
        TaskObj *taskObj = [TaskObj taskFromDictionary:taskDic];
        
        BOOL isExipre = [HomeworkDaoInterface compareTimeWithString:taskObj.taskEndDate];
        taskObj.isExpire = isExipre;
        
        //道具 0减少时间   1显示正确答案
        NSArray *propsArr = [dicData objectForKey:@"props"];
        for (NSDictionary *propsDic in propsArr) {
            NSString *type = [Utility filterValue:[propsDic objectForKey:@"types"]];
            NSString *number = [Utility filterValue:[propsDic objectForKey:@"number"]];
            if ([type integerValue]==1) {
                [DataService sharedService].number_correctAnswer = number ?number.intValue:0;
            }else if ([type integerValue]==0){
                [DataService sharedService].number_reduceTime = number ?number.intValue:0;
            }
        }
        
        [DataService sharedService].cardsCount = knowlegeCount?knowlegeCount.intValue:0;
        
        
        NSMutableArray *homeworkTypeList = [NSMutableArray array];
        NSArray *undoTypeArr = [taskDic objectForKey:@"question_types"];
        NSArray *finishedTypeArr = [taskDic objectForKey:@"finish_types"];
        for (int index = 0; index < undoTypeArr.count; index++) {
            NSString *index_string = [undoTypeArr objectAtIndex:index];
            HomeworkTypeObj *type = [[HomeworkTypeObj alloc] init];
            type.homeworkType = [HomeworkDaoInterface convertTypeFromInt:[[undoTypeArr objectAtIndex:index] intValue]];
            
            if ([finishedTypeArr containsObject:index_string]) {
                type.homeworkTypeIsFinished = YES;
            }else {
                type.homeworkTypeIsFinished = NO;
            }
            if (taskObj.isExpire==YES) {
                type.homeworkTypeIsRanking = YES;
            }else {
                type.homeworkTypeIsRanking = NO;
            }
            
            [homeworkTypeList addObject:type];
            type = nil;
        }
        
        taskObj.taskHomeworkTypeArray = homeworkTypeList;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(taskObj);
            }
        });
    } withFailure:failure];
}
//TODO:作业类型转换
+(HomeworkType)convertTypeFromInt:(int)type{
    //TYPES_NAME = {0 => "听力", 1 => "朗读",  2 => "十速挑战", 3 => "选择", 4 => "连线", 5 => "完型填空", 6 => "排序"
    switch (type) {
        case 0:
            return  HomeworkType_listeningAndWrite;
        case 1:
            return HomeworkType_reading;
        case 2:
            return HomeworkType_quick;
        case 3:
            return HomeworkType_select;
        case 4:
            return HomeworkType_line;
        case 5:
            return HomeworkType_fillInBlanks;
        case 6:
            return HomeworkType_sort;
        default:
            return HomeworkType_other;
            break;
    }
}

//TODO:作业类型转换
+(NSString*)convertStringFromType:(HomeworkType)type{
    //TYPES_NAME = {0 => "听力", 1 => "朗读",  2 => "十速挑战", 3 => "选择", 4 => "连线", 5 => "完型填空", 6 => "排序"
    switch (type) {
        case HomeworkType_listeningAndWrite:
            return  @"0";
        case HomeworkType_reading:
            return @"1";
        case HomeworkType_quick:
            return @"2";
        case HomeworkType_select:
            return @"3";
        case HomeworkType_line:
            return @"4";
        case HomeworkType_fillInBlanks:
            return @"5";
        case HomeworkType_sort:
            return @"6";
        default:
            return @"7";
            break;
    }
}

///获取历史任务
+(void)downloadHistoryTaskWithUserId:(NSString*)userId withClassId:(NSString*)classID withCurrentTaskID:(NSString*)currentTaskId withSuccess:(void(^)(NSArray *taskObjArr))success withError:(void (^)(NSError *error))failure{
    if (!userId || !classID) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = nil;
    if (currentTaskId) {
        urlString = [NSString stringWithFormat:@"%@/api/students/get_more_tasks?student_id=%@&school_class_id=%@&today_newer_id=%@",kHOST,userId,classID,currentTaskId];
    }else{
    urlString = [NSString stringWithFormat:@"%@/api/students/get_more_tasks?student_id=%@&school_class_id=%@",kHOST,userId,classID];
    }
    DLog(@"获得班级同学信息url:%@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
        NSArray *taskArr = [dicData objectForKey:@"tasks"];
        NSString *knowlegeCount = [Utility filterValue:[dicData objectForKey:@"knowledges_cards_count"]];
        if (!taskArr || taskArr.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"没有历史任务"}]);
                }
            });
            return;
        }
        
        NSMutableArray *taskList = [NSMutableArray array];
        for (NSDictionary *taskDic in taskArr) {
            if (!taskDic || taskDic.count <= 0) {
                continue;
            }
            TaskObj *taskObj = [TaskObj taskFromDictionary:taskDic];
            BOOL isExipre = [HomeworkDaoInterface compareTimeWithString:taskObj.taskEndDate];
            taskObj.isExpire = isExipre;
            
            
            //道具 0减少时间   1显示正确答案
            NSArray *propsArr = [dicData objectForKey:@"props"];
            for (NSDictionary *propsDic in propsArr) {
                NSString *type = [Utility filterValue:[propsDic objectForKey:@"types"]];
                NSString *number = [Utility filterValue:[propsDic objectForKey:@"number"]];
                if ([type integerValue]==1) {
                    [DataService sharedService].number_correctAnswer = number ?number.intValue:0;
                }else if ([type integerValue]==0){
                    [DataService sharedService].number_reduceTime = number ?number.intValue:0;
                }
            }
            
            [DataService sharedService].cardsCount = knowlegeCount?knowlegeCount.intValue:0;
            
            NSMutableArray *homeworkTypeList = [NSMutableArray array];
            NSArray *undoTypeArr = [taskDic objectForKey:@"question_types"];
            NSArray *finishedTypeArr = [taskDic objectForKey:@"finish_types"];
            for (int index = 0; index < undoTypeArr.count; index++) {
                NSString *index_string = [undoTypeArr objectAtIndex:index];
                HomeworkTypeObj *type = [[HomeworkTypeObj alloc] init];
                type.homeworkType = [HomeworkDaoInterface convertTypeFromInt:[[undoTypeArr objectAtIndex:index] intValue]];
                
                if ([finishedTypeArr containsObject:index_string]) {
                    type.homeworkTypeIsFinished = YES;
                }else {
                    type.homeworkTypeIsFinished = NO;
                }
                
                if (taskObj.isExpire==YES) {
                    type.homeworkTypeIsRanking = YES;
                }else {
                    type.homeworkTypeIsRanking = NO;
                }
                
                [homeworkTypeList addObject:type];
                type = nil;
            }
            
            taskObj.taskHomeworkTypeArray = homeworkTypeList;
            
            [taskList addObject:taskObj];
        }
        
        if (taskList.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"当前没有历史任务"}]);
                }
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(taskList);
            }
        });
    } withFailure:failure];
}


///获取排行数据
+(void)downloadHomeworkRankingWithTaskId:(NSString*)taskId withHomeworkType:(HomeworkType)homeworkType withSuccess:(void(^)(NSArray *rankingObjArr))success withError:(void (^)(NSError *error))failure{
    if (!taskId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/get_rankings?types=%@&pub_id=%@",kHOST,[HomeworkDaoInterface convertStringFromType:homeworkType],taskId];
    DLog(@"获得班级同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        NSArray *rankArr = [dicData objectForKey:@"record_details"];
        if (!rankArr || rankArr.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"当前没有排行数据"}]);
                }
            });
            return;
        }
        
        NSMutableArray *rankList = [NSMutableArray array];
        for (NSDictionary *rankDic in rankArr) {
            RankingObject *rankObj = [[RankingObject alloc] init];
            rankObj.rankingUserId = [Utility filterValue:[rankDic objectForKey:@"student_id"]];
            rankObj.rankingScore = [Utility filterValue:[rankDic objectForKey:@"score"]];
            rankObj.rankingName = [Utility filterValue:[rankDic objectForKey:@"name"]];
            rankObj.rankingHeaderURL = [Utility filterValue:[rankDic objectForKey:@"avatar_url"]];
            [rankList addObject:rankObj];
        }
        
        if (rankList.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"当前没有排行数据"}]);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(rankList);
            }
        });
    } withFailure:failure];
}

///根据日期获取任务
+(void)searchTaskWithUserId:(NSString*)userId withClassId:(NSString*)classID withSelectedDate:(NSDate*)selectedDate withSuccess:(void(^)(NSArray *taskObjArr))success withError:(void (^)(NSError *error))failure{
    if (!userId || !classID || !selectedDate) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    //2001-12-14
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *timeString = [dateFormatter stringFromDate:selectedDate];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/search_tasks",kHOST];
    DLog(@"获得班级同学信息url:%@",urlString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
    [request setRequestMethod:@"POST"];
    [request setPostValue:userId forKey:@"student_id"];
    [request setPostValue:classID forKey:@"school_class_id"];
    [request setPostValue:timeString forKey:@"date"];
    
   [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        NSArray *taskArr = [dicData objectForKey:@"tasks"];
        NSString *knowlegeCount = [Utility filterValue:[dicData objectForKey:@"knowledges_cards_count"]];
        if (!taskArr || taskArr.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"当前没有任务"}]);
                }
            });
            return;
        }
        
        NSMutableArray *taskList = [NSMutableArray array];
        for (NSDictionary *taskDic in taskArr) {
            if (!taskDic || taskDic.count <= 0) {
                continue;
            }
            TaskObj *taskObj = [TaskObj taskFromDictionary:taskDic];
            BOOL isExipre = [HomeworkDaoInterface compareTimeWithString:taskObj.taskEndDate];
            taskObj.isExpire = isExipre;
            
            //道具 0减少时间   1显示正确答案
            NSArray *propsArr = [dicData objectForKey:@"props"];
            for (NSDictionary *propsDic in propsArr) {
                NSString *type = [Utility filterValue:[propsDic objectForKey:@"types"]];
                NSString *number = [Utility filterValue:[propsDic objectForKey:@"number"]];
                if ([type integerValue]==1) {
                    [DataService sharedService].number_correctAnswer = number ?number.intValue:0;
                }else if ([type integerValue]==0){
                    [DataService sharedService].number_reduceTime = number ?number.intValue:0;
                }
            }
            
            [DataService sharedService].cardsCount = knowlegeCount?knowlegeCount.intValue:0;
            
            NSMutableArray *homeworkTypeList = [NSMutableArray array];
            NSArray *undoTypeArr = [taskDic objectForKey:@"question_types"];
            NSArray *finishedTypeArr = [taskDic objectForKey:@"finish_types"];
            for (int index = 0; index < undoTypeArr.count; index++) {
                NSString *index_string = [undoTypeArr objectAtIndex:index];
                HomeworkTypeObj *type = [[HomeworkTypeObj alloc] init];
                type.homeworkType = [HomeworkDaoInterface convertTypeFromInt:[[undoTypeArr objectAtIndex:index] intValue]];
                
                if ([finishedTypeArr containsObject:index_string]) {
                    type.homeworkTypeIsFinished = YES;
                }else {
                    type.homeworkTypeIsFinished = NO;
                }
                if (taskObj.isExpire==YES) {
                    type.homeworkTypeIsRanking = YES;
                }else {
                    type.homeworkTypeIsRanking = NO;
                }
                
                [homeworkTypeList addObject:type];
                type = nil;
            }
            
            taskObj.taskHomeworkTypeArray = homeworkTypeList;
            
            [taskList addObject:taskObj];
        }
        
        if (taskList.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"当前没有历史任务"}]);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(taskList);
            }
        });
    } withFailure:failure];
}
@end
