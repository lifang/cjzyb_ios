//
//  UserInfoPopViewController.h
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DRLeftTabBarViewController;
/** UserInfoPopViewController
 *
 * 显示当前用户信息界面
 */
@interface UserInfoPopViewController : UIViewController
@property (strong,nonatomic) DRLeftTabBarViewController *drleftTabBarController;
///更新界面内容
-(void)updateViewContents;
@end
