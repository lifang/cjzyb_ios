//
//  PersonInfoInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "PersonInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation PersonInfoInterface

-(void)getPersonInterfaceDelegateWithQQ:(NSString *)qq andNick:(NSString *)nick andName:(NSString *)name andCode:(NSString *)code andKey:(NSString *)key{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",qq] forKey:@"open_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",nick] forKey:@"nickname"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",name] forKey:@"name"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",code] forKey:@"verification_code"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",key] forKey:@"key"];
    
    self.interfaceUrl =[NSString stringWithFormat:@"%@/api/students/record_person_info",kHOST];
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"POST"];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSData *data = [[NSData alloc]initWithData:[request responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData) {
                [self.delegate getPersonInfoDidFinished:jsonData];
            }else {
                [self.delegate getPersonInfoDidFailed:@"获取数据失败!"];
            }
        }
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPersonInfoDidFailed:@"获取数据失败!"];
}

@end
