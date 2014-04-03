//
//  UserObjDaoInterface.m
//  cjzyb_ios
//
//  Created by david on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UserObjDaoInterface.h"
#import "ASIFormDataRequest.h"
@implementation UserObjDaoInterface
///修改用户的昵称和头像
+(void)modifyUserNickNameAndHeaderImageWithUserId:(NSString*)userId withUserName:(NSString*)name withUserNickName:(NSString*)nickName withHeaderData:(NSData*)headerData withSuccess:(void (^)(NSString *msg))success withFailure:(void(^)(NSError *error))failure{
    if (!userId || (!nickName && !headerData)) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/modify_person_info",kHOST];
    DLog(@"修改同学信息url:%@",urlString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
    [request setRequestMethod:@"POST"];
    [request setPostValue:userId forKey:@"student_id"];
    [request setPostValue:name?:@"" forKey:@"name"];
    if (nickName) {
        [request setPostValue:nickName forKey:@"nickname"];
    }
    if (headerData) {
        [request setData:headerData forKey:@"avatar"];
    }
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success([Utility filterValue:[dicData objectForKey:@"notice"]]);
            }
        });
    } withFailure:failure];
}

///获取用户成就信息
+(void)downloadUserAchievementWithUserId:(NSString*)userId withGradeID:(NSString*)gradeID withSuccess:(void(^)(int youxi,int xunsu,int jiezu,int jingzhun))success withFailure:(void(^)(NSError *error))failure{
//    kHOST/api/students/get_my_archivements?school_class_id=83&student_id=73
    if (!userId || !gradeID || [[gradeID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/get_my_archivements?school_class_id=%@&student_id=%@",kHOST,gradeID,userId];
    DLog(@"修改同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        int youyi = 0,jingzhun = 0,xunsu = 0,jiezu = 0;
        for (NSDictionary *scoreDic in [dicData objectForKey:@"archivements"]) {
            //                    TYPES_NAME = {0 => "优异", 1 => "精准", 2 => "迅速", 3 => "捷足"}
            NSString *type = [Utility filterValue:[scoreDic objectForKey:@"archivement_types"]];
            if (type) {
                switch (type.intValue) {
                    case 0:
                    {
                        NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                        youyi = score?score.intValue:0;
                    }
                        break;
                    case 1:
                    {
                        NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                        jingzhun = score?score.intValue:0;
                    }
                        break;
                    case 2:
                    {
                        NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                        xunsu = score?score.intValue:0;
                    }
                        break;
                    case 3:
                    {
                        NSString *score = [Utility filterValue:[scoreDic objectForKey:@"archivement_score"]];
                        jiezu = score?score.intValue:0;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(youyi,xunsu,jiezu,jingzhun);
            }
        });
    } withFailure:failure];
}

///加入新班级
+(void)joinNewGradeWithUserId:(NSString*)userId withIdentifyCode:(NSString*)identifyCode withSuccess:(void(^)(UserObject *userObj,ClassObject *gradeObj))success withFailure:(void(^)(NSError *error))failure{
    if (!userId || !identifyCode || [[identifyCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/validate_verification_code",kHOST];
    DLog(@"修改同学信息url:%@",urlString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
    [request setRequestMethod:@"POST"];
    [request setPostValue:userId forKey:@"student_id"];
    [request setPostValue:identifyCode forKey:@"verification_code"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        NSDictionary *userDic = [dicData objectForKey:@"student"];
        NSDictionary *gradeDic = [dicData objectForKey:@"class"];
        UserObject *user = [[UserObject alloc] init];
        user.userId = [Utility filterValue:[userDic objectForKey:@"id"]];
//        user.userId = [Utility filterValue:[userDic objectForKey:@"user_id"]];//user_id代表
        user.name = [Utility filterValue:[userDic objectForKey:@"name"]];
        user.nickName = [Utility filterValue:[userDic objectForKey:@"nickname"]];
        user.headUrl = [Utility filterValue:[userDic objectForKey:@"avatar_url"]];
        
        ClassObject *grade = [[ClassObject alloc] init];
        grade.classId = [Utility filterValue:[gradeDic objectForKey:@"id"]];
        grade.name = [Utility filterValue:[gradeDic objectForKey:@"name"]];
        grade.tName = [Utility filterValue:[gradeDic objectForKey:@"tearcher_name"]];
        grade.tId = [Utility filterValue:[gradeDic objectForKey:@"tearcher_id"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                DLog(@"%@",dicData);
                success(user,grade);
            }
        });
    } withFailure:failure];
}

///获取当前用户加入的班级列表
+(void)dowloadGradeListWithUserId:(NSString*)userId withSuccess:(void(^)(NSArray *gradeList))success withFailure:(void(^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/get_my_classes?student_id=%@",kHOST,userId];
    DLog(@"修改同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        NSMutableArray *classArr = [NSMutableArray array];
        for (NSDictionary *gradeDic in [dicData objectForKey:@"classes"]) {
            ClassObject *grade = [[ClassObject alloc] init];
            grade.classId = [Utility filterValue:[gradeDic objectForKey:@"class_id"]];
            grade.name = [Utility filterValue:[gradeDic objectForKey:@"class_name"]];
            [classArr addObject:grade];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(classArr);
            }
        });
    } withFailure:failure];
}

///切换班级
+(void)exchangeGradeWithUserId:(NSString*)userId withGradeId:(NSString*)gradeId withSuccess:(void(^)(UserObject *userObj,ClassObject *gradeObj))success withFailure:(void(^)(NSError *error))failure{
    if (!userId || !gradeId ) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/students/get_class_info?student_id=%@&school_class_id=%@",kHOST,userId,gradeId];
    DLog(@"修改同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        NSDictionary *userDic = [dicData objectForKey:@"student"];
        NSDictionary *gradeDic = [dicData objectForKey:@"class"];
        UserObject *user = [[UserObject alloc] init];
        user.userId = [Utility filterValue:[userDic objectForKey:@"id"]];
        //        user.userId = [Utility filterValue:[userDic objectForKey:@"user_id"]];//user_id代表
        user.name = [Utility filterValue:[userDic objectForKey:@"name"]];
        user.nickName = [Utility filterValue:[userDic objectForKey:@"nickname"]];
        user.headUrl = [Utility filterValue:[userDic objectForKey:@"avatar_url"]];
        
        ClassObject *grade = [[ClassObject alloc] init];
        grade.classId = [Utility filterValue:[gradeDic objectForKey:@"id"]];
        grade.name = [Utility filterValue:[gradeDic objectForKey:@"name"]];
        grade.tName = [Utility filterValue:[gradeDic objectForKey:@"tearcher_name"]];
        grade.tId = [Utility filterValue:[gradeDic objectForKey:@"tearcher_id"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                DLog(@"%@",dicData);
                success(user,grade);
            }
        });
    } withFailure:failure];
}
@end
