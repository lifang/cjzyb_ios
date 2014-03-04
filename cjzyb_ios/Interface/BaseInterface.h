//
//  BaseInterface.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h" 

@protocol BaseInterfaceDelegate;
@interface BaseInterface : NSObject

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, strong) NSString *interfaceUrl;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *bodys;
@property (nonatomic, assign) id<BaseInterfaceDelegate> baseDelegate;

-(void)connect;
@end

@protocol BaseInterfaceDelegate <NSObject>

@required
-(void)parseResult:(ASIHTTPRequest *)request;
-(void)requestIsFailed:(NSError *)error;

@optional

@end