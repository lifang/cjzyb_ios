//
//  TagObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagObject : NSObject
@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *tag_card_bag_id;
@property (nonatomic, strong) NSString *tagCreat;

+(TagObject *)tagFromDictionary:(NSDictionary *)aDic;
@end
