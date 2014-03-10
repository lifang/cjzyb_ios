//
//  OrdinaryAnswerObject.h
//  cjzyb_ios
//
//  Created by apple on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//


//answer.js中答案的一般格式

#import <Foundation/Foundation.h>

@interface OrdinaryAnswerObject : NSObject
@property (nonatomic,strong) NSString *answerID;   //ID
@property (nonatomic,strong) NSString *answerAnswer;  //答案
@property (nonatomic,strong) NSString *answerRatio;  //正确率
@end
