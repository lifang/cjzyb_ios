//
//  ModelTypeViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ModelTypeViewController.h"
#define INPUTVIEW_MAX_HEIGHT 300
@interface ModelTypeViewController ()
@property (nonatomic,strong) UIWindow *presentWindow;
@property (nonatomic,strong) void(^finishedInput)(NSString *string);
@property (nonatomic,assign) BOOL isFinished;
@property (nonatomic,assign) int textViewContentHeight;
@property (nonatomic,strong) void(^cancel)();
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)OKButtonClicked:(id)sender;

- (IBAction)backgroundClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

+(id)defaultModelTypeViewController;
@end

@implementation ModelTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+(id)defaultModelTypeViewController{
    static ModelTypeViewController *modelController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelController = [[ModelTypeViewController alloc] initWithNibName:@"ModelTypeViewController" bundle:nil];
    });
    modelController.presentWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    modelController.presentWindow.rootViewController = modelController;
    modelController.presentWindow.windowLevel = UIWindowLevelAlert;
    return modelController;
}

+(void)presentTypeViewWithTipString:(NSString*)tip withFinishedInput:(void (^)(NSString *inputString))finished withCancel:(void(^)())cancel{
    ModelTypeViewController *controller = [ModelTypeViewController defaultModelTypeViewController];
    controller.cancel = cancel;
    controller.finishedInput = finished;
    [controller.presentWindow setHidden:NO];
    controller.textView.text = @"";
    if (tip) {
        controller.tipLabel.text = tip;
    }else{
    controller.tipLabel.text = @"请输入：";
    }
    [controller.textView becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float height = rect.size.height;
    self.inputBackView.frame = (CGRect){0,1024,CGRectGetWidth(self.view.frame),130};
    [UIView animateWithDuration:animationDuration animations:^{
         self.inputBackView.frame = (CGRect){0,1024-height-CGRectGetHeight(self.inputBackView.frame),CGRectGetWidth(self.view.frame),self.inputBackView.frame.size.height};
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){0,1024,CGRectGetWidth(self.view.frame),130};
    } completion:^(BOOL finished) {
        if (self.isFinished) {
            if (self.finishedInput) {
                self.finishedInput(self.textView.text);
            }
        }else{
            if (self.cancel) {
                self.cancel();
            }
        }
        
        self.presentWindow = nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OKButtonClicked:(id)sender {
    self.isFinished = YES;
    [self.textView resignFirstResponder];
}

- (IBAction)backgroundClicked:(id)sender {
    self.isFinished = NO;
    [self.textView resignFirstResponder];
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.textView.text = @"";
}


#pragma mark uitextviewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (CGRectGetHeight(self.inputBackView.frame) < INPUTVIEW_MAX_HEIGHT) {
        float height = textView.contentSize.height - self.textViewContentHeight;
        self.textViewContentHeight = textView.contentSize.height;
        CGRect rect =self.inputBackView.frame;
        self.inputBackView.frame = (CGRect){rect.origin.x,rect.origin.y-height,rect.size.width,rect.size.height+height};
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textViewContentHeight = textView.contentSize.height;
}
#pragma mark --
@end
