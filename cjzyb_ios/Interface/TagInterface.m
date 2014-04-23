//
//  TagInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TagInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation TagInterface

-(void)getTagInterfaceDelegateWithStudentId:(NSString *)studentId andClassId:(NSString *)classId andCardId:(NSString *)cardId andName:(NSString *)name{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",studentId] forKey:@"student_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",cardId] forKey:@"knowledge_card_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",name] forKey:@"name"];

    self.interfaceUrl =[NSString stringWithFormat:@"%@/api/students/create_card_tag",kHOST];

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
                        [self.delegate getTagInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getTagInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getTagInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getTagInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getTagInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getTagInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getTagInfoDidFailed:@"获取数据失败!"];
}


@end
