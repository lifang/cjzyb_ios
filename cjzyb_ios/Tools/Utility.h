//
//  Utility.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface Utility : NSObject

@property (nonatomic, assign) int firstpoint;
@property (nonatomic, assign) BOOL isOrg;
@property (nonatomic, strong) NSArray *rangeArray;

@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, strong) NSArray *metaphoneArray;

@property (nonatomic, strong) NSMutableArray *greenArray;//绿色:正确，
@property (nonatomic, strong) NSMutableArray *yellowArray;//黄色:部分匹配基本正确
@property (nonatomic, strong) NSMutableArray *spaceLineArray;//下划线:缺词
@property (nonatomic, strong) NSMutableArray *noticeArray;//标记需要提示的地方
@property (nonatomic, strong) NSMutableArray *correctArray;//正确单词
@property (nonatomic, strong) NSMutableArray *wrongArray;//错误的单词
@property (nonatomic, strong) NSMutableArray *sureArray;//黄色匹配
+ (Utility *)shared;
+(NSString*)spellStringWithWord:(NSString*)word;
+(NSArray *)metaphoneArray:(NSArray *)array;

//去除标点符号
+(NSArray *)handleTheString:(NSString *)string;
//单词转化字母数组
+(NSArray *)handleTheLetter:(NSString *)string;
//匹配相似度
+(int)DistanceBetweenTwoString:(NSString*)strA StrAbegin:(int)strAbegin StrAend:(int)strAend StrB:(NSString*)strB StrBbegin:(int)strBbegin StrBend:(int)strBend;
//返回结果
+(NSDictionary *)listenCompareWithArray:(NSArray *)arrA andArray:(NSArray *)arrAA WithArray:(NSArray *)arrB andArray:(NSArray *)arrBB;
+(NSDictionary *)compareWithArray:(NSArray *)arrA andArray:(NSArray *)arrAA WithArray:(NSArray *)arrB andArray:(NSArray *)arrBB WithRange:(NSArray *)rangeArray;


/////////////上面都是单词匹配使用的

+(Utility*)defaultUtility;

///分数转化成等级,满100升一级
+(NSString*)formateLevelWithScore:(float)score;

///异步请求网络数据
+(void)requestDataWithRequest:(NSURLRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure;

///异步请求网络数据
+(void)requestDataWithASIRequest:(ASIHTTPRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure;

///过滤json数据，可能出现<NULL>,null,等等情况
+(NSString *)filterValue:(NSString*)value;

///判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

///把秒数转换成时间字符串，如：61 => 1'1"
+(NSString*)formateDateStringWithSecond:(int)second;

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
+ (Class)JSONParserClass;
//answer.json文件路径
+(NSMutableDictionary *)returnAnswerDictionaryWithName:(NSString *)name;
+(void)returnAnswerPathWithDictionary:(NSDictionary *)aDic andName:(NSString *)name;
+(BOOL)compareTime;
+(NSMutableArray *)returnAnswerProps;
+(void)returnAnswerPathWithProps:(NSMutableArray *)array;
+ (NSString *)isExistenceNetwork;
@end
