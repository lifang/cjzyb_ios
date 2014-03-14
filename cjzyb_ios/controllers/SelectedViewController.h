//
//  SelectedViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClozeView.h"
#import "UnderLineLabel.h"

@interface SelectedViewController : UIViewController<ClozeViewDelegate>

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, strong) ClozeView *clozeVV;

@property (nonatomic, assign) NSInteger number;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSDictionary *questionDic;


@property (nonatomic, strong) NSMutableArray *answerArray;

@property (nonatomic, strong) NSArray *orgArray;

@property (nonatomic, assign) NSInteger tmpTag;
@end
