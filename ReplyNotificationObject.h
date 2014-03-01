//
//  ReplyNotificationObject.h
//  cjzyb_ios
//
//  Created by apple on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyNotificationObject : NSObject
@property (strong,nonatomic) NSString *replyId;  //本通知ID
@property (strong,nonatomic) NSString *replyerId; //发送者ID
@property (strong,nonatomic) NSString *replyerName;  //发送者名字
@property (strong,nonatomic) NSString *replyerImageAddress;   //发送者头像地址
@property (strong,nonatomic) NSString *replyContent;   //内容
@property (strong,nonatomic) NSString *replyTime;   //时间
@property (strong,nonatomic) NSString *replyMicropostId;  //被回复的帖子/消息
@end
