//
//  LHLButton.h
//  cjzyb_ios
//
//  Created by apple on 14-3-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

/*
 自定义按钮的点击和拖拽方法,使其不会同时触发
 */
#import <UIKit/UIKit.h>
@protocol LHLButtonDelegate;
@interface LHLButton : UIButton
@property (nonatomic,strong) IBOutlet id<LHLButtonDelegate> delegate;
@end
@protocol LHLButtonDelegate <NSObject>

@required
- (void) coverButtonClicked:(id)sender;
- (void) coverButtonDraged:(BOOL)toLeft;
@end
