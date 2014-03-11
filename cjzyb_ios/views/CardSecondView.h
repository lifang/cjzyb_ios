//
//  CardSecondView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CardSecondViewDelegate <NSObject>
-(void)pressedVoiceBtn:(UIButton *)btn;
-(void)pressedDeleteBtn:(UIButton *)btn;
@end

@interface CardSecondView : UIControl

@property (nonatomic, assign) id<CardSecondViewDelegate>delegate;

@property (nonatomic, strong) IBOutlet UILabel *titleLab;//原句

@property (nonatomic, strong) IBOutlet UILabel *rtLab;

@property (nonatomic, strong) IBOutlet UIButton *voiceBtn,*deleteBtn;

@end
