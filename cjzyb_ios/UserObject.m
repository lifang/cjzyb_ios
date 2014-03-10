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
    
    [user setStudentId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"id"]]];
    [user setName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"name"]]];
    [user setUserId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"user_id"]]];
    [user setNickName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"nickname"]]];
    [user setHeadUrl:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"avatar_url"]]];
    
    return user;
}
@end
