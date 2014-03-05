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

@interface DataService : NSObject

@property (nonatomic,strong) UserObject *user;
@property (nonatomic,strong) ClassObject *theClass;

+ (DataService *)sharedService;

@end
