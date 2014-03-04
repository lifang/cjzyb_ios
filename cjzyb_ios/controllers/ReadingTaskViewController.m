//
//  ReadingTaskViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ReadingTaskViewController.h"

@interface ReadingTaskViewController ()
///是否在读内容
@property (nonatomic,assign) BOOL isReading;
///是否在听录音
@property (nonatomic,assign) BOOL isListening;
@property (weak, nonatomic) IBOutlet UIView *tipBackView;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;
///要读的文字内容
@property (weak, nonatomic) IBOutlet UITextView *readingTextView;
/// 点击开始录音按钮
@property (weak, nonatomic) IBOutlet UIButton *readingButton;
///点击开始听内容按钮
@property (weak, nonatomic) IBOutlet UIButton *listeningButton;

/// 点击开始录音
- (IBAction)readingButtonClicked:(id)sender;

///点击开始听内容
- (IBAction)listeningButtonClicked:(id)sender;
@end

@implementation ReadingTaskViewController

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
    [self.listeningButton setImage:[UIImage imageNamed:@"listening_start.png"] forState:UIControlStateNormal];
    [self.listeningButton setImage:[UIImage imageNamed:@"listening_stop.png"] forState:UIControlStateDisabled];
    
    self.isReading = NO;
    self.isListening = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)readingButtonClicked:(id)sender {
    self.isReading = !self.isReading;
}

- (IBAction)listeningButtonClicked:(id)sender {
}

///更新所有的位置
-(void)updateAllFrame{
    NSAttributedString *attributeString = self.readingTextView.attributedText;
    if (!attributeString) {
        return ;
    }
    CGRect textRect = [attributeString boundingRectWithSize:(CGSize){CGRectGetWidth(self.readingTextView.frame),1024-350} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading context:nil];
    self.readingTextView.frame = (CGRect){self.readingTextView.frame.origin,CGRectGetWidth(self.readingTextView.frame),textRect.size.height};
    
    self.readingButton.frame = (CGRect){CGRectGetMinX(self.readingButton.frame),CGRectGetMaxY(self.readingButton.frame)+20,self.readingButton.frame.size};
    
    self.tipBackView.frame = (CGRect){CGRectGetMinX(self.tipBackView.frame),CGRectGetMaxY(self.readingButton.frame) +30,self.tipBackView.frame.size};
    
}

///标记颜色
-(void)markErrorColorRangeForArr:(NSArray*)rangeArray{

}

#pragma mark property
-(void)setIsReading:(BOOL)isReading{
    _isReading = isReading;
    if (!isReading) {
        [self.readingButton setImage:[UIImage imageNamed:@"reading_start.png"] forState:UIControlStateNormal];
        
    }else{
        [self.readingButton setImage:[UIImage imageNamed:@"reading_stop.png"] forState:UIControlStateNormal];
    }
}
-(void)setIsListening:(BOOL)isListening{
    _isListening = isListening;
    [self.listeningButton setEnabled:!isListening];
}
#pragma mark --
@end
