//
//  ParseAnswerJsonFileTool.h
//  cjzyb_ios
//
//  Created by david on 14-3-24.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadingHomeworkObj.h"
/**ParseAnswerJsonFileTool
 *
 * 解析答案json文件，包括写入答案和道具使用次数
 */
@interface ParseAnswerJsonFileTool : NSObject
/**
 * @brief 使用的道具写入json文件
 *@param  jsonFilePath 题目json文件本地路径
 * @param questionId 使用小题ID，proposType 道具类型取值为0和1
 *
 * @return
 */
+(void)writePropsToJsonFile:(NSString*)jsonFilePath withQuestionId:(NSString*)questionId withPropsType:(NSString*)proposType withSuccess:(void (^)())success withFailure:(void (^)(NSError *error))failure;

/**
 * @brief 根据答案的json文件解析出朗读类型的做题记录
 *
 * @param  jsonFilePath 题目json文件本地路径
 *
 * @return readingQuestionArr：ReadingHomeworkObj对象数组,error:错误 消息,currentQuestionIndex 当前大题所在位置,currentQuestionItemIndex 当前大题下小题位置，值可以没有
 */
+(void)parseAnswerJsonFile:(NSString*)jsonFilePath withReadingHistoryArray:( void(^)(NSArray *readingQuestionArr,int currentQuestionIndex,int currentQuestionItemIndex))questionArr withParseError:(void (^)(NSError *error))failure;

/**
 * @brief 将已经完成的朗读题写入json文件
 *
 * @param  jsonFilePath 题目json文件本地路径
 *@param readingHomeworkArray 存放ReadingHomeworkObj对象的数组，只写入isFinished=YES的题目
 * @return
 */
+(void)writeReadingHomeworkToJsonFile:(NSString*)jsonFilePath withReadingHomworkArr:(NSArray*)readingHomeworkArray withSuccess:(void (^)())success withFailure:(void (^)(NSError *error))failure;
@end
