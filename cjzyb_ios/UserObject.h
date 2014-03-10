//
//  UserObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic, strong) NSString *studentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *userId;


+(UserObject *)userFromDictionary:(NSDictionary *)aDic;
@end
