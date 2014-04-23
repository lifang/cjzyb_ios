//
//  ClozeView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UnderLineLabel.h"

@protocol ClozeViewDelegate <NSObject>
-(void)pressedLabel:(UIControl *)unLabel;

@end

@interface ClozeView : UIView
@property (nonatomic, assign) id<ClozeViewDelegate>delegate;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger number;//记录换行
- (void)setText:(NSString*)text;
@property (nonatomic, strong) NSString *tmpText;
@end
