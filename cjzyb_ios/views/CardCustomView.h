//
//  CardCustomView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardFirstView.h"
#import "CardSecondView.h"
#import "CardObject.h"
@interface CardCustomView : UIView

@property (nonatomic, strong) CardFirstView *cardFirst;
@property (nonatomic, strong) CardSecondView *cardSecond;
@property (nonatomic, assign) BOOL displayingPrimary;
@property (nonatomic, strong) CardObject *aCard;
@property (nonatomic, assign) NSInteger viewtag;


@property (nonatomic, strong) NSString *fullTextString;
-(void)flipTouched;

- (id)initWithFrame:(CGRect)frame andFirst:(CardFirstView *)first andSecond:(CardSecondView *)second andObj:(CardObject *)object;
@end
