//
//  SortViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortViewController : UIViewController

@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, strong) UIView *wordsContainerView;
@property (nonatomic, assign) NSInteger number;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSDictionary *questionDic;


@property (nonatomic, assign) NSInteger branchNumber;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *branchQuestionArray;
@property (nonatomic, strong) NSDictionary *branchQuestionDic;

@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, assign) NSInteger currentWordIndex;// 当前应该填字的位置：1 2 3 4
@property (strong, nonatomic) NSMutableDictionary *maps;//标记第几个
@property (nonatomic, strong) NSMutableArray *actionArray;//记录操作
@property (nonatomic, assign) NSInteger isRestart;//判断是否可以重新开始

@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *restartBtn;
@end
