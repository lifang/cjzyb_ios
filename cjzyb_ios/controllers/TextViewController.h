//
//  TextViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComtomTxt.h"
@interface TextViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UIView *textBar;
@property (nonatomic, strong) IBOutlet ComtomTxt *textView;

@property (nonatomic, strong) IBOutlet UILabel *textCountLabel;
@end
