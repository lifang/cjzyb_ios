//
//  PersonObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

#define P_Id @""
#define P_Nick @""
#define P_Head @""
#define P_Focus @""
#define P_Excellent @""
#define P_Precision @""
#define P_Fast @""
#define P_Foot @""
#define P_Course @""


@interface PersonObject : NSObject

@property (nonatomic, strong) NSString *personId;
@property (nonatomic, strong) NSString *personNick;//昵称
@property (nonatomic, strong) NSString *personHead;//头像
@property (nonatomic, assign) NSInteger personFocus;//关注

@property (nonatomic, assign) NSInteger achievExcellent;//优异
@property (nonatomic, assign) NSInteger achievPrecision;//精准
@property (nonatomic, assign) NSInteger achievFast;//迅速
@property (nonatomic, assign) NSInteger achievFoot;//捷足

@property (nonatomic, strong) NSMutableArray *courseArray;//课程数组

+(PersonObject *)personFronDictionary:(NSDictionary *)aDic;
@end
