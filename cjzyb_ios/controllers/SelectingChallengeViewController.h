//
//  SelectingChallengeViewController.h
//  cjzyb_ios
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectingChallengeObject.h"
#import "TenSecChallengeResultView.h"
#import <AVFoundation/AVFoundation.h>
#import "SelectingChallengeOptionCell.h"
//@interface SelectingChallengeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SelectingChallengeOptionCellDelegate,>


@interface SelectingChallengeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TenSecChallengeResultViewDelegate,SelectingChallengeOptionCellDelegate,AVAudioPlayerDelegate>
-(void)getStart;        //调用此方法
@property (weak, nonatomic) IBOutlet UIView *contentBgView;  //正文背景
- (IBAction)nextButtonClicked:(id)sender;
-(void)propOfReduceTimeClicked:(id)sender;
-(void)propOfShowingAnswerClicked:(id)sender;
@property (assign,nonatomic) BOOL isViewingHistory; //当前行为类型:查看历史/做题
@end
