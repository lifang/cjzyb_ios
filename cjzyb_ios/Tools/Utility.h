//
//  Utility.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject
+(Utility*)defaultUtility;
///判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+(BOOL)requestFailure:(NSError*)error tipMessageBlock:(void(^)(NSString *tipMsg))msg;
+ (UIImage *)getNormalImage:(UIView *)view;
//+ (NSString *)isExistenceNetwork;
/**
 * @brief
 *
 * @param
 *
 * @return networkStatus :ReachableViaWWAN：三G网络，ReachableViaWiFi：wifi网络，NotReachable：无网络
 */
+(void)judgeNetWorkStatus:(void (^)(NSString*networkStatus))networkStatus;
+ (NSString *)createMD5:(NSString *)params;
+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath;
+ (NSString *)getNowDateFromatAnDate;
+(NSDate*)getDateFromDateString:(NSString*)dateString;
+(NSString*)getStringFromDate:(NSDate*)date;
+ (void)errorAlert:(NSString *)message;
+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(float)width;
+(CGSize)getAttributeStringSizeWithWidth:(float)width withAttributeString:(NSAttributedString*)attriString;
+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font;
+(NSString*)convertFileSizeUnitWithBytes:(NSString*)bytes;
@end
