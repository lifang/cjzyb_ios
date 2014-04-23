//
//  DRNavigationBar.h
//  cjzyb_ios
//
//  Created by david on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRNavigationBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *rightButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@end
