//
//  NotificationObject.h
//  cjzyb_ios
//
//  Created by apple on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject
@property (strong,nonatomic) NSString *notiSchoolClassId;
@property (strong,nonatomic) NSString *notiStudentId;
@property (strong,nonatomic) NSString *notiContent;
@property (strong,nonatomic) NSString *notiStatus;
@property (strong,nonatomic) NSString *notiTime;
@end
