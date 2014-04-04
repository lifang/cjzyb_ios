//
//  SelectingChallengeObject.m
//  cjzyb_ios
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectingChallengeObject.h"

@implementation SelectingChallengeObject
+(NSArray *)parseSelectingChallengeFromQuestion{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSString *path = [Utility returnPath];
    path = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate]; //日期对应的文件夹(task文件夹)
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"questions.json"]];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        [Utility errorAlert:@"获取question文件失败!"];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (!dic || ![dic objectForKey:@"selecting"]) {
            [Utility errorAlert:@"文件格式错误!"];
            return nil;
        }
        NSDictionary *dicc = [dic objectForKey:@"selecting"];
        if (!(dicc && [dicc objectForKey:@"specified_time"] && [dicc objectForKey:@"questions"])) {
            [Utility errorAlert:@"文件格式错误!"];
        }else{
            NSString *timeLimit = [dicc objectForKey:@"specified_time"];
            NSArray *questions = [dicc objectForKey:@"questions"];
            for (NSInteger k = 0; k < questions.count; k ++) {
                NSDictionary *bigQuestion = questions[k];  //大题
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
                            SelectingChallengeObject *obj = [[SelectingChallengeObject alloc] init];
                            obj.seBigID = bigID;
                            obj.seTimeLimit = timeLimit;
                            obj.seID = [question objectForKey:@"id"];
                            
                            //content的解析,要得出类型,题面,附件三个字段
                            NSString *questionContent = [question objectForKey:@"content"];
                            questionContent = [questionContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            NSMutableString *str = [NSMutableString stringWithString:questionContent];
                            [str replaceOccurrencesOfString:@"</file>" withString:@"<file>" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
                            NSMutableArray *contentArray = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"<file>"]];//拆分
                            //去除空字符串 @""
                            NSMutableArray *contentArrayClear = [NSMutableArray array];
                            for(NSString *part in contentArray){
                                if ([part isEqualToString:@""]) {
                                    continue;
                                }
                                [contentArrayClear addObject:part];
                            }
                            if (contentArrayClear.count == 1) {
                                if ([str rangeOfString:@"<file>"].length > 0) {  //有附件
                                    NSString *attachmentString = [contentArrayClear firstObject];
                                    NSArray *attachmentArray = [attachmentString componentsSeparatedByString:@"/"];
                                    NSString *fileString = [attachmentArray lastObject];
                                    obj.seContentAttachment = fileString;
                                    //判断后缀
                                    NSArray *fileStringArray = [fileString componentsSeparatedByString:@"."];
                                    NSString *extensionName = [fileStringArray lastObject];//扩展名
                                    extensionName = [extensionName uppercaseString];
                                    if ([@".BMP.BMPF.ICO.CUR.XBM.GIF.JPEG.JPG.PNG.TIFF.TIF" rangeOfString:extensionName].length > 0) {
                                        //图片
                                        obj.seType = SelectingTypeWatching;
                                    }else{
                                        obj.seType = SelectingTypeListening;
                                    }
                                }else{
                                    obj.seContent = [contentArrayClear firstObject];
                                    obj.seType = SelectingTypeDefault;
                                }
                            }else if (contentArrayClear.count == 2){     //字符串分为两段
                                NSString *attachmentString = [contentArrayClear firstObject];
                                NSArray *attachmentArray = [attachmentString componentsSeparatedByString:@"/"];
                                NSString *fileString = [attachmentArray lastObject];
                                obj.seContentAttachment = fileString;
                                //判断后缀
                                NSArray *fileStringArray = [fileString componentsSeparatedByString:@"."];
                                NSString *extensionName = [fileStringArray lastObject];//扩展名
                                extensionName = [extensionName uppercaseString];
                                if ([@".BMP.BMPF.ICO.CUR.XBM.GIF.JPEG.JPG.PNG.TIFF.TIF" rangeOfString:extensionName].length > 0) {
                                    //图片
                                    obj.seType = SelectingTypeWatching;
                                }else{
                                    obj.seType = SelectingTypeListening;
                                }
                                obj.seContent = [contentArrayClear lastObject];
                            }else{
                                [Utility errorAlert:@"这到底是什么题型?"];
                            }
                            
                            //选项
                            NSString *options = [question objectForKey:@"options"];
                            obj.seOptionsArray = [options componentsSeparatedByString:@";||;"];
                            
                            //正确答案
                            NSString *answerString = [question objectForKey:@"answer"];
                            NSArray *answerArray = [answerString componentsSeparatedByString:@";||;"];
                            NSMutableArray *answerArrayWithoutBlank = [NSMutableArray array];
                            for (int i = 0; i < answerArray.count; i ++) {
                                NSString *str = answerArray[i];
                                if (![str isEqualToString:@""]) {
                                    [answerArrayWithoutBlank addObject:str];
                                }
                            }
                            obj.seRightAnswers = [NSArray arrayWithArray:answerArrayWithoutBlank];
                            
                            [resultArray addObject:obj];
                        }
                    }
                }
            }
            
        }
    }
    
    return resultArray;
}

@end
