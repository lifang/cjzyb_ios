//
//  ClassObject.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ClassObject.h"

@implementation ClassObject

+(ClassObject *)classFromDictionary:(NSDictionary *)aDic {
    ClassObject *class = [[ClassObject alloc]init];
    
    [class setClassId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"id"]]]];
    [class setName:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"name"]]]];
    [class setTName:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"tearcher_name"]]]];
    [class setTId:[NSString stringWithFormat:@"%@",[Utility filterValue:[aDic objectForKey:@"tearcher_id"]]]];
    
    return class;
}



///保存当前用户班级
-(void)archiverClass{
    AppDelegate *appDel = [AppDelegate shareIntance];
    appDel.the_class_id = -1;
    appDel.notification_type=0;
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"class.plist"];
    if ([fileManage fileExistsAtPath:filename]) {
        [fileManage removeItemAtPath:filename error:nil];
    }
    NSDictionary *classDic = @{@"id": (self.classId?:@""),@"name":(self.name?:@""),@"tearcher_name":(self.tName?:@""),@"tearcher_id":(self.tId?:@"")};
    [NSKeyedArchiver archiveRootObject:classDic toFile:filename];
}

///删除当前本地用户班级
-(void)unarchiverClass{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"class.plist"];
    NSDictionary *userDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    self.name = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
    self.classId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
    self.tName = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"tearcher_name"]];
    self.tId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"tearcher_id"]];
}

@end
