//
//  TenSecChallengeObject.h
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenSecChallengeObject : NSObject
@property (nonatomic,strong) NSString *tenBigID; //大题ID
@property (nonatomic,strong) NSString *tenTimeLimit;  //限时
@property (nonatomic,strong) NSString *tenID; //小题ID
@property (nonatomic,strong) NSString *tenQuestionContent; //问题
@property (nonatomic,strong) NSString *tenAnswerOne;  //选项1
@property (nonatomic,strong) NSString *tenAnswerTwo;  //选项2
@property (nonatomic,strong) NSString *tenRightAnswer; //正确答案

+(NSArray *)parseTenSecQuestionsFromFile; //从question.js文件解析出对象数组
@end
