//
//  SelectedTagInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-12.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectedTagInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation SelectedTagInterface
-(void)getSelectedTagInterfaceDelegateWithStudentId:(NSString *)studentId andClassId:(NSString *)classId andCardId:(NSString *)cardId andCardTagId:(NSString *)cardTagId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",studentId] forKey:@"student_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",cardId] forKey:@"knowledge_card_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",cardTagId] forKey:@"card_tag_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@/api/students/knoledge_tag_relation",kHOST];
    
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
                        [self.delegate getSelectedTagInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getSelectedTagInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getSelectedTagInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getSelectedTagInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getSelectedTagInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getSelectedTagInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSelectedTagInfoDidFailed:@"获取数据失败!"];
}

@end
