//
//  LHLNofiticationHeader.m
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLNotificationHeader.h"
@interface LHLNotificationHeader ()
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIButton *replyButton; //回复通知
@property (nonatomic,strong) UIButton *noticeButton; //系统通知
@property (nonatomic,strong) UIImageView *smallTriangle; //白色小三角形
@end
@implementation LHLNotificationHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:205.0/255.0 blue:206.0/255.0 alpha:1.0];
        [self addSubview:self.backgroundView];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.replyButton.backgroundColor = [UIColor clearColor];
        [self.replyButton setTitle:@"回复通知" forState:UIControlStateNormal];
        [self.replyButton.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
        [self.replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled]; //禁用时为白色标题,代表选中
        [self.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.replyButton];
        
        self.noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.noticeButton.backgroundColor = [UIColor clearColor];
        [self.noticeButton setTitle:@"系统通知" forState:UIControlStateNormal];
        [self.noticeButton.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
        [self.noticeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.noticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled]; //禁用时为白色标题,代表选中
        self.noticeButton.enabled = NO;
        [self.noticeButton addTarget:self action:@selector(noticeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.noticeButton];
        
        self.smallTriangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallTriangle.png"]];
        self.smallTriangle.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.smallTriangle];
    }
    return self;
}

-(void)layoutSubviews{
    self.backgroundView.frame = self.bounds;
    
    CGRect bgFrame = self.backgroundView.frame;
    
    self.replyButton.frame = (CGRect){bgFrame.size.width / 6,0,bgFrame.size.width / 3,bgFrame.size.height};
    
    self.noticeButton.frame = (CGRect){bgFrame.size.width / 2,0,bgFrame.size.width / 3,bgFrame.size.height};
    
    if (self.noticeButton.enabled) {
        self.smallTriangle.frame = (CGRect){self.replyButton.center.x - 10,CGRectGetMaxY(self.replyButton.frame) - 12,20,12};
    }else{
        self.smallTriangle.frame = (CGRect){self.noticeButton.center.x - 10,CGRectGetMaxY(self.noticeButton.frame) - 12,20,12};
    }
}

- (void)replyButtonClicked:(UIButton *) sender{
    sender.enabled = NO;
    self.noticeButton.enabled = YES;
    [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:didSelectedDisplayCategory:)]) {
        [self.delegate header:self didSelectedDisplayCategory:NotificationDisplayCategoryReply];
    }
}

- (void)noticeButtonClicked:(UIButton *) sender{
    sender.enabled = NO;
    self.replyButton.enabled = YES;
    [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:didSelectedDisplayCategory:)]) {
        [self.delegate header:self didSelectedDisplayCategory:NotificationDisplayCategoryDefault];
    }
}

@end
