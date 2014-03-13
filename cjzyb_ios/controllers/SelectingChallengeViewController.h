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
#import "SelectingChallengeOptionCell.h"
//@interface SelectingChallengeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SelectingChallengeOptionCellDelegate>


@interface SelectingChallengeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TenSecChallengeResultViewDelegate,SelectingChallengeOptionCellDelegate>
-(void)getStart;        //第一次做题,或浏览历史 ,调用此方法
-(void)reDoingChallenge;   //重新做题,调用此方法
@end
