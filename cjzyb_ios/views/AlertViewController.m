//
//  AlertViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.subview.layer setCornerRadius:8];
    [self.subview.layer setMasksToBounds:YES];
    
    
    [self.upBtn.layer setCornerRadius:8];
    [self.upBtn.layer setMasksToBounds:YES];
    [self.upBtn setBackgroundColor:[UIColor colorWithRed:29./255. green:117./255. blue:81./255. alpha:1]];
    
    
    [self.bottombtn.layer setCornerRadius:8];
    [self.bottombtn.layer setMasksToBounds:YES];
    [self.bottombtn setBackgroundColor:[UIColor colorWithRed:29./255. green:117./255. blue:81./255. alpha:1]];
    
    if (_type == 0) {
        [self.upBtn setTitle:@"下载作业包" forState:UIControlStateNormal];
        [self.bottombtn setTitle:@"取消下载" forState:UIControlStateNormal];
    }else {
        [self.upBtn setTitle:@"查看答案" forState:UIControlStateNormal];
        [self.bottombtn setTitle:@"重新做题" forState:UIControlStateNormal];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)setType:(NSInteger)type {
    _type = type;
}
- (IBAction)upBtnSeceltedTo:(id)sender {
    self.isSuccess = YES;
    [self.delegate dismissPopView:self andType:self.type];
}
- (IBAction)bottomBtnSeceltedTo:(id)sender {
    self.isSuccess = NO;
    [self.delegate dismissPopView:self andType:self.type];
}

- (IBAction)closeBtnPressed:(id)sender {
    self.isSuccess = NO;
    [self.delegate dismissPopView:self andType:-1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
