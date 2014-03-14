//
//  LineSubjectObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** LineSubjectObj
 *
 * 连线题一个小题，其中包含好多双向连线的句子LineDualSentenceObj
 */
@interface LineSubjectObj : NSObject
@property (strong,nonatomic) NSString *lineSubjectID;
/// 存放连线句子的数组
@property (strong,nonatomic) NSArray *lineSubjectSentenceArray;
@end
