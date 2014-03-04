//
//  TenSecChallengeResultView.m
//  cjzyb_ios
//
//  Created by apple on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TenSecChallengeResultView.h"

@implementation TenSecChallengeResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

//初始化设置
-(void) initView{
    self.resultBgView.layer.cornerRadius = 10.0;
    
    self.commitButton.layer.cornerRadius = 4.0;
    
    self.restartButton.layer.cornerRadius = 4.0;
}

#pragma mark 按键响应
- (IBAction)commitButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resultViewCommitButtonClicked)]) {
        [self.delegate resultViewCommitButtonClicked];
    }
}

- (IBAction)restartButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resultViewRestartButtonClicked)]) {
        [self.delegate resultViewRestartButtonClicked];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
