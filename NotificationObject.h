//
//  NotificationObject.h
//  cjzyb_ios
//
//  Created by apple on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject
@property (strong,nonatomic) NSString *notiID;
@property (strong,nonatomic) NSString *notiSchoolClassID;  //班级id
@property (strong,nonatomic) NSString *notiStudentID;      //学生id
@property (strong,nonatomic) NSString *notiContent;         //内容
@property (strong,nonatomic) NSString *notiTime;        //通知时间
@end
