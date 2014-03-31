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
    self.resultBgView.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:200.0/255.0 blue:124.0/255.0 alpha:1.0];
    
    self.resultBgView.layer.cornerRadius = 10.0;
    self.noneArchiveView.layer.cornerRadius = 10.0;
    self.commitButton.layer.cornerRadius = 4.0;
    self.noneCommitButton.layer.cornerRadius = 4.0;
    self.restartButton.layer.cornerRadius = 4.0;
    self.noneRestartButton.layer.cornerRadius = 4.0;
    self.correctPersent.text = [NSString stringWithFormat:@"正确率: %i%%",self.ratio];
    self.noneCorrectPersent.text = self.correctPersent.text;
    self.timeLabel.text = [NSString stringWithFormat:@"用时: %@",[Utility formateDateStringWithSecond:(NSInteger)self.timeCount]];
    self.noneTimeLabel.text = self.timeLabel.text;
    
    if (self.ratio < 100) {//精准成就
        self.accuracyAchievementLabel.text = [NSString stringWithFormat:@"好可惜没有全对哦,不能拿到精准得分哦!"];
    }else{
        self.accuracyAchievementLabel.text = [NSString stringWithFormat:@"所有题目全部正确!<精准>成就加10分!"];
    }
    
    if (self.timeCount <= self.timeLimit) {//迅速成就
        self.fastAchievementLabel.text = [NSString stringWithFormat:@"恭喜你的用时在%d秒内,<迅速>成就加10分!",self.timeLimit];
    }else{
        self.fastAchievementLabel.text = [NSString stringWithFormat:@"你的用时超过了%d秒,不能拿到迅速得分哦!",self.timeLimit];
    }
    
    if (self.isEarly) {//捷足成就
        self.earlyAchievementLabel.text = [NSString stringWithFormat:@"恭喜你在截止时间提前两小时完成作业,<捷足>成就加10分!"];
    }else{
        self.earlyAchievementLabel.text = [NSString stringWithFormat:@"未能在截止时间提前两小时完成作业,不能拿到捷足得分哦!"];
    }
    
    //剩余挑战次数(十速挑战专用)
    if (self.challengeTimesLeft) {
        [self.restartButton setTitle:[NSString stringWithFormat:@"再次挑战 (%@)",self.challengeTimesLeft] forState:UIControlStateNormal];
        [self.noneRestartButton setTitle:[NSString stringWithFormat:@"再次挑战 (%@)",self.challengeTimesLeft] forState:UIControlStateNormal];
        if (self.challengeTimesLeft.integerValue < 1) {
            self.noneRestartButton.backgroundColor = [UIColor lightGrayColor];
            self.noneRestartButton.enabled = NO;
            self.restartButton.backgroundColor = [UIColor lightGrayColor];
            self.restartButton.enabled = NO;
        }else{
            self.noneRestartButton.backgroundColor = [UIColor whiteColor];
            self.noneRestartButton.enabled = YES;
            self.restartButton.backgroundColor = [UIColor whiteColor];
            self.restartButton.enabled = YES;
        }
    }
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
