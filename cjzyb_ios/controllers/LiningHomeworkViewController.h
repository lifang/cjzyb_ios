//
//  LiningHomeworkViewController.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiningItemButton.h"
#import "LineSubjectObj.h"

#import "HomeworkContainerController.h"
#import "BasePostInterface.h"

/** LiningHomeworkViewController
 *
 * 连线任务
 */
@interface LiningHomeworkViewController : UIViewController
@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, strong) BasePostInterface *postInter;

///存放连线题的数组LineSubjectObj
@property (strong,nonatomic) NSArray *liningSubjectArray;
///当前正在做的小题
@property (strong,nonatomic) LineSubjectObj *currentlineSubjectObj;
///提示正确答案
-(void)tipCorrectAnswer;
///加载到下一题
-(void)reloadNextLineSubject;
@end
