//
//  ParseAnswerJsonFileTool.m
//  cjzyb_ios
//
//  Created by david on 14-3-24.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ParseAnswerJsonFileTool.h"

@implementation ParseAnswerJsonFileTool
///使用的道具写入json文件
+(void)writePropsToJsonFile:(NSString*)jsonFilePath withQuestionId:(NSString*)questionId withPropsType:(NSString*)proposType withSuccess:(void (^)())success withFailure:(void (^)(NSError *error))failure{
    if (!questionId || !proposType || !jsonFilePath) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"要保存的题目数据错误"}]);
        }
        return;
    }
    NSString *dircName = [jsonFilePath lastPathComponent];
    dircName = [dircName lastPathComponent];
    NSMutableArray *propsArray = [Utility returnAnswerPropsandDate:dircName];
    //存储道具记录JSON
    if ([proposType isEqualToString:@"0"]) {
        NSMutableDictionary *timePropDic = [NSMutableDictionary dictionaryWithDictionary:[propsArray firstObject]];
        NSMutableArray *branchOfPropArray = [NSMutableArray arrayWithArray:[timePropDic objectForKey:@"branch_id"]];
        [branchOfPropArray addObject:[NSNumber numberWithInteger:questionId.integerValue]];
        [timePropDic setObject:branchOfPropArray forKey:@"branch_id"];
        [propsArray replaceObjectAtIndex:0 withObject:timePropDic];
        [Utility returnAnswerPathWithProps:propsArray andDate:dircName];
    }else{
        NSMutableDictionary *timePropDic = [NSMutableDictionary dictionaryWithDictionary:[propsArray lastObject]];
        NSMutableArray *branchOfPropArray = [NSMutableArray arrayWithArray:[timePropDic objectForKey:@"branch_id"]];
        [branchOfPropArray addObject:[NSNumber numberWithInteger:questionId.integerValue]];
        [timePropDic setObject:branchOfPropArray forKey:@"branch_id"];
        [propsArray replaceObjectAtIndex:1 withObject:timePropDic];
        [Utility returnAnswerPathWithProps:propsArray andDate:dircName];
    }
    if (success) {
        success();
    }
}


///根据答案的json文件解析出朗读类型的做题记录
+(void)parseAnswerJsonFile:(NSString*)jsonFilePath withReadingHistoryArray:( void(^)(NSArray *readingQuestionArr,int currentQuestionIndex,int currentQuestionItemIndex))questionArr withParseError:(void (^)(NSError *error))failure{
    NSString *dircName = [jsonFilePath lastPathComponent];
    dircName = [dircName lastPathComponent];
    NSDictionary *readingDic = [Utility returnAnswerDictionaryWithName:@"reading" andDate:dircName];
    
    
}
@end
