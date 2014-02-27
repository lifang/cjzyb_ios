//
//  ThirdViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) IBOutlet UITextView *txtView;
@property (nonatomic, strong) IBOutlet UIButton *sendBtn;

@end
