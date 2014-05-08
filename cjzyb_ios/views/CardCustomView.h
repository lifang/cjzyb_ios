//
//  CardCustomView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardObject.h"

@protocol CardCustomViewDelegate <NSObject>
-(void)pressedVoiceBtn:(UIButton *)btn;
-(void)pressedDeleteBtn:(UIButton *)btn;
-(void)pressedShowFullText:(NSString *)fullText andBtn:(UIButton *)btn;
@end

@interface CardCustomView : UIView

@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UIButton *remindButton;
@property (nonatomic, strong) IBOutlet UIImageView *remindImageView;

@property (nonatomic, assign) id<CardCustomViewDelegate>delegate;
@property (nonatomic, strong) CardObject *aCard;
@property (nonatomic, assign) NSInteger viewtag;
@property (nonatomic, strong) NSString *fullTextString;



@end
