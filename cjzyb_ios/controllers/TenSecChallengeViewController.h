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
#import "LHLTestInterface.h"
#import "OrdinaryAnswerObject.h"

@interface TenSecChallengeViewController : UIViewController<TenSecChallengeResultViewDelegate,LHLTestInterfaceDelegate>
@property (nonatomic,strong) NSMutableArray *questionArray;  //十个问题
@property (nonatomic,strong) TenSecChallengeResultView *resultView; //结果view
@property (nonatomic,assign) BOOL isViewingHistory; //是否浏览历史

-(void)startChallenge;//外部调用.  如需浏览历史,先设置isViewingHistory属性为YES
@end
