//
//  LineObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

/** LineObj
 *
 * 直线对象，包含起点和终点
 */
@interface LineObj : NSObject
@property (assign,nonatomic) CGPoint startPoint;
@property (assign,nonatomic) CGPoint endPoint;
+(LineObj*)initLineObjWithStartPoint:(CGPoint)start withEndPoint:(CGPoint)end;
@end