//
//  ParseQuestionJsonFileTool.h
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadingHomeworkObj.h"
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
@end
