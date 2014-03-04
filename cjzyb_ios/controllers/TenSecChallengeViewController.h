//
//  TenSecChallengeViewController.h
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

//  十全挑战

#import <UIKit/UIKit.h>
#import "TenSecChallengeObject.h"
#import "TenSecChallengeResultView.h"

@interface TenSecChallengeViewController : UIViewController<TenSecChallengeResultViewDelegate>
@property (nonatomic,strong) NSMutableArray *questionArray;  //十个问题
@property (nonatomic,strong) TenSecChallengeResultView *resultView; //结果view
@end
