//
//  DRProgressView.h
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRProgressView : UIView
@property (assign,nonatomic) float progress;
-(void)setProgressValue:(float)progress withLevelName:(NSString*)levelName;
@end
