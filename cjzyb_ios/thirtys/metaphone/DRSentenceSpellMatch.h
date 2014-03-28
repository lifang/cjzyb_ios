//
//  DRSentenceSpellMatch.h
//  cjzyb_ios
//
//  Created by david on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>



/** DRSentenceSpellMatch
 *
 * 对句子拼写检查
 */
@interface DRSentenceSpellMatch : NSObject
/**
 * @brief 检测标准句子sentence 与参考句子spellSentence匹配程度
 *
 * @param  sentence 标准的参考句子
   @param  spellSentence 要匹配的句子
 *
 * @return spellAttriString 带颜色表示的句子，对的单词绿色，部分匹配的橘黄色，不匹配的黑色,
                 matchScore  匹配程度，取值范围0-1,
                 error  失败提示
 */
+(void)checkSentence:(NSString*)sentence withSpellMatchSentence:(NSString*)spellSentence andSpellMatchAttributeString:(void(^)(NSAttributedString *spellAttriString,float matchScore,NSArray *errorWordArray))success orSpellMatchFailure:(void(^)(NSError *error))failure;
@end
