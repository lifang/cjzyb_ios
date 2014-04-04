//
//  UserObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

+(UserObject *)userFromDictionary:(NSDictionary *)aDic {
    UserObject *user = [[UserObject alloc]init];
    
    [user setStudentId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"id"]]]];
    [user setName:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"name"]]]];
    [user setUserId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"user_id"]]]];
    [user setNickName:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"nickname"]]]];
    [user setHeadUrl:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"avatar_url"]]]];
    
    return user;
}

///保存当前用户
-(void)archiverUser{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"student.plist"];
    if ([fileManage fileExistsAtPath:filename]) {
        [fileManage removeItemAtPath:filename error:nil];
    }
    NSDictionary *classDic = @{@"id": (self.studentId?:@""),@"name":(self.name?:@""),@"user_id":(self.userId?:@""),@"nickname":(self.nickName?:@""),@"avatar_url":(self.headUrl?:@"")};
    [NSKeyedArchiver archiveRootObject:classDic toFile:filename];
}

///删除当前本地用户
-(void)unarchiverUser{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"student.plist"];
    NSDictionary *userDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    self.userId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"user_id"]];
    self.name = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
    self.studentId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
    self.nickName = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"nickname"]];
    self.headUrl = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"avatar_url"]];
}

-(void)setNickName:(NSString *)nickName{
    _nickName = nickName;
}
@end
