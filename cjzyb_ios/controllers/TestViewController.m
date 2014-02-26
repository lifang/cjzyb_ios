//
//  TestViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (nonatomic,strong) LeftTabBarView *leftTabBarView;
@end

@implementation TestViewController

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
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"LeftTabBarView" owner:self options:nil];
    self.leftTabBarView = (LeftTabBarView*)[bundles objectAtIndex:0];
    self.leftTabBarView.frame = (CGRect){10,10,100,1004};
    self.leftTabBarView.delegate = self;
    [self.view addSubview:self.leftTabBarView];
    [self.leftTabBarView defaultSelected];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark LeftTabBarViewDelegate
-(void)leftTabBar:(LeftTabBarView *)tabBarView selectedItem:(LeftTabBarItemType)itemType{
    NSLog(@"%d",itemType);
}
#pragma mark --
@end
