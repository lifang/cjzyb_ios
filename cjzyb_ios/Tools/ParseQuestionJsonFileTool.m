//
//  ParseQuestionJsonFileTool.m
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ParseQuestionJsonFileTool.h"
#define koutOfCacheDate  (60*60*24*7)
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

+(NSString*)cachFileLocalPathWithFileName:(NSString*)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirectory = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    return [[documentDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"CAOJIZUOYEBEN/%@",fileName]] absoluteString];
}

+(NSString*)downloadFileWithFileName:(NSString*)fileName withFileURLString:(NSString*)urlString{
    if (!urlString) {
        return nil;
    }
    NSString *fileName_ = fileName;
    if (!fileName) {
        fileName_ = [urlString lastPathComponent];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *localFilePath = [ParseQuestionJsonFileTool cachFileLocalPathWithFileName:fileName_];
    if ([fileManager fileExistsAtPath:localFilePath]) {
        NSError *error = nil;
        NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:localFilePath error:&error];
        if (fileAttribute && !error) {
            NSDate *expirationDate = [fileAttribute valueForKey:@"expirationDate"];
            if ([expirationDate compare:[NSDate date]] != NSOrderedAscending) {
                 return localFilePath;
            }
        }
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (data) {
        [data writeToFile:localFilePath atomically:NO];
        return localFilePath;
    }
    return nil;
}

//TODO:根据题目的json文件解析出朗读类型的数据
+(void)parseQuestionJsonFile:(NSString*)jsonFilePath withReadingQuestionArray:( void(^)(NSArray *readingQuestionArr,NSInteger specifiedTime))questionArr withParseError:(void (^)(NSError *error))failure{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
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
                            sentence.readingSentenceLocalFileURL = [ParseQuestionJsonFileTool downloadFileWithFileName:sentence.readingSentenceID withFileURLString:sentence.readingSentenceResourceURL];
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

//TODO:根据题目的json文件解析出连线类型的数据
+(void)parseQuestionJsonFile:(NSString*)jsonFilePath withLiningSubjectArray:( void(^)(NSArray *liningSubjectArr,NSInteger specifiedTime))questionArr withParseError:(void (^)(NSError *error))failure{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
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
        NSDictionary *liningDic = [questionData objectForKey:@"lining"];
        if (liningDic && liningDic.count > 0) {
            NSInteger time = 0;
            NSString *specifiedTime = [Utility filterValue:[liningDic objectForKey:@"specified_time"]];
            if (specifiedTime) {
                time = specifiedTime.intValue;
            }
            
            NSArray *subQuestionArr = [liningDic objectForKey:@"questions"];
            if (subQuestionArr && subQuestionArr.count > 0) {
                NSMutableArray *liningSubjectList = [NSMutableArray array];
                for (NSDictionary *subDic in subQuestionArr) {
                    LineSubjectObj *lineSubjectObj = [[LineSubjectObj alloc] init];
                    lineSubjectObj.lineSubjectID = [Utility filterValue:[subDic objectForKey:@"id"]];
                    NSDictionary *liningSentenceDic = ([subDic objectForKey:@"branch_questions"] && [[subDic objectForKey:@"branch_questions"] count] > 0)?[[subDic objectForKey:@"branch_questions"] firstObject]:nil;
                    if (liningSentenceDic && liningSentenceDic.count > 0) {
                        NSString *sentenceID = [Utility filterValue:[liningSentenceDic objectForKey:@"id"]];
                        NSString *content = [Utility filterValue:[liningSentenceDic objectForKey:@"content"]];
                        if (content) {//拆分字符串
                            NSMutableArray *lineSentenceList = [NSMutableArray array];
                            for (NSString *sentenceStr in [content componentsSeparatedByString:@";||;"]) {
                                NSArray *separateArray = [sentenceStr componentsSeparatedByString:@"<=>"];
                                if (separateArray && separateArray.count >= 2) {
                                    LineDualSentenceObj *lineSentence = [[LineDualSentenceObj alloc] init];
                                    lineSentence.lineDualSentenceID = sentenceID;
                                    lineSentence.lineDualSentenceLeft = [separateArray firstObject];
                                    lineSentence.lineDualSentenceRight = [separateArray lastObject];
                                    [lineSentenceList addObject:lineSentence];
                                }
                            }
                            lineSubjectObj.lineSubjectSentenceArray = lineSentenceList;
                        }
                    }
                    [liningSubjectList addObject:lineSubjectObj];
                }
                if (questionArr) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        questionArr(liningSubjectList,time);
                    });
                }
            }else{
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure([NSError errorWithDomain:@"" code:1002 userInfo:@{@"msg": @"没有连线题目"}]);
                    });
                }
                
                return;
            }
        }else{
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:@"" code:1001 userInfo:@{@"msg": @"没有连线题型"}]);
                });
            }
            return;
        }
    });
}
@end
