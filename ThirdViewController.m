//
//  ThirdViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

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
    self.third = 3;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    int lastObject = [[[DataService sharedService].numberOfViewArray lastObject]intValue];
    
    if (lastObject==self.third){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowThird:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHideThird:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.txtView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Keyboard notifications
- (void)keyboardWillShowThird:(NSNotification *)notification {
    int lastObject = [[[DataService sharedService].numberOfViewArray lastObject]intValue];
    if (lastObject == self.third) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.keyboardHeight = keyboardRect.size.height;
                         }];
    }
    
}
- (void)keyboardWillHideThird:(NSNotification *)notification {
    int lastObject = [[[DataService sharedService].numberOfViewArray lastObject]intValue];
    if (lastObject == self.third){
        NSDictionary *userInfo = [notification userInfo];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.keyboardHeight = 0;
                         }];
    }
    
}

#pragma mark - Text view delegate
#pragma mark ---- 计算文本的字数
- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    NSString *string = self.txtView.text;
    int wordcount = [self textLength:string];
    
	NSInteger count  = 60 - wordcount;
    if (count<0) {
        [self.textCountLabel setText:[NSString stringWithFormat:@"还可以输入%i个字",0]];
    }else {
        [self.textCountLabel setText:[NSString stringWithFormat:@"还可以输入%i个字",count]];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        //TODO:添加事件
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)_textView {
    [self calculateTextLength];
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
-(IBAction)sendQuestion:(id)sender {
    [self.txtView resignFirstResponder];
    
    int wordcount = [self textLength:self.txtView.text];
    if (wordcount>60) {
        [Utility errorAlert:@"最多输入60个字!"];
    }else {
        if (self.appDel.isReachable == NO) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
            self.questionInter = [[QuestionInterface alloc]init];
            self.questionInter.delegate = self;
            [self.questionInter getQuestionInterfaceDelegateWithUserId:[DataService sharedService].user.userId andUserType:@"1" andClassId:[DataService sharedService].theClass.classId andContent:self.txtView.text];
        }
    }
}
#pragma mark 
#pragma mark - QuestionInterfaceDelegate
-(void)getQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
            self.txtView.text = @"";self.textCountLabel.text = @"还可以输入60字";
            NSArray *array = [result objectForKey:@"micropost"];
            NSDictionary *dic = [array objectAtIndex:0];
            MessageObject *message = [MessageObject messageFromDictionary:dic];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFirstArrayByThirdView" object:message];
            NSString *indexString = [NSString stringWithFormat:@"%d",1];
            if ([[DataService sharedService].numberOfViewArray containsObject:indexString]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSecondArrayByThirdView" object:message];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedViewController" object:nil];
        });
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
