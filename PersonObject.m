//
//  PersonObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "PersonObject.h"

@implementation PersonObject

+(PersonObject *)personFronDictionary:(NSDictionary *)aDic {
    PersonObject *person = [[PersonObject alloc]init];
    
    [person setPersonId:[NSString stringWithFormat:@"%@",[aDic objectForKey:P_Id]]];
    [person setPersonNick:[NSString stringWithFormat:@"%@",[aDic objectForKey:P_Nick]]];
    [person setPersonHead:[NSString stringWithFormat:@"%@",[aDic objectForKey:P_Head]]];
    [person setPersonFocus:[[aDic objectForKey:P_Focus] integerValue]];
    [person setAchievExcellent:[[aDic objectForKey:P_Excellent] integerValue]];
    [person setAchievPrecision:[[aDic objectForKey:P_Precision] integerValue]];
    [person setAchievFast:[[aDic objectForKey:P_Fast] integerValue]];
    [person setAchievFoot:[[aDic objectForKey:P_Foot] integerValue]];
    [person setCourseArray:[NSMutableArray arrayWithArray:[aDic objectForKey:P_Course]]];
    
    return person;
}
@end
