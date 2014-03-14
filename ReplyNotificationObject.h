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
@property (strong,nonatomic) NSString *replyTargetName; //被回复者的名字 (通常是我, 或者我关注的问题的作者)
@property (strong,nonatomic) NSString *replyerName;  //发送者名字
@property (strong,nonatomic) NSString *replyerImageAddress;   //发送者头像地址
@property (strong,nonatomic) NSString *replyContent;   //内容
@property (strong,nonatomic) NSString *replyTime;   //时间
@property (strong,nonatomic) NSString *replyMicropostId;  //被回复的帖子/消息ID
@property (strong,nonatomic) NSString *replyReciverID;  //你回复消息时的被回复者ID
@property (strong,nonatomic) NSString *replyReciverType;  //你回复消息时的被回复者类型 (默认学生都为1)
@end
