//
//  DataService.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObject.h"
#import "ClassObject.h"
#import "TaskObj.h"

@interface DataService : NSObject

@property (nonatomic,strong) UserObject *user;
@property (nonatomic,strong) ClassObject *theClass;
@property (nonatomic,assign) NSInteger first,second,third,fourth;//判断4个页面

@property (nonatomic, strong) NSMutableArray *tagsArray;//卡包标签

@property (nonatomic,strong) TaskObj *taskObj;
///道具－－－－记录道具的数量
@property (nonatomic,assign) NSInteger number_reduceTime,number_correctAnswer;
///判断是否是历史作业
@property (nonatomic,assign) BOOL isHistory;

+ (DataService *)sharedService;

@end
