//
//  ReplyMessageObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ReplyMessageObject.h"

@implementation ReplyMessageObject
+ (ReplyMessageObject *)replyMessageFromDictionary:(NSDictionary *)aDic {
    ReplyMessageObject *obj = [[ReplyMessageObject alloc]init];
    
    [obj setMicropost_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"id"]]]];
    [obj setContent:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"content"]]]];
    [obj setCreated_at:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"new_created_at"]]]];
    [obj setReciver_avatar_url:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"reciver_avatar_url"]]]];
    [obj setReciver_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"reciver_id"]]]];
    [obj setReciver_name:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"reciver_name"]]]];
    [obj setSender_avatar_url:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"sender_avatar_url"]]]];
    [obj setSender_id:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"sender_id"]]]];
    [obj setSender_name:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"sender_name"]]]];
    [obj setSender_types:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"sender_types"]]]];
    
    return obj;
}
@end
