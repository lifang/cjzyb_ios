//
//  ReplyMessageObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义消息cell的类型
enum ReplyMessageCellStyle {
    ReplyMessageCellStyleMe = 0,
    ReplyMessageCellStyleOther = 1,
};


@interface ReplyMessageObject : NSObject

@property (nonatomic, strong) NSString *micropost_id;
@property (nonatomic, strong) NSString *reciver_id;
@property (nonatomic, strong) NSString *reciver_name;
@property (nonatomic, strong) NSString *reciver_avatar_url;
@property (nonatomic, strong) NSString *sender_id;
@property (nonatomic, strong) NSString *sender_name;
@property (nonatomic, strong) NSString *sender_avatar_url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *sender_types;

@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic, assign) NSInteger pageCell;
@property (nonatomic, assign) NSInteger pageCountCell;

+ (ReplyMessageObject *)replyMessageFromDictionary:(NSDictionary *)aDic;
@end
