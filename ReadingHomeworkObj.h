//
//  ReadingHomeworkObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadingSentenceObj.h"
/** ReadingHomeworkObj
 *
 * 朗读题型对象
 */
@interface ReadingHomeworkObj : NSObject
@property (strong,nonatomic) NSString *readingHomeworkID;
///存放每小题对象数组,ReadingSentenceObj
@property (strong,nonatomic) NSMutableArray *readingHomeworkSentenceObjArray;

///是否该道题已经完成
@property (assign,nonatomic) BOOL isFinished;
@end
