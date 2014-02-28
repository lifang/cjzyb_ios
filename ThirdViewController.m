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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.txtView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Keyboard notifications
- (void)keyboardWillShow:(NSNotification *)notification {
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
- (void)keyboardWillHide:(NSNotification *)notification {
    
        NSDictionary *userInfo = [notification userInfo];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.keyboardHeight = 0;
                         }];

}

#pragma mark - Text view delegate
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
    CGSize size = self.txtView.contentSize;
    size.height -= 2;
    NSInteger maxHeight = self.view.frame.size.height-100-self.keyboardHeight;
    if ( size.height >= maxHeight ) {
        size.height = maxHeight;
    }
    else if ( size.height <= 190 ) {
        size.height = 190;
    }
    if ( size.height != self.txtView.frame.size.height ) {
        CGFloat span = size.height - self.txtView.frame.size.height;
        
        CGRect frame = self.sendBtn.frame;
        frame.origin.y += span;
        self.sendBtn.frame = frame;
        
        frame = self.txtView.frame;
        frame.size = size;
        self.txtView.frame = frame;
    }
}

@end
