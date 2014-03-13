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
    
    self.correctPersent.text = [NSString stringWithFormat:@"正确率: %i%@",self.ratio,@"%"];
    
    NSInteger minute = self.timeCount / 60;
    NSInteger second = self.timeCount % 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"用时: %d'%d",minute,second];
    
    if (self.ratio < 100) {
        self.accuracyAchievementLabel.text = [NSString stringWithFormat:@"好可惜没有全对哦,不能拿到精准得分哦!"];
    }else{
        self.accuracyAchievementLabel.text = [NSString stringWithFormat:@"所有题目全部正确!<精准>成就加10分!"];
    }
    
    if (self.timeCount <= self.timeLimit) {
        //迅速成就
        self.fastAchievementLabel.text = [NSString stringWithFormat:@"恭喜你的用时在%d秒内,<迅速>成就加10分!",self.timeLimit];
    }else{
        self.fastAchievementLabel.text = [NSString stringWithFormat:@"你的用时超过了%d秒,不能拿到迅速得分哦!",self.timeLimit];
    }
    
    //捷足成就
    if (self.isEarly) {
        self.earlyAchievementLabel.text = [NSString stringWithFormat:@"恭喜你在截止时间提前两小时完成作业,<捷足>成就加10分!"];
    }else{
        self.earlyAchievementLabel.text = [NSString stringWithFormat:@"未能在截止时间提前两小时完成作业,不能拿到捷足得分哦!"];
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
