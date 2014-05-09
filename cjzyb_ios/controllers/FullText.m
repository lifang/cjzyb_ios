//
//  FullText.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-4-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FullText.h"

@interface FullText ()

@end

@implementation FullText

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

-(void)setText:(NSString *)text {
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:22] constrainedToSize:CGSizeMake(330, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIScrollView *myScroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    myScroll.backgroundColor  =[UIColor clearColor];
    myScroll.delegate = self;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 320, size.height)];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode =NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [myScroll addSubview:label];
    
    
    myScroll.contentSize = CGSizeMake(332,size.height+10);
    [myScroll setScrollEnabled:YES];
    [self.view addSubview:myScroll];
}
@end
