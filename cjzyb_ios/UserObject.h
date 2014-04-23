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
@property (nonatomic, strong) NSString *s_no;//学号
///是否是老师
@property (nonatomic,assign) BOOL isTeacher;
///精准分数，满100升一级
@property (assign,nonatomic) int jingzhunScore;
///迅速分数，满100升一级
@property (assign,nonatomic) int xunsuScore;
///捷足分数，满100升一级
@property (assign,nonatomic) int jiezuScore;
///优异分数，满100升一级
@property (assign,nonatomic) int youyiScore;
///牛气分数，满100升一级
@property (assign,nonatomic) int niuqiScore;

///同学列表界面使用
@property (nonatomic,assign) BOOL isExtend;
+(UserObject *)userFromDictionary:(NSDictionary *)aDic;

///保存当前用户
-(void)archiverUser;

///删除当前本地用户
-(void)unarchiverUser;
@end
