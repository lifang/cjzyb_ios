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

#define M_ID       @""
#define M_From     @""
#define M_To       @""
#define M_Content  @""
#define M_Time     @""
#define M_head     @""

@interface MessageObject : NSObject

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *messageFrom;//发送方
@property (nonatomic, strong) NSString *messageTo;//接受方
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *messageTime;
@property (nonatomic, strong) NSString *headUrl;


+(MessageObject *)messageFromDictionary:(NSDictionary *)aDic;
@end
