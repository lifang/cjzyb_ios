//
//  DownloadClassmatesInfo.m
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DownloadClassmatesInfo.h"
#import "UserObject.h"
@implementation DownloadClassmatesInfo
+(void)downloadClassmatesinfoWithUserId:(NSString*)userId withClassId:(NSString*)classID withSuccess:(void(^)(NSArray *classmatesArray))success withError:(void (^)(NSError *error))failure{
//http://58.240.210.42:3004/api/students/get_classmates_info?student_id=74&school_class_id=90
    if (!userId || !classID) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/get_classmates_info?student_id=%@&school_class_id=%@",kHOST,userId,classID];
    DLog(@"获得班级同学信息url:%@",urlString);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
        [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
            NSMutableArray *matesList = [NSMutableArray array];
            UserObject *teacher = [[UserObject alloc] init];
            teacher.name = [Utility filterValue:[dicData objectForKey:@"teacher_name"]];
            teacher.headUrl = [Utility filterValue:[dicData objectForKey:@"teacher_avatar_url"]];
            teacher.isTeacher = YES;
            [matesList addObject:teacher];
            for (NSDictionary *mateDic in [dicData objectForKey:@"classmates"]) {
                UserObject *mate = [[UserObject alloc] init];
                mate.studentId = [Utility filterValue:[mateDic objectForKey:@"id"]];
                mate.name = [Utility filterValue:[mateDic objectForKey:@"name"]];
                mate.headUrl = [Utility filterValue:[mateDic objectForKey:@"avatar_url"]];
                for (NSDictionary *scoreDic in [mateDic objectForKey:@"archivement"]) {
//                    TYPES_NAME = {0 => "优异", 1 => "精准", 2 => "迅速", 3 => "捷足"}
                    NSString *type = [Utility filterValue:[scoreDic objectForKey:@"archivement_types"]];
                    if (type) {
                        switch (type.intValue) {
                            case 0:
                            {
                                NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                                mate.youyiScore = score?score.intValue:0;
                            }
                                break;
                            case 1:
                            {
                                NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                                mate.jingzhunScore = score?score.intValue:0;
                            }
                                break;
                            case 2:
                            {
                                NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                                mate.xunsuScore = score?score.intValue:0;
                            }
                                break;
                            case 3:
                            {
                                NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                                mate.jiezuScore = score?score.intValue:0;
                            }
                                break;
                            default:
                                break;
                        }
                    }
                }
                [matesList addObject:mate];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(matesList);
                }
            });
        } withFailure:failure];
}
@end
