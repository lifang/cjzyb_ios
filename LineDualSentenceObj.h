//
//  LineDualSentenceObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** LineDualSentenceObj
 *
 * 连线题对应每个句子
 */
@interface LineDualSentenceObj : NSObject
@property (strong,nonatomic) NSString *lineDualSentenceID;
///连线题每句话中左边对应的句子
@property (strong,nonatomic) NSString *lineDualSentenceLeft;
///连线题每句话中右边对应的句子
@property (strong,nonatomic) NSString *lineDualSentenceRight;
@end
