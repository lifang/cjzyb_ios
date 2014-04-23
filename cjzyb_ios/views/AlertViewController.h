//
//  AlertViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AlertViewDelegate;

@interface AlertViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *subview;
@property (nonatomic, assign) id<AlertViewDelegate>delegate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) IBOutlet UIButton *upBtn;
@property (nonatomic, strong) IBOutlet UIButton *bottombtn;
@end

@protocol AlertViewDelegate <NSObject>

- (void)dismissPopView:(AlertViewController *)alertView andType:(NSInteger)type;

@end