//
//  TagObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TagObject.h"

@implementation TagObject
+(TagObject *)tagFromDictionary:(NSDictionary *)aDic {
    TagObject *tagObj = [[TagObject alloc]init];
    [tagObj setTagId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"id"]]];
    [tagObj setTagName:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"name"]]];
    [tagObj setTag_card_bag_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"card_bag_id"]]];
    [tagObj setTagCreat:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"created_at"]]];
    
    return tagObj;
}
@end
