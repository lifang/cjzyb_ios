//
//  CardSecondView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "SelectingChallengeOptionCell.h"

@protocol CardSecondViewDelegate <NSObject>
-(void)pressedVoiceBtn:(UIButton *)btn;
-(void)pressedDeleteBtn:(UIButton *)btn;
@end

@interface CardSecondView : UIControl<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<CardSecondViewDelegate>delegate;

@property (nonatomic, strong) IBOutlet UILabel *titleLab;//原句

@property (nonatomic, strong) IBOutlet CustomLabel *rtLab;
@property (nonatomic, strong) IBOutlet UIButton *voiceBtn,*deleteBtn;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) UITableView *cardSecondTable;
@property (nonatomic, strong) NSArray *cardSecondArray;
@property (nonatomic, strong) NSArray *indexArray;
@end
