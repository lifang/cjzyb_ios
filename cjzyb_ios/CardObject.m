//
//  CardObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardObject.h"

@implementation CardObject

+(CardObject *)cardFromDictionary:(NSDictionary *)aDic {
    CardObject *card = [[CardObject alloc]init];
    
    [card setCarId:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"id"]]];
    [card setCard_bag_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"card_bag_id"]]];
    [card setMistake_types:[[aDic objectForKey:@"mistake_types"]integerValue]];
    [card setBranch_question_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"branch_question_id"]]];
    [card setYour_answer:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"your_answer"]]];
    [card setQuestion_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"question_id"]]];
    [card setContent:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"content"]]];
    [card setResource_url:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"resource_url"]]];
    [card setTypes:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"types"]]];
    [card setAnswer:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"answer"]]];
    [card setOptions:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"options"]]];
    [card setCard_tag_id:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"card_tag_id"]]];
    [card setCreated_at:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"created_at"]]];
    [card setFull_text:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"full_text"]]];
    [card setTagArray:[NSMutableArray arrayWithArray:[aDic objectForKey:@"card_tags_id"]]];
    return card;
}
@end
