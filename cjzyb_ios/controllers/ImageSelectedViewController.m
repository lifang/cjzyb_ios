//
//  ImageSelectedViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-24.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ImageSelectedViewController.h"

@interface ImageSelectedViewController ()

@end

@implementation ImageSelectedViewController

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

-(IBAction)showImageWithAlbum:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showImageWithAlbum" object:nil];
}
-(IBAction)showImageWithCamera:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showImageWithCamera" object:nil];
}
@end
