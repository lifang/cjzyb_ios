//
//  CardObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardObject : NSObject

@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *card_bag_id;
@property (nonatomic, assign) NSInteger mistake_types;
@property (nonatomic, strong) NSString *branch_question_id;
@property (nonatomic, strong) NSString *your_answer;//你的答案
@property (nonatomic, strong) NSString *question_id;//小题id
@property (nonatomic, strong) NSString *content;//消息内容
@property (nonatomic, strong) NSString *resource_url;//资源路径
@property (nonatomic, strong) NSString *types;
@property (nonatomic, strong) NSString *answer;//答案
@property (nonatomic, strong) NSString *options;//选项
@property (nonatomic, strong) NSString *card_tag_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *full_text;
@property (nonatomic, strong) NSMutableArray *tagArray;

+(CardObject *)cardFromDictionary:(NSDictionary *)aDic;
@end
