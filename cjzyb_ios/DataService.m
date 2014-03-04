//
//  DataService.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "DataService.h"

@implementation DataService

- (id)init{
    self = [super init];
    if (!self) {
        
    }
    return self;
}


+ (DataService *)sharedService {
    static dispatch_once_t once;
    static DataService *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}

@end
