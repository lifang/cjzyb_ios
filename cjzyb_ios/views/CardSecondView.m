//
//  CardSecondView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardSecondView.h"

@implementation CardSecondView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)voiceButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedVoiceBtn:)]) {
        [self.delegate pressedVoiceBtn:self.voiceBtn];
    }
}

-(IBAction)deleteButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedDeleteBtn:)]) {
        [self.delegate pressedDeleteBtn:self.deleteBtn];
    }
}
@end
