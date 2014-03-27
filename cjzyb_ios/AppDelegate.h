//
//  AppDelegate.h
//  cjzyb_ios
//
//  Created by david on 14-2-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AVFoundation/AVFoundation.h> 

#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//网络监听所用
@property (retain, nonatomic) Reachability *hostReach;
//网络是否连接
@property (assign, nonatomic) BOOL isReachable;

@property (nonatomic, strong) NSString *pushstr;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (strong, nonatomic) AVAudioPlayer *avPlayer;

@property (nonatomic, strong) AVAudioPlayer *truePlayer;
@property (nonatomic, strong) AVAudioPlayer *falsePlayer;
@property (nonatomic, assign) NSInteger notification_type;
- (void)showRootView;
+(AppDelegate *)shareIntance;

-(void)loadTrueSound:(NSInteger)index;
-(void)loadFalseSound:(NSInteger)index;


@property (nonatomic, assign) BOOL isReceiveTask,isReceiveNotification;
@end
