//
//  MessageObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "MessageObject.h"

@implementation MessageObject


+(MessageObject *)messageFromDictionary:(NSDictionary *)aDic {
    MessageObject *message = [[MessageObject alloc]init];
    
    [message setMessageId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_ID]]]];
    [message setName:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_Name]]]];
    [message setUserId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_Userid]]]];
    [message setMessageContent:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_Content]]]];
    [message setMessageTime:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_Time]]]];
    [message setHeadUrl:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_head]]]];
    [message setReplyCount:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_replyCount]]]];
    if (![[aDic objectForKey:M_followCount] isKindOfClass:[NSNull class]] && [aDic objectForKey:M_followCount]!= nil) {
        [message setFollowCount:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_followCount]]];
    }else {
        [message setFollowCount:[NSString stringWithFormat:@"%d",0]];
    }
    [message setUserType:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:M_userType]]]];
    message.replyMessageArray = [[NSMutableArray alloc]init];
    
    return message;
}
@end
