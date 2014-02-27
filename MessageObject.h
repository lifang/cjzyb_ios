//
//  MessageObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义消息是发送还是回复
enum MessageType {
    MessageTypeSend = 0,//发送
    MessageTypeAnswer = 1//回复
};

//定义消息cell的类型
enum MessageCellStyle {
    MessageCellStyleMe = 0,
    MessageCellStyleOther = 1,
};
#define M_ID       @"id"
#define M_From     @"from"
#define M_To       @"to"
#define M_Content  @"cotent"
#define M_Time     @"time"
#define M_head     @"head"
#define M_focus    @"focus"
#define M_answer   @"answer"

@interface MessageObject : NSObject

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *messageFrom;//发送方
@property (nonatomic, strong) NSString *messageTo;//接受方
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *messageTime;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *focus;//关注
@property (nonatomic, strong) NSString *answer;//关注

+(MessageObject *)messageFromDictionary:(NSDictionary *)aDic;
@end
