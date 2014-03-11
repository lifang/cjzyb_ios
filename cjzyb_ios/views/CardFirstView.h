//
//  CardFirstView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardFirstViewDelegate <NSObject>
-(void)pressedTxtBtn:(UIButton *)btn;
@end

@interface CardFirstView : UIControl

@property (nonatomic, assign) id<CardFirstViewDelegate>delegate;

@property (nonatomic, strong) IBOutlet UILabel *titleLab1;//拼错词汇

@property (nonatomic, strong) IBOutlet UILabel *wrongLetterLab,*rightLetterLab;

@property (nonatomic, strong) IBOutlet UILabel *titleLab2;//正确拼写

@property (nonatomic, strong) IBOutlet UIButton *txtBtn;


@end

