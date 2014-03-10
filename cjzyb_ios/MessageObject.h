//
//  MessageObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>


//定义消息cell的类型
enum MessageCellStyle {
    MessageCellStyleMe = 0,
    MessageCellStyleOther = 1,
};
#define M_ID       @"micropost_id"
#define M_Name     @"name"
#define M_Userid   @"user_id"
#define M_Content  @"content"
#define M_Time     @"created_at"
#define M_head     @"avatar_url"
#define M_userType    @"user_types"
#define M_replyCount   @"reply_microposts_count"
#define M_followCount  @"follow_microposts_count"

@interface MessageObject : NSObject

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, strong) NSString *messageTime;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *replyCount;//回复
@property (nonatomic, strong) NSString *followCount;//关注
@property (nonatomic, strong) NSMutableArray *replyMessageArray;//回复的信息
@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic, assign) NSInteger pageHeader;
@property (nonatomic, assign) NSInteger pageCountHeader;
+(MessageObject *)messageFromDictionary:(NSDictionary *)aDic;
@end
