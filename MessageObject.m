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
    
    [message setMessageId:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_ID]]];
    [message setMessageFrom:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_From]]];
    #warning 不一定有MessageTo
    [message setMessageTo:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_To]]];
    [message setMessageContent:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_Content]]];
    [message setMessageTime:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_Time]]];
    [message setHeadUrl:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_head]]];
    [message setFocus:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_focus]]];
    [message setAnswer:[NSString stringWithFormat:@"%@",[aDic objectForKey:M_answer]]];
    
    return message;
}
@end
