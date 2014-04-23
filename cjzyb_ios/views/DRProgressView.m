//
//  DRProgressView.m
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRProgressView.h"
@interface DRProgressView()
@property (nonatomic,weak) IBOutlet UIImageView *backImageView;
@property (nonatomic,weak) IBOutlet UIImageView *trackImageView;
@property (nonatomic,weak) IBOutlet  UILabel *levelLabel;
@end
@implementation DRProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateContentWithScore:(int)score{
    int value = score%100;
    [self setProgressValue:value/100.0 withLevelName:[NSString stringWithFormat:@"LV%d",score/100]];
}

-(void)setProgressValue:(float)progress withLevelName:(NSString*)levelName{
    self.progress = progress;
    self.levelLabel.text = levelName;
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    self.trackImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.trackImageView.clipsToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark property
-(void)setProgress:(float)progress{
    _progress = progress;
    self.trackImageView.frame = (CGRect){CGRectGetMinX(self.backImageView.frame),0,CGRectGetWidth(self.frame)*progress,CGRectGetHeight(self.trackImageView.frame)};
}
#pragma mark --
@end
