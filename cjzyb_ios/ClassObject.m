//
//  ClassObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ClassObject.h"

@implementation ClassObject

+(ClassObject *)classFromDictionary:(NSDictionary *)aDic {
    ClassObject *class = [[ClassObject alloc]init];
    
    [class setClassId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"id"]]];
    [class setName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"name"]]];
    [class setTName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"tearcher_name"]]];
    [class setTId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"tearcher_id"]]];
    
    return class;
}
@end
