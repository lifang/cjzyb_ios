//
//  LiningItemButton.m
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LiningItemButton.h"

@implementation LiningItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initDefaultLiningItemButton{
    LiningItemButton *button = [[LiningItemButton alloc] init];
    button.layer.cornerRadius = 10;
    button.backgroundColor = [UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:35]];
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    return button;
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
-(void)setLiningSentenceObj:(LineDualSentenceObj *)liningSentenceObj{
    _liningSentenceObj = liningSentenceObj;
    if (liningSentenceObj) {
        if (self.liningLocationIndex%2 == 0) {
            [self setTitle:liningSentenceObj.lineDualSentenceRight forState:UIControlStateNormal];
        }else{
            [self setTitle:liningSentenceObj.lineDualSentenceLeft forState:UIControlStateNormal];
        }
    }
}

-(void)setIsTaped:(BOOL)isTaped{
    _isTaped = isTaped;
    if (isTaped) {
        self.backgroundColor = [UIColor colorWithRed:47/255.0 green:200/255.0 blue:132/255.0 alpha:1];
    }else{
        self.backgroundColor = [UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1];
    }
}

-(void)setIsTiped:(BOOL)isTiped{
    _isTiped = isTiped;
    if (isTiped) {
        self.layer.borderWidth = 4;
        switch (self.liningLocationIndex) {
            case 0:
                self.layer.borderColor = [UIColor orangeColor].CGColor;
                break;
            case 1:
                self.layer.borderColor = [UIColor purpleColor].CGColor;
                break;
            case 2:
                self.layer.borderColor = [UIColor blueColor].CGColor;
                break;
            case 3:
                self.layer.borderColor = [UIColor brownColor].CGColor;
                break;
            case 4:
                self.layer.borderColor = [UIColor yellowColor].CGColor;
                break;
            default:
                self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                break;
        }
    }else{
        self.layer.borderWidth = 0;
    }
}
#pragma mark --
@end
