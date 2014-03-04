//
//  TenSecChallengeObject.h
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenSecChallengeObject : NSObject
@property (nonatomic,strong) NSString *tenID; 
@property (nonatomic,strong) NSString *tenQuestionContent; //问题
@property (nonatomic,strong) NSString *tenAnswerOne;
@property (nonatomic,strong) NSString *tenAnswerTwo;
@property (nonatomic,strong) NSString *tenRightAnswer; //正确答案
@end
