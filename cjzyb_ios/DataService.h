//
//  DataService.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

@property (nonatomic,strong) NSString *user_id;
+ (DataService *)sharedService;

@end
