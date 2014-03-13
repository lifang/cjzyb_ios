//
//  SortViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SortViewController.h"

@interface SortViewController ()

@end


#define Textfield_Width  180
#define Textfield_Height  60
#define Textfield_Space_Width 57
#define Textfield_Space_Height 20
#define CP_Answer_Button_Tag_Offset 1000
#define CP_Word_Button_Tag_Offset 10000

@implementation SortViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIButton *)returnButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:8];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:33];
    return btn;
}
-(void)setUI {
    self.currentWordIndex = 0;self.maps = nil;self.preBtn= nil;self.restartBtn=nil;self.actionArray=nil;self.isRestart=NO;
    
    [self.wordsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.wordsContainerView removeFromSuperview];
    self.wordsContainerView = [[UIView alloc]init];
    self.wordsContainerView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectMake(0, 0, Textfield_Width*1.5, Textfield_Height*1.2);
    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
    self.orgArray = [Utility handleTheString:content];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.orgArray];
    NSInteger count = tmpArray.count;
    
    int num1 = self.orgArray.count/3;//除以3的整数
    int num2 = self.orgArray.count%3;//除以3的余数
    //TODO:上半部分
    for (int i=0; i<num1; i++) {
        for (int k=0; k<3; k++) {
            UIButton *btn3 = [self returnButton];
            btn3.tag = 3*i+CP_Answer_Button_Tag_Offset+k;
            frame.origin.x = Textfield_Space_Width+(Textfield_Width+Textfield_Space_Width)*k;
            frame.origin.y = Textfield_Space_Height+(Textfield_Height+Textfield_Space_Height)*i;
            btn3.frame = frame;
            [btn3 setTitleColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] forState:UIControlStateNormal];
            
            [btn3 addTarget:self action:@selector(answerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.wordsContainerView addSubview:btn3];
        }
    }
    frame.origin.y += Textfield_Height+Textfield_Space_Height;
    for (int i=0; i<num2; i++) {
        UIButton *btn3 = [self returnButton];
        btn3.tag = 3*num1+CP_Answer_Button_Tag_Offset+i;
        CGFloat space = (768-Textfield_Width*num2)/(num2+1);
        frame.origin.x = space + (Textfield_Width+space)*i;
        btn3.frame = frame;
        [btn3 setTitleColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] forState:UIControlStateNormal];
        
        [btn3 addTarget:self action:@selector(answerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsContainerView addSubview:btn3];
    }
    
    //TODO:下半部分
    frame.origin.x = 0;
    CGFloat height = frame.origin.y + Textfield_Height+Textfield_Space_Height*5;
    for (int i=0; i<num1; i++) {
        for (int k=0; k<3; k++) {
            UIButton *btn3 = [self returnButton];
            btn3.tag = 3*i+CP_Word_Button_Tag_Offset+k;
            frame.origin.x = Textfield_Space_Width+(Textfield_Width+Textfield_Space_Width)*k;
            frame.origin.y = height+(Textfield_Height+Textfield_Space_Height)*i;
            btn3.frame = frame;
            btn3.backgroundColor = [UIColor colorWithRed:39/255.0 green:48/255.0 blue:57/255.0 alpha:1];
            int index = arc4random() % count;
            [btn3 setTitle:[tmpArray objectAtIndex:index] forState:UIControlStateNormal];
            [tmpArray removeObjectAtIndex:index];
            count--;

            [btn3 addTarget:self action:@selector(wordButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.wordsContainerView addSubview:btn3];
        }
    }
    frame.origin.y += Textfield_Height+Textfield_Space_Height;
    for (int i=0; i<num2; i++) {
        UIButton *btn3 = [self returnButton];
        btn3.tag = 3*num1+CP_Word_Button_Tag_Offset+i;
        
        CGFloat space = (768-Textfield_Width*num2)/(num2+1);
        frame.origin.x = space + (Textfield_Width+space)*i;
        btn3.frame = frame;
        btn3.backgroundColor = [UIColor colorWithRed:39/255.0 green:48/255.0 blue:57/255.0 alpha:1];
        int index = arc4random() % count;
        [btn3 setTitle:[tmpArray objectAtIndex:index] forState:UIControlStateNormal];
        [tmpArray removeObjectAtIndex:index];
        count--;

        [btn3 addTarget:self action:@selector(wordButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsContainerView addSubview:btn3];
    }
    
    self.preBtn.frame = CGRectMake(122, frame.origin.y+Textfield_Height+Textfield_Space_Height*5, 200, 80);
    self.restartBtn.frame = CGRectMake(445, frame.origin.y+Textfield_Height+Textfield_Space_Height*5, 200, 80);
    
    [self.wordsContainerView setFrame:CGRectMake(-768, 130, 768, frame.origin.y+Textfield_Height+Textfield_Space_Height*5+100)];
    [self.view addSubview:self.wordsContainerView];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(0, 130, 768, frame.origin.y+Textfield_Height+Textfield_Space_Height*5+100)];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                NSArray *subViews = [self.wordsContainerView subviews];
                for (UIView *vv in subViews) {
                    if ([vv isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)vv;
                        CGRect frame = btn.frame;
                        frame.size.width = Textfield_Width;
                        frame.size.height = Textfield_Height;
                        btn.frame = frame;
                    }
                }
            } completion:^(BOOL finished){
            }];
        }
    }];
}
-(void)getQuestionData {
    NSDictionary * dic = [Utility initWithJSONFile:@"question"];
    NSDictionary *sortDic = [dic objectForKey:@"sort"];
    self.questionArray = [NSMutableArray arrayWithArray:[sortDic objectForKey:@"questions"]];
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    
    self.branchQuestionArray = [self.questionDic objectForKey:@"branch_questions"];
    self.branchQuestionDic = [self.branchQuestionArray objectAtIndex:self.branchNumber];
    NSLog(@"dic = %@",self.branchQuestionDic);
    
    [self setUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"排序";
    
    [self getQuestionData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIButton *)preBtn {
    if (!_preBtn) {
        _preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preBtn setTitle:@"后退一步" forState:UIControlStateNormal];
        [_preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _preBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        _preBtn.enabled = NO;
        [_preBtn.layer setMasksToBounds:YES];
        [_preBtn.layer setCornerRadius:8];
        _preBtn.titleLabel.font = [UIFont systemFontOfSize:33];
        [_preBtn addTarget:self action:@selector(preButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsContainerView addSubview:_preBtn];
    }
    return _preBtn;
}
-(UIButton *)restartBtn {
    if (!_restartBtn) {
        _restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_restartBtn setTitle:@"重新排序" forState:UIControlStateNormal];
        [_restartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _restartBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        _restartBtn.enabled = NO;
        [_restartBtn.layer setMasksToBounds:YES];
        [_restartBtn.layer setCornerRadius:8];
        _restartBtn.titleLabel.font = [UIFont systemFontOfSize:33];
        [_restartBtn addTarget:self action:@selector(restartButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsContainerView addSubview:_restartBtn];
    }
    return _restartBtn;
}
-(NSMutableDictionary *)maps {
    if (!_maps) {
        _maps = [[NSMutableDictionary alloc]init];
    }
    return _maps;
}
-(NSMutableArray *)actionArray {
    if (!_actionArray) {
        _actionArray = [[NSMutableArray alloc]init];
    }
    return _actionArray;
}
#pragma mark - 
#pragma mark - button点击事件
-(void)setPreButtonUI {
    if (self.actionArray.count>0) {
        self.preBtn.backgroundColor = [UIColor clearColor];
        [self.preBtn setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        self.preBtn.enabled = YES;
    }else {
        
        self.preBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        [self.preBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.preBtn.enabled = NO;
    }
}
-(void)setRestartButtonUI {
    if (self.isRestart>0) {
        self.restartBtn.backgroundColor = [UIColor clearColor];
        [self.restartBtn setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        self.restartBtn.enabled = YES;
    }else {
        self.restartBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        [self.restartBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.restartBtn.enabled = NO;
    }
}
-(void)answerButtonSelected:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if([btn.titleLabel.text length]>0){
        [btn setTitle:nil forState:UIControlStateNormal];
        btn.titleLabel.text = nil;
        self.isRestart--;
        [self setRestartButtonUI];
        
        int targetTag = [[self.maps objectForKey:[NSString stringWithFormat:@"%d",(btn.tag-CP_Answer_Button_Tag_Offset)]] intValue];
        UIButton *wordBtn = (UIButton *)[self.wordsContainerView viewWithTag:targetTag];
        wordBtn.enabled = YES;
        wordBtn.backgroundColor = [UIColor colorWithRed:39/255.0 green:48/255.0 blue:57/255.0 alpha:1];
        
        [self.actionArray addObject:[NSString stringWithFormat:@"%d_%d",btn.tag,wordBtn.tag]];
        [self setPreButtonUI];
        
        if(self.currentWordIndex > (btn.tag - CP_Answer_Button_Tag_Offset))
            self.currentWordIndex = btn.tag - CP_Answer_Button_Tag_Offset;
    }
}
- (void)wordButtonSelected:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *text = btn.titleLabel.text;
    
    UIView *unkonw = [self.wordsContainerView viewWithTag:(self.currentWordIndex+CP_Answer_Button_Tag_Offset)];
    if ([unkonw isKindOfClass:[UIButton class]]) {
        UIButton *answerBtn = (UIButton *)unkonw;
        [answerBtn setTitle:text forState:UIControlStateNormal];
        
        [self.actionArray addObject:[NSString stringWithFormat:@"%d_%d",btn.tag,answerBtn.tag]];
        [self setPreButtonUI];
        
        self.isRestart++;
        [self setRestartButtonUI];
    }
    
    btn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    btn.enabled = NO;
    
    [self.maps setObject:[NSString stringWithFormat:@"%d",btn.tag] forKey:[NSString stringWithFormat:@"%d",self.currentWordIndex]];

    // 当前填的字不是最后一个，看下后面的字是否已经填了
    while (self.currentWordIndex!=(self.orgArray.count-1)) {
        self.currentWordIndex++;
        UIButton *ab = nil;
        UIView *uk = [self.view viewWithTag:(self.currentWordIndex+CP_Answer_Button_Tag_Offset)];
        if([uk isKindOfClass:[UIButton class]]) {
            ab = (UIButton *)uk;
        }
        if([ab.titleLabel.text length]==0)
            return;
    }

}
//后退一步
-(void)preButtonSelected:(id)sender {
    if (self.actionArray.count>0) {
        NSString *tagStr = [self.actionArray lastObject];
        NSArray *array = [tagStr componentsSeparatedByString:@"_"];
        NSString *tag1 = [array objectAtIndex:0];
        NSString *tag2 = [array objectAtIndex:1];
        if (tag1.length==5) {//表示添加
            UIButton *wordBtn = (UIButton *)[self.wordsContainerView viewWithTag:[tag1 intValue]];
            wordBtn.enabled = YES;
            wordBtn.backgroundColor = [UIColor colorWithRed:39/255.0 green:48/255.0 blue:57/255.0 alpha:1];
            
            UIButton *answerBtn = (UIButton *)[self.wordsContainerView viewWithTag:[tag2 intValue]];
            [answerBtn setTitle:nil forState:UIControlStateNormal];
            answerBtn.titleLabel.text = nil;
            self.isRestart--;
            [self setRestartButtonUI];
            
        }else{//表示删除
            UIButton *wordBtn = (UIButton *)[self.wordsContainerView viewWithTag:[tag2 intValue]];
            wordBtn.enabled = NO;
            wordBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
            
            NSString *text = wordBtn.titleLabel.text;
            UIButton *answerBtn = (UIButton *)[self.wordsContainerView viewWithTag:[tag1 intValue]];
            [answerBtn setTitle:text forState:UIControlStateNormal];
            self.isRestart++;
            [self setRestartButtonUI];
        }
        
        [self.actionArray removeLastObject];
        [self setPreButtonUI];
        self.currentWordIndex--;
        if (self.currentWordIndex<0) {
            self.currentWordIndex=0;
        }
    }
}
//重新开始
-(void)restartButtonSelected:(id)sender {
    self.actionArray=nil;self.isRestart=0;self.maps=nil;self.currentWordIndex=0;
    [self setPreButtonUI];[self setRestartButtonUI];
    
    for (int i=0; i<self.orgArray.count; i++) {
        UIButton *wordBtn = (UIButton *)[self.wordsContainerView viewWithTag:i+CP_Word_Button_Tag_Offset];
        wordBtn.enabled = YES;
        wordBtn.backgroundColor = [UIColor colorWithRed:39/255.0 green:48/255.0 blue:57/255.0 alpha:1];
        
        UIButton *answerBtn = (UIButton *)[self.wordsContainerView viewWithTag:i+CP_Answer_Button_Tag_Offset];
        [answerBtn setTitle:nil forState:UIControlStateNormal];
        answerBtn.titleLabel.text = nil;
    }
}
@end
