//
//  SelectingChallengeObject.h
//  cjzyb_ios
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

//选择挑战
//因其只有一个大题,故此对象代表小题,大题id保存在每个小题中
#import <Foundation/Foundation.h>

typedef enum{
    SelectingTypeDefault = 1,
    SelectingTypeListening,
    SelectingTypeWatching
} SelectingType;

@interface SelectingChallengeObject : NSObject
@property (nonatomic,strong) NSString *seBigID;  //大题id
@property (nonatomic,strong) NSString *seTimeLimit; //时限

@property (nonatomic,strong) NSString *seID;  //id
@property (nonatomic,strong) NSString *seContent;  //题面
@property (nonatomic,strong) NSString *seContentAttachment;  //附件  (default型为nil)
@property (nonatomic,assign) SelectingType seType; //问题类型  填空/看图/听音
@property (nonatomic,strong) NSString *seRightAnswer;  //正确答案
@property (nonatomic,strong) NSArray *seOptionsArray;   //选项

+(NSArray *)parseSelectingChallengeFromQuestion; // 从question文件中解析所有选择题
@end
