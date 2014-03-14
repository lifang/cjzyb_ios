//
//  ListenWriteViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-12.
//  Copyright (c) 2014年 david. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ListenWriteViewController.h"

@interface ListenWriteViewController ()

@end

#define Textfield_Tag 76734789
#define Textfield_Width  180
#define Textfield_Height  60
#define Textfield_Space_Width 25
#define Textfield_Space_Height 60

@implementation ListenWriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UITextField *)returnTextField {
    UITextField *txt = [[UITextField alloc]init];
    txt.delegate = self;
    txt.borderStyle = UITextBorderStyleNone;
    txt.backgroundColor = [UIColor whiteColor];
    txt.textColor = [UIColor blackColor];
    txt.textAlignment = NSTextAlignmentCenter;
    txt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt.font = [UIFont systemFontOfSize:33];
    [txt.layer setMasksToBounds:YES];
    [txt.layer setCornerRadius:8];
    return txt;
}
-(void)setUI {
    [self.wordsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.wordsContainerView removeFromSuperview];
    self.wordsContainerView = [[UIView alloc]init];
    self.wordsContainerView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectMake(0, 0, Textfield_Width*1.2, Textfield_Height*1.2);
    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
    self.orgArray = [Utility handleTheString:content];
    self.metaphoneArray = [Utility metaphoneArray:self.orgArray];
    self.tmpArray = nil;
    
    for (int i=0; i<self.orgArray.count; i++) {
        UITextField *text = [self returnTextField];
        text.tag = i+Textfield_Tag;
        frame.origin.x = 10+(Textfield_Width+Textfield_Space_Width)*(i%3);
        frame.origin.y = 10+(Textfield_Height+Textfield_Space_Height)*(i/3);
        text.frame = frame;
        [self.wordsContainerView addSubview:text];
    }
    
    self.wordsContainerView.frame = CGRectMake(768, 53, 640, frame.origin.y+Textfield_Height+Textfield_Space_Height);
    [self.view addSubview:self.wordsContainerView];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(108, 53, 640, frame.origin.y+Textfield_Height+Textfield_Space_Height)];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                NSArray *subViews = [self.wordsContainerView subviews];
                for (UIView *vv in subViews) {
                    if ([vv isKindOfClass:[UITextField class]]) {
                        UITextField *text = (UITextField *)vv;
                        CGRect frame = text.frame;
                        frame.size.width = Textfield_Width;
                        frame.size.height = Textfield_Height;
                        text.frame = frame;
                    }
                }
            } completion:^(BOOL finished){
            }];
        }
    }];
}
-(void)getQuestionData {
    NSDictionary * dic = [Utility initWithJSONFile:@"question"];
    NSDictionary *listebDic = [dic objectForKey:@"listening"];
    self.questionArray = [NSMutableArray arrayWithArray:[listebDic objectForKey:@"questions"]];
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    
    self.branchQuestionArray = [self.questionDic objectForKey:@"branch_questions"];
    self.branchQuestionDic = [self.branchQuestionArray objectAtIndex:self.branchNumber];
    NSLog(@"dic = %@",self.branchQuestionDic);
    
    [self setUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"听写";
    self.number = 0;self.branchNumber=0;
    
    [self getQuestionData];
    [Utility shared].isOrg = YES;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(NSMutableArray *)tmpArray {
    if (!_tmpArray) {
        _tmpArray = [[NSMutableArray alloc]init];
    }
    return _tmpArray;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
//    NSArray *contentArray = [Utility handleTheString:content];

    if (self.tmpArray.count>=(textField.tag-Textfield_Tag+1)) {
        [self.tmpArray replaceObjectAtIndex:(textField.tag-Textfield_Tag) withObject:textField.text];
    }else {
        [self.tmpArray addObject:textField.text];
    }
    
//    if (self.tmpArray.count == contentArray.count) {
        [Utility shared].isOrg = NO;
        
        NSString *originString = [self.tmpArray componentsJoinedByString:@" "];
        NSArray *array1 = [Utility handleTheString:originString];
        NSArray *array2 = [Utility metaphoneArray:array1];
        
        [Utility shared].sureArray = [[NSMutableArray alloc]init];
        [Utility shared].correctArray = [[NSMutableArray alloc]init];
        [Utility shared].noticeArray = [[NSMutableArray alloc]init];
        [Utility shared].greenArray = [[NSMutableArray alloc]init];
        [Utility shared].yellowArray = [[NSMutableArray alloc]init];
        [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
        [Utility shared].wrongArray = [[NSMutableArray alloc]init];
        [Utility shared].firstpoint = 0;
        
        self.resultDic = [Utility compareWithArray:array1 andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray WithRange:[Utility shared].rangeArray];
        
        NSLog(@"%@",self.resultDic);
        
        [self resetUI];
//    }
}
-(UILabel *)returnLabel {
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1];
    lab.font = [UIFont systemFontOfSize:22];
    return lab;
}
-(void)resetUI {
    NSString *originString = [self.tmpArray componentsJoinedByString:@" "];
    NSArray *subViews = [self.wordsContainerView subviews];
    for (UIView *vv in subViews) {
        if ([vv isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)vv;
            if (lab.tag == 765) {
                [lab removeFromSuperview];
            }
        }
    }
    
    self.remindLab.text = @"";
    //绿色--完全正确
    if (![[self.resultDic objectForKey:@"green"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"green"]!=nil) {
        NSMutableArray *green_array = [self.resultDic objectForKey:@"green"];
        for (int i=0; i<green_array.count; i++) {
            NSTextCheckingResult *math = (NSTextCheckingResult *)[green_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            NSString *str = [originString substringWithRange:range];
            for (UIView *vv in subViews) {
                if ([vv isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)vv;
                    if ([textField.text isEqualToString:str]) {
                        textField.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
                    }
                }
            }
        }
    }
    
    //黄色－－部分匹配＋基本正确
    if (![[self.resultDic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"yellow"]!=nil) {
        NSMutableArray *yellow_array = [self.resultDic objectForKey:@"yellow"];
        for (int i=0; i<yellow_array.count; i++) {
            NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            NSString *str = [originString substringWithRange:range];
            for (UIView *vv in subViews) {
                if ([vv isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)vv;
                    if ([textField.text isEqualToString:str]) {
                        textField.textColor = [UIColor colorWithRed:0/255.0 green:5/255.0 blue:28/255.0 alpha:1];
                        
                        BOOL isExit = NO;
                        if (![[self.resultDic objectForKey:@"notice"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"notice"]!=nil) {
                            NSMutableArray *notice_array = [self.resultDic objectForKey:@"notice"];
                            NSArray *sureArray = [self.resultDic objectForKey:@"sure"];
                            
                            int index = arc4random() % (sureArray.count);
                            self.remindLab.text = [sureArray objectAtIndex:index];
                            
                            for (int k=0; k<notice_array.count; k++) {
                                NSTextCheckingResult *math2 = (NSTextCheckingResult *)[notice_array objectAtIndex:k];
                                NSRange range2 = [math2 rangeAtIndex:0];
                                if (range.location==range2.location && range.length==range2.length) {
                                    isExit = YES;
                                    CGRect frame = textField.frame;
                                    frame.origin.y += frame.size.height;
                                    frame.size.height = 40;
                                    UILabel *lab = [self returnLabel];
                                    lab.frame = frame;
                                    lab.tag = 765;
                                    lab.text = [sureArray objectAtIndex:k];
                                    [self.wordsContainerView addSubview:lab];
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    if (![[self.resultDic objectForKey:@"wrong"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"wrong"]!=nil) {
        NSMutableArray *yellow_array = [self.resultDic objectForKey:@"wrong"];
        for (int i=0; i<yellow_array.count; i++) {
            NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            NSString *str = [originString substringWithRange:range];
            for (UIView *vv in subViews) {
                if ([vv isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)vv;
                    if ([textField.text isEqualToString:str]) {
                        textField.textColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
                    }
                }
            }
        }
    }
}
@end
