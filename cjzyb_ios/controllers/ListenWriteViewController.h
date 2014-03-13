//
//  ListenWriteViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-12.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ListenWriteViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, strong) ASIHTTPRequest *asiHttpRequest;

@property (nonatomic, strong) UIView *wordsContainerView;

@property (nonatomic, assign) NSInteger number;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSDictionary *questionDic;

@property (nonatomic, assign) NSInteger branchNumber;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *branchQuestionArray;
@property (nonatomic, strong) NSDictionary *branchQuestionDic;

@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, strong) NSArray *metaphoneArray;

@property (strong, nonatomic) IBOutlet UILabel *remindLab;
@property (nonatomic, strong) NSMutableArray *tmpArray;
@property (nonatomic, strong) NSDictionary *resultDic;

@property (nonatomic, assign) CGFloat score;
@end
