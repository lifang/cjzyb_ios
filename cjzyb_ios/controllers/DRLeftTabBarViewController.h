//
//  DRLeftTabBarViewController.h
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftTabBarView.h"
#import "StudentListViewController.h"
/** DRLeftTabBarViewController
 *
 * 左侧边栏的tabbarcontroller
 
 */
@interface DRLeftTabBarViewController : UIViewController<LeftTabBarViewDelegate,StudentListViewControllerDelegate>
@property (assign,nonatomic) BOOL isHiddleLeftTabBar;

/** childenControllerArray
 *
 * 放置要显示的子controller
 */
@property (strong,nonatomic) NSArray *childenControllerArray;
@property (strong,nonatomic) UIViewController *currentViewController;
@end
