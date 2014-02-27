//
//  MessagePersonUnionObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "MessagePersonUnionObject.h"

@implementation MessagePersonUnionObject

+(MessagePersonUnionObject *)unionWithMessage:(MessageObject *)aMessage andUser:(PersonObject *)aPerson {
    MessagePersonUnionObject *unionObject=[[MessagePersonUnionObject alloc]init];
    [unionObject setMessage:aMessage];
    [unionObject setPerson:aPerson];
    return unionObject;
}
@end
