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
    if (![[aDic objectForKey:@"types"] isKindOfClass:[NSNull class]]) {
        int type = [[aDic objectForKey:@"types"] integerValue];
        if (type==5) {
            [card setClozeAnswer:[NSArray arrayWithArray:[aDic objectForKey:@"answer"]]];
        }else {
            [card setAnswer:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"answer"]]]];
        }
    }
    
    
    [card setCarId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"id"]]]];
    [card setCard_bag_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"card_bag_id"]]]];
    [card setMistake_types:[[aDic objectForKey:@"mistake_types"]integerValue]];
    [card setBranch_question_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"branch_question_id"]]]];
    [card setYour_answer:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"your_answer"]]]];
    [card setQuestion_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"question_id"]]]];
    [card setContent:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"content"]]]];
    [card setResource_url:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"resource_url"]]]];
    [card setTypes:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"types"]]]];
    
    [card setOptions:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"options"]]]];
    [card setCard_tag_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"card_tag_id"]]]];
    [card setCreated_at:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"new_created_at"]]]];
    [card setFull_text:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"full_text"]]]];
    [card setTagArray:[NSMutableArray arrayWithArray:[aDic objectForKey:@"card_tags_id"]]];
    return card;
}
@end
