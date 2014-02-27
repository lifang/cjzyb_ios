//
//  MessagePersonUnionObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageObject.h"
#import "PersonObject.h"

@interface MessagePersonUnionObject : NSObject

@property (nonatomic, strong) MessageObject* message;
@property (nonatomic, strong) PersonObject* person;

+(MessagePersonUnionObject *)unionWithMessage:(MessageObject *)aMessage andUser:(PersonObject *)aPerson;
@end
