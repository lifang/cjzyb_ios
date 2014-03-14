//
//  SelectedViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectedViewController.h"

#import "ClozeAnswerViewController.h"
#define UnderLab_tag 1234567

@interface SelectedViewController ()
@property (nonatomic,strong) WYPopoverController *poprController;
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
    
    [self.clozeVV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.clozeVV removeFromSuperview];
    
    self.clozeVV = [[ClozeView alloc]initWithFrame:CGRectMake(-768, 60, 768, 400)];
    self.clozeVV.delegate = self;
    [self.clozeVV setText:[self.questionDic objectForKey:@"content"]];
    self.clozeVV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.clozeVV];
    
    CGRect frame = self.clozeVV.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:1.0 animations:^{
        self.clozeVV.frame = frame;
    } completion:^(BOOL finished){
    }];
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
#pragma mark -
#pragma mark - ClozeViewDelegate
-(void)pressedLabel:(UIControl *)control {
    self.tmpTag = control.tag-UnderLab_tag;
    ClozeAnswerViewController *clozeAnswerView = [[ClozeAnswerViewController alloc]initWithNibName:@"ClozeAnswerViewController" bundle:nil];
    NSArray *array = [self.questionDic objectForKey:@"branch_questions"];
    [clozeAnswerView setAnswerDic:[array objectAtIndex:control.tag-UnderLab_tag]];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:control];
    __block UIBarButtonItem *barItemm = barItem;
    self.poprController = [[WYPopoverController alloc] initWithContentViewController:clozeAnswerView];
    self.poprController.theme.tintColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    self.poprController.theme.fillTopColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    self.poprController.theme.fillBottomColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    self.poprController.theme.glossShadowColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    
    self.poprController.popoverContentSize = (CGSize){188,175};
    [self.poprController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        barItemm=nil;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"完形填空";
    
    //选择答案之后更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAnswerByClozeView:) name:@"reloadAnswerByClozeView" object:nil];
    
    [self getQuestionData];
}

- (void)reloadAnswerByClozeView:(NSNotification *)notification {
    NSString *answerStr = [notification object];
    
    UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:self.tmpTag+UnderLab_tag];
    [label setText:answerStr];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)checkAnswer:(id)sender {
    NSString *str = @"";
    for (int i=0; i<self.answerArray.count; i++) {
        UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:i+UnderLab_tag];
        if (label.text.length==0) {
            str = @"请填写完整!";
            break;
        }
    }
    if (str.length>0) {
        [Utility errorAlert:str];
    }else {
        for (int i=0; i<self.answerArray.count; i++) {
            UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:i+UnderLab_tag];
            NSDictionary *dic = [self.answerArray objectAtIndex:i];
            NSString *answer = [dic objectForKey:@"answer"];
            if ([label.text isEqualToString:answer]) {
                label.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
            }else {
                label.textColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
            }
        }
    }
}
@end
