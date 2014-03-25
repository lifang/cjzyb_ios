//
//  ThirdViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComtomTxt.h"
#import "MessageObject.h"
#import "QuestionInterface.h"
#import "MainViewController.h"
/**
 *  发布问题
 */

@interface ThirdViewController : UIViewController <UITextViewDelegate,QuestionInterfaceDelegate>

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) IBOutlet ComtomTxt *txtView;
@property (nonatomic, strong) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) QuestionInterface *questionInter;
@property (nonatomic, strong) AppDelegate *appDel;


@property (nonatomic, strong) IBOutlet UILabel *textCountLabel;
@property (nonatomic, assign) int third;
@end
