//
//  ParseQuestionJsonFileTool.h
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadingHomeworkObj.h"
#import "LineSubjectObj.h"
#import "LineDualSentenceObj.h"
/** ParseQuestionJsonFileTool
 *
 * 解析题目json文件的工具
 */
@interface ParseQuestionJsonFileTool : NSObject

/**
 * @brief 根据题目的json文件解析出朗读类型的数据
 *
 * @param  jsonFilePath 题目json文件本地路径
 *
 * @return readingQuestionArr：ReadingHomeworkObj对象数组，，specifiedTime：朗读类型题目所要的最长时间限制,,error:错误 消息
 */
+(void)parseQuestionJsonFile:(NSString*)jsonFilePath withReadingQuestionArray:( void(^)(NSArray *readingQuestionArr,NSInteger specifiedTime))questionArr withParseError:(void (^)(NSError *error))failure;


/*!
 * @brief 根据题目的json文件解析出连线类型的数据
 *
 * @param  jsonFilePath 题目json文件本地路径
 *
 * @return liningSubjectArr LineSubjectObj对象的数组 ，specifiedTime：连线类型题目所要的最长时间限制,,error:错误 消息
 *
 */
+(void)parseQuestionJsonFile:(NSString*)jsonFilePath withLiningSubjectArray:( void(^)(NSArray *liningSubjectArr,NSInteger specifiedTime))questionArr withParseError:(void (^)(NSError *error))failure;

///获取有做题记录的朗读题目
+(void)parseQuestionFromLastAnswerUpdateVersionJsonFileWithUserId:(NSString*)userId withTask:(TaskObj*)task withReadingHistoryArray:( void(^)(NSArray *readingQuestionArr,int currentQuestionIndex,int currentQuestionItemIndex,int status,NSString *updateTime,NSString *userTime,int specifyTime))questionArr withParseError:(void (^)(NSError *error))failure;

@end
