//
//  ReplyMessageObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (ReplyMessageObject *)replyMessageFromDictionary:(NSDictionary *)aDic;
@end
