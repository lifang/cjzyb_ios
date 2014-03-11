//
//  CardCustomView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardCustomView.h"

@implementation CardCustomView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andFirst:nil andSecond:nil andObj:nil];
}
- (id)initWithFrame:(CGRect)frame andFirst:(CardFirstView *)first andSecond:(CardSecondView *)second andObj:(CardObject *)object 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.displayingPrimary = YES;
        
        self.cardFirst = first;
        CGRect frame1 = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.cardFirst setFrame: frame1];
        self.cardFirst.userInteractionEnabled = YES;
        self.cardFirst.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card_back"]];
        [self.cardFirst addTarget:self action:@selector(flipTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cardFirst];
        
        self.cardSecond = second;
        [self.cardSecond setFrame: frame1];
        [self addSubview:self.cardSecond];
        self.cardSecond.userInteractionEnabled = YES;
        [self sendSubviewToBack:self.cardSecond];
        self.cardSecond.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card_back_selected"]];
        [self.cardSecond addTarget:self action:@selector(flipTouched) forControlEvents:UIControlEventTouchUpInside];
        
        self.aCard = object;
        self.cardFirst.wrongLetterLab.text = self.aCard.your_answer;
        self.cardFirst.rightLetterLab.text = self.aCard.answer;
        
        [self.cardSecond.rtLab setText:self.aCard.content];
    
    }
    return self;
}

-(void)setViewtag:(NSInteger)viewtag {
    _viewtag = viewtag;
    
    self.cardFirst.txtBtn.tag = _viewtag;
    
    self.cardSecond.voiceBtn.tag = _viewtag;
    self.cardSecond.deleteBtn.tag = _viewtag;
}

-(void)flipTouched {
    [UIView transitionFromView:(self.displayingPrimary ? self.cardFirst : self.cardSecond)
                        toView:(self.displayingPrimary ? self.cardSecond : self.cardFirst)
                      duration: 1
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.displayingPrimary = !self.displayingPrimary;
                            
                            NSString *str = [NSString stringWithFormat:@"%d",self.viewtag];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"changePlayerByView" object:str];
                        }
                    }
     ];
}

@end
