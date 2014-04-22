//
//  LHLDoubleMetaphone.h
//  testtabbar
//
//  Created by apple on 14-4-22.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHLDoubleMetaphone : NSObject
///返回两个音标字符串 , 第一个为主要,第二个为参考
+ (NSArray *)doubleMetaphone:(NSString *)str;
@end
