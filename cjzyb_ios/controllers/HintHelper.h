//
//  HintHelper.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMHint.h"
#import "DRLeftTabBarViewController.h"

#define  kFirstMessage @"点击此按钮,可以展开导航栏"
#define  kSecondMessage @"点击此按钮,可以查看个人、班级信息"
#define  kThirdMessage @"点击此按钮,可以刷新当天题包"
#define  kFourthMessage @"点击此按钮,可以查看历史题包"
#define  kfifthMessage @"当天存在多个作业包可以试试左右滑动哦～"
#define  ksixthMessage @"点击此按钮,可以修改用户头像"
typedef enum
{
    EMHintDialogTypeMainLeftButton,//展开导航栏按钮
    EMHintDialogTypePersonImage,//修改头像
    EMHintDialogTypePersonInfo,//用户信息
    EMHintDialogTypeHomeWorkRefresh,//作业刷新
    EMHintDialogTypeHomeWorkHistory,//作业历史
    EMHintDialogTypeHomeWorkSlide//作业左右滑动
}EMHintDialogType;

@interface HintHelper : NSObject<EMHintDelegate>
{
    EMHintDialogType _curType;
    EMHint *modalState;
    DRLeftTabBarViewController *_vc;
}
- (id)initWithViewController:(DRLeftTabBarViewController*)vc;
@end
