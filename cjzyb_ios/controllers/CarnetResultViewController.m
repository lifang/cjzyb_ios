//
//  CarnetResultViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CarnetResultViewController.h"

@interface CarnetResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinzhunLabel;
@property (weak, nonatomic) IBOutlet UILabel *youyiLabel;
@property (weak, nonatomic) IBOutlet UILabel *xunsuLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiezuLabel;
@property (weak, nonatomic) IBOutlet UIButton *reStartButton;
- (IBAction)finishedButtonClicked:(id)sender;
- (IBAction)reStartButtonClicked:(id)sender;

@end

@implementation CarnetResultViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishedButtonClicked:(id)sender {
}

- (IBAction)reStartButtonClicked:(id)sender {
}
@end
