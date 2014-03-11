//
//  AppDelegate.h
//  cjzyb_ios
//
//  Created by david on 14-2-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLNotificationViewController.h"

#import "TenSecChallengeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "SelectingChallengeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MPMoviePlayerController *player;
- (void)showRootView;
+(AppDelegate *)shareIntance;
@end
