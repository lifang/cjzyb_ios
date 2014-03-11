//
//  ParseQuestionJsonFileTool.m
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ParseQuestionJsonFileTool.h"

@interface ParseQuestionJsonFileTool ()
+(id)defaultParseQuestionJsonFileTool;
@end

@implementation ParseQuestionJsonFileTool
+(id)defaultParseQuestionJsonFileTool{
    static ParseQuestionJsonFileTool *questionJsonFileParseTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        questionJsonFileParseTool = [[ParseQuestionJsonFileTool alloc] init];
    });
    return questionJsonFileParseTool;
}
+(void)parseQuestionJsonFile:(NSString*)jsonFilePath withReadingQuestionArray:( void(^)(NSArray *readingQuestionArr,NSInteger specifiedTime))questionArr withParseError:(void (^)(NSError *error))failure{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *jsonError = nil;
        NSDictionary *questionData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError || !questionData || ![questionData isKindOfClass:[NSDictionary class]]) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:@"" code:1000 userInfo:@{@"msg": @"json文件错误"}]);
                });
            }
            return;
        }
        NSDictionary *readingDic = [questionData objectForKey:@"reading"];
        if (readingDic && readingDic.count > 0) {
            NSInteger time = 0;
            NSString *specifiedTime = [Utility filterValue:[readingDic objectForKey:@"specified_time"]];
            if (specifiedTime) {
                time = specifiedTime.intValue;
            }
            
            NSArray *subQuestionArr = [readingDic objectForKey:@"questions"];
            if (subQuestionArr && subQuestionArr.count > 0) {
                NSMutableArray *readingHomeworkList = [NSMutableArray array];
                for (NSDictionary *subDic in subQuestionArr) {
                    ReadingHomeworkObj *homeworkObj = [[ReadingHomeworkObj alloc] init];
                    homeworkObj.readingHomeworkID = [Utility filterValue:[subDic objectForKey:@"id"]];
                    
                    NSMutableArray *readingSentenceList = [NSMutableArray array];
                    for (NSDictionary *subSentenceDic in [subDic objectForKey:@"branch_questions"]) {
                        ReadingSentenceObj *sentence = [[ReadingSentenceObj alloc] init];
                        sentence.readingSentenceID = [Utility filterValue:[subSentenceDic objectForKey:@"id"]];
                        sentence.readingSentenceContent = [Utility filterValue:[subSentenceDic objectForKey:@"content"]];
                        NSString *url = [Utility filterValue:[subSentenceDic objectForKey:@"resource_url"]];
                        if (url) {
                            sentence.readingSentenceResourceURL = [NSString stringWithFormat:@"%@%@",kHOST,url];
                        }
                        
                        [readingSentenceList addObject:sentence];
                    }
                    homeworkObj.readingHomeworkSentenceObjArray = readingSentenceList;
                    [readingHomeworkList addObject:homeworkObj];
                }
                if (questionArr) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         questionArr(readingHomeworkList,time);
                    });
                }
            }else{
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       failure([NSError errorWithDomain:@"" code:1002 userInfo:@{@"msg": @"没有朗读题目"}]);
                    });
                }
                
                return;
            }
        }else{
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:@"" code:1001 userInfo:@{@"msg": @"没有朗读题型"}]);
                });
            }
            return;
        }
    });
}
@end
