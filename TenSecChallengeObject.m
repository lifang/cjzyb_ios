//
//  TenSecChallengeObject.m
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TenSecChallengeObject.h"

@implementation TenSecChallengeObject
+ (NSArray *)parseTenSecQuestionsFromFile{
    NSMutableArray *resultArray = [NSMutableArray array];//返回值
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    //把path拼成真实文件路径
//    
//    path = [[NSBundle mainBundle] pathForResource:@"questions_lastest" ofType:@"js"]; //测试
    
    NSString *path = [Utility returnPath];
    path = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate]; //日期对应的文件夹(task文件夹)
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"questions.json"]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        [Utility errorAlert:@"获取question文件失败!"];
        return nil;
    }else{
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!dic || ![dic objectForKey:@"time_limit"]) {
            [Utility errorAlert:@"文件格式错误!"];
            return nil;
        }
        NSDictionary *dicc = [dic objectForKey:@"time_limit"];
        if (!(dicc && [dicc objectForKey:@"specified_time"] && [dicc objectForKey:@"questions"])) {
            [Utility errorAlert:@"文件格式错误!"];
        }else{
            NSString *timeLimit = [dicc objectForKey:@"specified_time"];
            NSArray *questions = [dicc objectForKey:@"questions"];
            NSDictionary *bigQuestion = questions[0];  //大题,十速挑战只有一道大题
            if (!(bigQuestion && [bigQuestion objectForKey:@"branch_questions"])) {
                [Utility errorAlert:@"没有题目!"];
            }else{
                NSString *bigID = [bigQuestion objectForKey:@"id"];
                NSArray *branchQuestions = [bigQuestion objectForKey:@"branch_questions"];
                for (int i = 0; i < branchQuestions.count; i ++) {
                    NSDictionary *question = branchQuestions[i];
                    if (!(question && [question objectForKey:@"id"])) {
                        [Utility errorAlert:@"没有题目!"];
                    }else{
                        TenSecChallengeObject *obj = [[TenSecChallengeObject alloc] init];
                        obj.tenBigID = bigID;
                        obj.tenTimeLimit = timeLimit;
                        obj.tenID = [question objectForKey:@"id"];
                        obj.tenQuestionContent = [question objectForKey:@"content"];
                        obj.tenRightAnswer = [question objectForKey:@"anwser"];
                        NSString *options = [question objectForKey:@"options"];
                        NSArray *optionsArray = [options componentsSeparatedByString:@";||;"];
                        obj.tenAnswerOne = [optionsArray firstObject];
                        obj.tenAnswerTwo = [optionsArray lastObject];
                        
                        [resultArray addObject:obj];
                    }
                }
            }
        }
    }
    return [NSArray arrayWithArray:resultArray];
}
@end
