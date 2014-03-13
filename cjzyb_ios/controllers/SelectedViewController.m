//
//  SelectedViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectedViewController.h"

@interface SelectedViewController ()

@end

@implementation SelectedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setUI {
    
}

-(void)getQuestionData {
    NSDictionary * dic = [Utility initWithJSONFile:@"question"];
    NSDictionary *sortDic = [dic objectForKey:@"cloze"];
    self.questionArray = [NSMutableArray arrayWithArray:[sortDic objectForKey:@"questions"]];
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    NSLog(@"dic = %@",self.questionDic);
    
    self.answerArray = [NSMutableArray arrayWithArray:[self.questionDic objectForKey:@"branch_questions"]];
    
    [self setUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"完形填空";
    
    [self getQuestionData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
