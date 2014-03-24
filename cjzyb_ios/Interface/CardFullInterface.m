//
//  CardFullInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-19.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardFullInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation CardFullInterface
-(void)getCardFullInterfaceDelegate {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].theClass.classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].user.studentId] forKey:@"student_id"];
    
    self.interfaceUrl = @"http://58.240.210.42:3004/api/students/card_is_full";
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"GET"];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSData *data = [[NSData alloc]initWithData:[request responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData) {
                if ([[jsonData objectForKey:@"status"]isEqualToString:@"success"]) {
                    @try {
                        [self.delegate getCardFullInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getCardFullInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getCardFullInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getCardFullInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getCardFullInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getCardFullInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getCardFullInfoDidFailed:@"获取数据失败!"];
}

@end
