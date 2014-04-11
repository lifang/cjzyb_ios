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
 * @param  userId 用户id
 *@param  task 任务对象
 * @return readingQuestionArr：ReadingHomeworkObj对象数组,error:错误 消息,currentQuestionIndex 当前大题所在位置,currentQuestionItemIndex 当前大题下小题位置，值可以没有,status 完成状态，0没有完成，1已经完成, updateTime 更新所用时间，userTime 已经使用的时间,specifyTime 指定时间
 */
+(void)parseAnswerJsonFileWithUserId:(NSString*)userId withTask:(TaskObj*)task withReadingHistoryArray:( void(^)(NSArray *readingQuestionArr,int currentQuestionIndex,int currentQuestionItemIndex,int status,NSString *updateTime,NSString *userTime,int specifyTime,float ratio))questionArr withParseError:(void (^)(NSError *error))failure;

/**
 * @brief 将已经完成的朗读题写入json文件
 *
 * @param  jsonFilePath 题目json文件本地路径
 *@param readingHomeworkArray 存放ReadingHomeworkObj对象的数组，只写入isFinished=YES的题目
  @param useTime 做题所花费的时间
  @param questionIndex 当前结束大题的时间
  @param questionItemIndex 当前结束小题时间
 * @return
 */
+(void)writeReadingHomeworkToJsonFile:(NSString*)jsonFilePath withUseTime:(NSString*)useTime withQuestionIndex:(int)questionIndex withQuestionItemIndex:(int)questionItemIndex withReadingHomworkArr:(NSArray*)readingHomeworkArray withSuccess:(void (^)())success withFailure:(void (^)(NSError *error))failure;

///分割字符串
+(NSMutableArray*)getErrorWordArrayFromString:(NSString*)content;

//TODO: 根据答案的json文件解析出朗读类型的做题记录
//+(void)parseAnswerJsonFile:(NSString*)jsonFilePath withReadingHistoryArray:( void(^)(NSArray *readingQuestionArr,int currentQuestionIndex,int currentQuestionItemIndex,int status,NSString *updateTime,NSString *userTime,float ratio))questionArr withParseError:(void (^)(NSError *error))failure;
@end
