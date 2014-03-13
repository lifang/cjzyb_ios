//
//  LineObj.m
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LineObj.h"

@implementation LineObj
+(LineObj*)initLineObjWithStartPoint:(CGPoint)start withEndPoint:(CGPoint)end{
    LineObj *obj = [[LineObj alloc] init];
    obj.startPoint = start;
    obj.endPoint = end;
    return obj;
}
@end