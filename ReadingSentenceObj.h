//
//  ReadingSentenceObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** ReadingSentenceObj
 *
 * 每一道小题对象，可能含有多个句子
 */
@interface ReadingSentenceObj : NSObject
@property (strong,nonatomic) NSString *readingSentenceID;
///朗读的内容
@property (strong,nonatomic) NSString *readingSentenceContent;
///音频文件下载的url
@property (strong,nonatomic) NSString *readingSentenceResourceURL;

///音频本地保存位置
@property (strong,nonatomic) NSString *readingSentenceLocalFileURL;

///是否该道题已经完成
@property (assign,nonatomic) BOOL isFinished;

///该句子正确率
@property (strong,nonatomic) NSString *readingSentenceRatio;
@end
