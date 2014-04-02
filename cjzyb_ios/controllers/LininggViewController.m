//
//  LininggViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-19.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LininggViewController.h"

static BOOL isCanUpLoad = NO;

@interface LininggViewController ()
@property (nonatomic, strong) TenSecChallengeResultView *resultView;
@property (nonatomic, assign) int prop_number;
@end
#define Left_button_tag 1000
#define Right_button_tag 10000

#define BUTTON_WIDTH 180
#define BUTTON_SPACE 136

@implementation LininggViewController



-(UIButton *)returnUIButton {
    UIButton *btn = [[UIButton alloc]init];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:8];
    btn.titleLabel.font = [UIFont systemFontOfSize:33];
    btn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setExclusiveTouch :YES];
    return btn;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableArray *)propsArray {
    if (!_propsArray) {
        _propsArray = [[NSMutableArray alloc]init];
    }
    return _propsArray;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
-(NSMutableArray *)leftArray {
    if (!_leftArray) {
        _leftArray = [[NSMutableArray alloc]init];
    }
    return _leftArray;
}
-(NSMutableArray *)rightArray {
    if (!_rightArray) {
        _rightArray = [[NSMutableArray alloc]init];
    }
    return _rightArray;
}
-(NSMutableArray *)tmpLeftArray {
    if (!_tmpLeftArray) {
        _tmpLeftArray = [[NSMutableArray alloc]init];
    }
    return _tmpLeftArray;
}
-(NSMutableArray *)tmpRightArray {
    if (!_tmpRightArray) {
        _tmpRightArray = [[NSMutableArray alloc]init];
    }
    return _tmpRightArray;
}
-(NSMutableArray *)cancelTmpLeftArray {
    if (!_cancelTmpLeftArray) {
        _cancelTmpLeftArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _cancelTmpLeftArray;
}
-(NSMutableArray *)cancelTmpRightArray {
    if (!_cancelTmpRightArray) {
        _cancelTmpRightArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _cancelTmpRightArray;
}

-(void)setUI {
    self.tmpLeftArray=nil;self.tmpRightArray=nil;self.cancelTmpLeftArray=nil;self.cancelTmpRightArray=nil;
    [self.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
    [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.checkHomeworkButton addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wordsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.wordsContainerView removeFromSuperview];
    self.wordsContainerView = [[LiningDrawLinesView alloc]init];
    self.wordsContainerView.backgroundColor = [UIColor clearColor];
    
    //TODO:左半部分
    CGRect frame = CGRectMake(0, 0, BUTTON_WIDTH*1.5, BUTTON_WIDTH*1.5);
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.leftArray];
    NSInteger count = tmpArray.count;
    for (int i=0; i<self.leftArray.count; i++) {
        UIButton *btn = [self returnUIButton];
        frame.origin.x = BUTTON_SPACE;
        frame.origin.y = (BUTTON_SPACE+BUTTON_WIDTH-80)*i;
        btn.frame = frame;
        btn.tag = Left_button_tag+i;
        
        int index = arc4random() % count;
        [btn setTitle:[tmpArray objectAtIndex:index] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tmpArray removeObjectAtIndex:index];
        count--;
        [self.wordsContainerView addSubview:btn];
    }
    
    //TODO:右半部分
    frame = CGRectMake(0, 0, BUTTON_WIDTH*1.5, BUTTON_WIDTH*1.5);
    tmpArray = [NSMutableArray arrayWithArray:self.rightArray];
    count = tmpArray.count;
    for (int i=0; i<self.rightArray.count; i++) {
        UIButton *btn = [self returnUIButton];
        frame.origin.x = BUTTON_SPACE+BUTTON_SPACE+BUTTON_WIDTH;
        frame.origin.y = (BUTTON_SPACE+BUTTON_WIDTH-80)*i;
        btn.frame = frame;
        btn.tag = Right_button_tag+i;
        
        int index = arc4random() % count;
        [btn setTitle:[tmpArray objectAtIndex:index] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tmpArray removeObjectAtIndex:index];
        count--;
        [self.wordsContainerView addSubview:btn];
    }
    
    [self.wordsContainerView setFrame:CGRectMake(-768, 80, 768, frame.origin.y+frame.size.height+100)];
    [self.view addSubview:self.wordsContainerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(0, 80, 768, frame.origin.y+frame.size.height+100)];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
                NSArray *subViews = [self.wordsContainerView subviews];
                for (UIView *vv in subViews) {
                    if ([vv isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)vv;
                        CGRect frame = btn.frame;
                        frame.size.width = BUTTON_WIDTH;
                        frame.size.height = BUTTON_WIDTH;
                        btn.frame = frame;
                    }
                }
            } completion:^(BOOL finished){
            }];
        }
    }];
}
-(void)setHistoryUI {
    self.tmpLeftArray=nil;self.tmpRightArray=nil;self.cancelTmpLeftArray=nil;self.cancelTmpRightArray=nil;
    
    if (self.number==self.history_questionArray.count-1) {
        [self.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.checkHomeworkButton addTarget:self action:@selector(finishHistoryQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [self.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
        [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.checkHomeworkButton addTarget:self action:@selector(nextHistoryQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.wordsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.wordsContainerView removeFromSuperview];
    self.wordsContainerView = [[LiningDrawLinesView alloc]init];
    self.wordsContainerView.backgroundColor = [UIColor clearColor];
    
    //TODO:左半部分
    CGRect frame = CGRectMake(0, 0, BUTTON_WIDTH*1.5, BUTTON_WIDTH*1.5);
    for (int i=0; i<self.leftArray.count; i++) {
        UIButton *btn = [self returnUIButton];
        frame.origin.x = BUTTON_SPACE;
        frame.origin.y = (BUTTON_SPACE+BUTTON_WIDTH-100)*i;
        btn.frame = frame;
        btn.tag = Left_button_tag+i;
        btn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [self.tmpLeftArray addObject:[NSString stringWithFormat:@"%d",Left_button_tag+i]];
        [btn setTitle:[self.leftArray objectAtIndex:i] forState:UIControlStateNormal];
        [self.wordsContainerView addSubview:btn];
    }
    
    //TODO:右半部分
    frame = CGRectMake(0, 0, BUTTON_WIDTH*1.5, BUTTON_WIDTH*1.5);
    for (int i=0; i<self.rightArray.count; i++) {
        UIButton *btn = [self returnUIButton];
        frame.origin.x = BUTTON_SPACE+BUTTON_SPACE+BUTTON_WIDTH;
        frame.origin.y = (BUTTON_SPACE+BUTTON_WIDTH-100)*i;
        btn.frame = frame;
        btn.tag = Right_button_tag+i;
        btn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [self.tmpRightArray addObject:[NSString stringWithFormat:@"%d",Right_button_tag+i]];
        [btn setTitle:[self.rightArray objectAtIndex:i] forState:UIControlStateNormal];
        [self.wordsContainerView addSubview:btn];
    }
    
    [self.wordsContainerView setFrame:CGRectMake(-768, 80, 768, frame.origin.y+frame.size.height+100)];
    [self.view addSubview:self.wordsContainerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(0, 80, 768, frame.origin.y+frame.size.height+100)];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
                NSArray *subViews = [self.wordsContainerView subviews];
                for (UIView *vv in subViews) {
                    if ([vv isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)vv;
                        CGRect frame = btn.frame;
                        frame.size.width = BUTTON_WIDTH;
                        frame.size.height = BUTTON_WIDTH;
                        btn.frame = frame;
                    }
                }
            } completion:^(BOOL finished){
                [self addLine];
            }];
        }
    }];

}
-(void)nextHistoryQuestion:(id)sender {
    if (self.branchNumber == self.history_branchQuestionArray.count-1) {
        self.number++;self.branchNumber = 0;
    }else {
        self.branchNumber++;
    }
    [self getQuestionData];
}
-(void)finishHistoryQuestion:(id)sender {
    
}

-(void)getQuestionData {
    self.branchScore = 0;
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    self.branchQuestionArray = [self.questionDic objectForKey:@"branch_questions"];
    self.branchQuestionDic = [self.branchQuestionArray objectAtIndex:self.branchNumber];
    self.leftArray = nil;self.rightArray = nil;
    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
    NSArray *array = [content componentsSeparatedByString:@";||;"];
    for (int i=0; i<array.count; i++) {
        NSString *str = [array objectAtIndex:i];
        NSArray *subArray = [str componentsSeparatedByString:@"<=>"];
        [self.leftArray addObject:[subArray objectAtIndex:0]];
        [self.rightArray addObject:[subArray objectAtIndex:1]];
    }
    
    if ([DataService sharedService].isHistory==YES) {
        self.history_questionDic = [self.history_questionArray objectAtIndex:self.number];
        self.history_branchQuestionArray = [self.history_questionDic objectForKey:@"branch_questions"];
        self.history_branchQuestionDic = [self.history_branchQuestionArray objectAtIndex:self.branchNumber];
        
        self.homeControl.rotioLabel.text = [NSString stringWithFormat:@"%d%%",[[self.history_branchQuestionDic objectForKey:@"ratio"] integerValue]];
        NSString *txt = [self.history_branchQuestionDic objectForKey:@"answer"];
        self.historyAnswer.text = [NSString stringWithFormat:@"你的排序: %@",txt];
        
        [self setHistoryUI];
    }else {
        [self setUI];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.historyView.hidden=YES;
    NSDictionary * dic = [Utility initWithJSONFile:[DataService sharedService].taskObj.taskStartDate];
    NSDictionary *sortDic = [dic objectForKey:@"lining"];
    self.questionArray = [NSMutableArray arrayWithArray:[sortDic objectForKey:@"questions"]];
    self.specified_time = [[sortDic objectForKey:@"specified_time"]intValue];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.homeControl = (HomeworkContainerController *)self.parentViewController;
    self.homeControl.appearCorrectButton.enabled=NO;
    self.homeControl.reduceTimeButton.enabled = NO;
    self.number=0;self.branchNumber=0;self.isFirst= NO;self.prop_number=-1;
    //TODO:初始化答案的字典
    self.answerDic = [Utility returnAnswerDictionaryWithName:LINING andDate:[DataService sharedService].taskObj.taskStartDate];
    int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
    
    if ([DataService sharedService].isHistory==YES) {
        if (number_question<0) {
            [Utility errorAlert:@"暂无历史记录!"];
        }else {
            self.historyView.hidden=NO;
            self.history_questionArray = [NSMutableArray arrayWithArray:[self.answerDic objectForKey:@"questions"]];
            self.homeControl.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:[[self.answerDic objectForKey:@"use_time"]integerValue]]];
            [self getQuestionData];
        }
    }else {
        self.propsArray = [Utility returnAnswerPropsandDate:[DataService sharedService].taskObj.taskStartDate];
        int status = [[self.answerDic objectForKey:@"status"]intValue];
        if (status == 1) {
            
        }else {
            //判断卡包
            if ([DataService sharedService].cardsCount >20) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"作业提示" message:@"卡包数量大于20，先去清理卡包?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag = 999;
                [alert show];
            }else {
                self.isFirst= YES;
                if ([DataService sharedService].number_reduceTime>0) {
                    self.homeControl.reduceTimeButton.enabled = YES;
                }
                if ([DataService sharedService].number_correctAnswer>0) {
                    self.homeControl.appearCorrectButton.enabled=YES;
                }
                
                
                int number_branch_question = [[self.answerDic objectForKey:@"branch_item"]intValue];
                
                if (number_question>=0) {
                    NSDictionary *dic = [self.questionArray objectAtIndex:number_question];
                    NSArray *array = [dic objectForKey:@"branch_questions"];
                    if (number_branch_question == array.count-1) {
                        self.number = +1;self.branchNumber = 0;
                    }else {
                        self.number = number_question;self.branchNumber = number_branch_question+1;
                    }
                    
                    int useTime = [[self.answerDic objectForKey:@"use_time"]integerValue];
                    self.homeControl.spendSecond = useTime;
                    NSString *timeStr = [Utility formateDateStringWithSecond:useTime];
                    self.homeControl.timerLabel.text = timeStr;
                }
            }
        }
        [self getQuestionData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//检查
-(void)checkAnswer:(id)sender {
    
    NSString *str = @"";
    NSMutableString *anserString = [NSMutableString string];
    
    if ((self.leftArray.count != self.tmpLeftArray.count) || (self.rightArray.count != self.tmpRightArray.count)) {
        str = @"请填写完整!";
    }
    if (str.length>0) {
        [Utility errorAlert:str];
    }else {
        [self.homeControl stopTimer];
        self.homeControl.appearCorrectButton.enabled=NO;
        for (UIView *vv in [self.wordsContainerView subviews]) {
            if ([vv isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)vv;
                btn.enabled = NO;
            }
        }
        
        NSString *content = [self.branchQuestionDic objectForKey:@"content"];
        for (int i=0; i<self.leftArray.count; i++) {
            int tag_left = [[self.tmpLeftArray objectAtIndex:i]integerValue];
            UIButton *leftBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag_left];
            int tag_right = [[self.tmpRightArray objectAtIndex:i]integerValue];
            UIButton *rightBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag_right];
            NSString *textString = [NSString stringWithFormat:@"%@ %@",leftBtn.titleLabel.text,rightBtn.titleLabel.text];
            [anserString appendFormat:@"%@    ",textString];

            NSString *text = [NSString stringWithFormat:@"%@<=>%@",leftBtn.titleLabel.text,rightBtn.titleLabel.text];
            NSRange range = [content rangeOfString:text];
            if (range.location == NSNotFound) {
                leftBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
                rightBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
                
            }else {
                self.branchScore++;
            }
        }
        
        if (self.branchScore == self.leftArray.count) {
            TRUESOUND;
        }else {
            FALSESOUND;
            if (self.isFirst==YES) {
                [DataService sharedService].cardsCount += 1;
            }
        }
        
        if (self.branchNumber==self.branchQuestionArray.count-1 && self.number==self.questionArray.count-1) {
            self.homeControl.reduceTimeButton.enabled=NO;
            [self.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
            [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.checkHomeworkButton addTarget:self action:@selector(finishQuestion:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [self.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
            [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.checkHomeworkButton addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
        }
        //TODO:写入json
        int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
        int number_branch_question = [[self.answerDic objectForKey:@"branch_item"]intValue];
        if (number_question>self.number) {
            //表示已经做过这道题
        }else if (number_question==self.number){
            if (number_branch_question>=self.branchNumber) {
                //表示已经做过这道题
            }else {
                [self writeToAnswerJsonWithString:anserString];
            }
        }else {
            [self writeToAnswerJsonWithString:anserString];
        }
    }
}
-(void)writeToAnswerJsonWithString:(NSString *)string {
    isCanUpLoad = YES;
    if (self.branchNumber==self.branchQuestionArray.count-1 && self.number==self.questionArray.count-1) {
        [self.answerDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"status"];
    }
    NSString *time = [Utility getNowDateFromatAnDate];
    [self.answerDic setObject:time forKey:@"update_time"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.number] forKey:@"questions_item"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.branchNumber] forKey:@"branch_item"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%lld",self.homeControl.spendSecond] forKey:@"use_time"];
    //一道题目------------------------------------------------------------------
    //正确率
    CGFloat ratio = (self.branchScore/((float)self.leftArray.count))*100;
    NSString *a_id = [NSString stringWithFormat:@"%@",[self.branchQuestionDic objectForKey:@"id"]];
    NSDictionary *answer_dic = [NSDictionary dictionaryWithObjectsAndKeys:a_id,@"id",[NSString stringWithFormat:@"%.2f",ratio],@"ratio",string,@"answer", nil];
    
    NSMutableArray *questions = [NSMutableArray arrayWithArray:[self.answerDic objectForKey:@"questions"]];
    if (questions.count>0) {
        BOOL isExit = NO;
        for (int i=0; i<questions.count; i++) {
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:[questions objectAtIndex:i]];
            if ([[mutableDic objectForKey:@"id"]intValue] == [[self.questionDic objectForKey:@"id"]intValue]) {
                isExit = YES;
                
                NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[mutableDic objectForKey:@"branch_questions"]];
                [mutableArray addObject:answer_dic];
                [mutableDic setObject:mutableArray forKey:@"branch_questions"];
                [questions replaceObjectAtIndex:i withObject:mutableDic];
                break;
            }
        }
        
        if (isExit==NO) {
            NSArray *branch_questions = [[NSArray alloc]initWithObjects:answer_dic, nil];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.questionDic objectForKey:@"id"],@"id",branch_questions,@"branch_questions", nil];
            [questions addObject:dictionary];
        }
    }else {
        NSArray *branch_questions = [[NSArray alloc]initWithObjects:answer_dic, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.questionDic objectForKey:@"id"],@"id",branch_questions,@"branch_questions", nil];
        [questions addObject:dictionary];
    }
    
    [self.answerDic setObject:questions forKey:@"questions"];
    
    [Utility returnAnswerPathWithDictionary:self.answerDic andName:LINING andDate:[DataService sharedService].taskObj.taskStartDate];
}


-(void)addLine {
    NSMutableArray *lines = [NSMutableArray array];
    
    for (int i=0; i<self.tmpLeftArray.count; i++) {
        LineObj *line = [[LineObj alloc] init];
        int tag_left = [[self.tmpLeftArray objectAtIndex:i]integerValue];
        UIButton *leftBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag_left];
        int tag_right = [[self.tmpRightArray objectAtIndex:i]integerValue];
        UIButton *rightBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag_right];
        line.startPoint = (CGPoint){CGRectGetMaxX(leftBtn.frame),CGRectGetMinY(leftBtn.frame)+CGRectGetWidth(leftBtn.frame)/2};
        line.endPoint = (CGPoint){CGRectGetMinX(rightBtn.frame),CGRectGetMinY(rightBtn.frame)+CGRectGetWidth(rightBtn.frame)/2};
        [lines addObject:line];
    }
    [self.wordsContainerView redrawLinesWithLineObjArray:lines];
    self.cancelTmpLeftArray=nil;self.cancelTmpRightArray=nil;
}
//TODO:选中-------------------------------------------------
-(void)leftButtonSelected:(id)sender {
    UIButton *btn= (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
    
    if (self.cancelTmpRightArray.count>0) {
        int tmpTag = [[self.cancelTmpRightArray firstObject]integerValue];
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        rightBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpRightArray removeAllObjects];
    }
    
    int tmpTag=0;
    if (self.cancelTmpLeftArray.count>0) {
        tmpTag = [[self.cancelTmpLeftArray firstObject]integerValue];
        UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        leftBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpLeftArray removeAllObjects];
    }
    
    //**********************************************************************************************
    //点击选中
    if (tmpTag == btn.tag) {
        
    }else {
        if (self.tmpLeftArray.count>self.tmpRightArray.count) {
            int tag = [[self.tmpLeftArray lastObject]integerValue];
            UIButton *lastBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag];
            lastBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            [self.tmpLeftArray removeLastObject];
            [lastBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [lastBtn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSString *str = [NSString stringWithFormat:@"%d",btn.tag];
        if (![self.tmpLeftArray containsObject:str]) {
            [self.tmpLeftArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];
        }
        
        
        [btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.tmpLeftArray.count == self.tmpRightArray.count) {
            [self addLine];
        }
    }
    DLog(@"left = %@",self.tmpLeftArray);
    DLog(@"cancelleft = %@",self.cancelTmpLeftArray);
    DLog(@"right = %@",self.tmpRightArray);
    DLog(@"cancelright = %@",self.cancelTmpRightArray);
}
-(void)rightButtonSelected:(id)sender {
    UIButton *btn= (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
    
    if (self.cancelTmpLeftArray.count>0) {
        int tmpTag = [[self.cancelTmpLeftArray firstObject]integerValue];
        UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        leftBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpLeftArray removeAllObjects];
    }
    
    int tmpTag=0;
    if (self.cancelTmpRightArray.count>0) {
        tmpTag = [[self.cancelTmpRightArray firstObject]integerValue];
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        rightBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpRightArray removeAllObjects];
    }
    
    //**********************************************************************************************
    //点击选中
    if (tmpTag == btn.tag) {
        
    }else {
        if (self.tmpLeftArray.count<self.tmpRightArray.count){
            int tag = [[self.tmpRightArray lastObject]integerValue];
            UIButton *lastBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag];
            lastBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            [self.tmpRightArray removeLastObject];
            [lastBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [lastBtn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSString *str = [NSString stringWithFormat:@"%d",btn.tag];
        if (![self.tmpRightArray containsObject:str]) {
            [self.tmpRightArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];
        }
       
        
        [btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.tmpLeftArray.count == self.tmpRightArray.count) {
            [self addLine];
        }
    }
    DLog(@"left = %@",self.tmpLeftArray);
    DLog(@"cancelleft = %@",self.cancelTmpLeftArray);
    DLog(@"right = %@",self.tmpRightArray);
    DLog(@"cancelright = %@",self.cancelTmpRightArray);
}
//TODO:取消选中-------------------------------------------------
-(void)leftButtonCancelSelected:(id)sender {
    UIButton *btn= (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];

    NSString *tagString_left = [NSString stringWithFormat:@"%d",btn.tag];
    int index_left = [self.tmpLeftArray indexOfObject:tagString_left];
    
    if (self.cancelTmpLeftArray.count>0) {
        int tmpTag = [[self.cancelTmpLeftArray firstObject]integerValue];
        UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        leftBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpLeftArray removeAllObjects];
    }

    if (self.tmpLeftArray.count>self.tmpRightArray.count) {
        int tag = [[self.tmpLeftArray lastObject]integerValue];
        UIButton *lastBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag];
        lastBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
        [self.tmpLeftArray removeLastObject];
        [lastBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [lastBtn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.tmpLeftArray.count<self.tmpRightArray.count){
        int tag = [[self.tmpRightArray lastObject]integerValue];
        UIButton *lastBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag];
        lastBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
        [self.tmpRightArray removeLastObject];
        [lastBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [lastBtn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }

    BOOL isExit = NO;
    if ([self.tmpLeftArray containsObject:tagString_left]) {
        isExit = YES;
    }
    
    if (self.tmpLeftArray.count>0 && self.tmpLeftArray.count==self.tmpRightArray.count && isExit==YES) {
        [self.cancelTmpLeftArray addObject:tagString_left];
    }
    
    if (self.cancelTmpLeftArray.count == self.cancelTmpRightArray.count && self.cancelTmpLeftArray.count>0) {
        NSString *tagString_right = [self.cancelTmpRightArray firstObject];
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_right intValue]];
        int index_right = [self.tmpRightArray indexOfObject:tagString_right];
        if (index_left == index_right) {
            UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_left intValue]];
            [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [leftBtn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [rightBtn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.tmpLeftArray removeObjectAtIndex:index_left];
            [self.tmpRightArray removeObjectAtIndex:index_right];
            
            [self addLine];
        }else {
            rightBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
            [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.cancelTmpRightArray removeAllObjects];
        }
    }else {
        [btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    DLog(@"left = %@",self.tmpLeftArray);
    DLog(@"cancelleft = %@",self.cancelTmpLeftArray);
    DLog(@"right = %@",self.tmpRightArray);
    DLog(@"cancelright = %@",self.cancelTmpRightArray);
}
-(void)rightButtonCancelSelected:(id)sender {
    UIButton *btn= (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    
    NSString *tagString_right = [NSString stringWithFormat:@"%d",btn.tag];
    int index_right = [self.tmpRightArray indexOfObject:tagString_right];
    
    if (self.cancelTmpRightArray.count>0) {
        int tmpTag = [[self.cancelTmpRightArray firstObject]integerValue];
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        rightBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpRightArray removeAllObjects];
    }
    
    
    if (self.tmpLeftArray.count<self.tmpRightArray.count){
        int tag = [[self.tmpRightArray lastObject]integerValue];
        UIButton *lastBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag];
        lastBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
        [self.tmpRightArray removeLastObject];
        [lastBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [lastBtn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.tmpLeftArray.count>self.tmpRightArray.count) {
        int tag = [[self.tmpLeftArray lastObject]integerValue];
        UIButton *lastBtn = (UIButton *)[self.wordsContainerView viewWithTag:tag];
        lastBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
        [self.tmpLeftArray removeLastObject];
        [lastBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [lastBtn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    BOOL isExit = NO;
    if ([self.tmpRightArray containsObject:tagString_right]) {
        isExit = YES;
    }
    if (self.tmpRightArray.count>0 && self.tmpLeftArray.count==self.tmpRightArray.count && isExit==YES) {
        [self.cancelTmpRightArray addObject:tagString_right];
    }
    
    if (self.cancelTmpLeftArray.count == self.cancelTmpRightArray.count && self.cancelTmpRightArray.count>0) {
        NSString *tagString_left = [self.cancelTmpLeftArray firstObject];
        UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_left intValue]];
        int index_left = [self.tmpLeftArray indexOfObject:tagString_left];
        if (index_left == index_right) {
            UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_right intValue]];
            [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [rightBtn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [leftBtn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.tmpLeftArray removeObjectAtIndex:index_left];
            [self.tmpRightArray removeObjectAtIndex:index_right];
            
            [self addLine];
        }else {
            
            leftBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
            [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.cancelTmpLeftArray removeAllObjects];
        }
    }else {
        [btn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    DLog(@"left = %@",self.tmpLeftArray);
    DLog(@"cancelleft = %@",self.cancelTmpLeftArray);
    DLog(@"right = %@",self.tmpRightArray);
    DLog(@"cancelright = %@",self.cancelTmpRightArray);
}

-(void)nextQuestion:(id)sender {
    [self.homeControl startTimer];
    self.prop_number=-1;
    if ([DataService sharedService].number_correctAnswer>0) {
        self.homeControl.appearCorrectButton.enabled=YES;
    }
    if (self.branchNumber == self.branchQuestionArray.count-1) {
        self.number++;self.branchNumber = 0;
    }else {
        self.branchNumber++;
    }
    
    [self getQuestionData];
}
//结果
-(void)showResultView {
    NSString *path = [Utility returnPath];
    NSString *documentDirectory = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"answer_%@.json",[DataService sharedService].user.userId]];
    
    NSError *error = nil;
    Class JSONSerialization = [Utility JSONParserClass];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
    
    NSMutableDictionary *answerDic = [dataObject objectForKey:LINING];
    NSArray *questionArray = [answerDic objectForKey:@"questions"];
    
    CGFloat score_radio=0;int count =0;
    for (int i=0; i<questionArray.count; i++) {
        NSDictionary *question_dic = [questionArray objectAtIndex:i];
        NSArray *branchArray = [question_dic objectForKey:@"branch_questions"];
        
        for (int j=0; j<branchArray.count; j++) {
            count++;
            NSDictionary *branch_dic = [branchArray objectAtIndex:j];
            CGFloat radio = [[branch_dic objectForKey:@"ratio"]floatValue];
            score_radio += radio;
        }
    }
    score_radio = score_radio/count;
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"TenSecChallengeResultView" owner:self options:nil];
    self.resultView = (TenSecChallengeResultView *)[viewArray objectAtIndex:0];
    self.resultView.delegate = self;
    self.resultView.timeCount = self.homeControl.spendSecond;
    self.resultView.ratio = (NSInteger)score_radio;
    if (self.isFirst == YES) {
        self.resultView.resultBgView.hidden=NO;
        self.resultView.noneArchiveView.hidden=YES;
        
        self.resultView.timeLimit = self.specified_time;
        self.resultView.isEarly = [Utility compareTime];
    }else {
        self.resultView.noneArchiveView.hidden=NO;
        self.resultView.resultBgView.hidden=YES;
    }
    
    [self.resultView initView];
    
    [self.view addSubview: self.resultView];
}
-(void)finishQuestion:(id)sender {
    self.homeControl.appearCorrectButton.enabled=NO;
    self.homeControl.reduceTimeButton.enabled=NO;
    self.checkHomeworkButton.enabled=NO;
    if (self.isFirst==YES) {
        self.postNumber = 0;
        if (self.appDel.isReachable == NO) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
            self.postInter = [[BasePostInterface alloc]init];
            self.postInter.delegate = self;
            [self.postInter postAnswerFileWith:[DataService sharedService].taskObj.taskStartDate];
        }
        
    }else {
        [self showResultView];
    }
}
#pragma mark
#pragma mark - 道具
//道具  显示正确答案
-(void)showLiningCorrectAnswer {
    self.prop_number += 1;
    [DataService sharedService].number_correctAnswer -= 1;
    if ((self.prop_number == 1) || ([DataService sharedService].number_correctAnswer==0)) {
        self.homeControl.appearCorrectButton.enabled = NO;
    }
    //道具写入JSON
    NSMutableDictionary *branch_propDic = [NSMutableDictionary dictionaryWithDictionary:[self.propsArray objectAtIndex:0]];
    NSMutableArray *branch_propArray = [NSMutableArray arrayWithArray:[branch_propDic objectForKey:@"branch_id"]];
    [branch_propArray addObject:[NSNumber numberWithInt:[[self.branchQuestionDic objectForKey:@"id"] intValue]]];
    [branch_propDic setObject:branch_propArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:0 withObject:branch_propDic];
    [Utility returnAnswerPathWithProps:self.propsArray andDate:[DataService sharedService].taskObj.taskStartDate];
    
    if (self.cancelTmpLeftArray.count>0) {
        int tmpTag = [[self.cancelTmpLeftArray firstObject]integerValue];
        UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        leftBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpLeftArray removeAllObjects];
    }
    if (self.cancelTmpRightArray.count>0) {
        int tmpTag = [[self.cancelTmpRightArray firstObject]integerValue];
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:tmpTag];
        rightBtn.backgroundColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelTmpRightArray removeAllObjects];
    }
    
    //显示正确答案
    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
    UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:(self.prop_number+Left_button_tag)];
    NSString *tagString_left = [NSString stringWithFormat:@"%d",self.prop_number+Left_button_tag];
    NSString *tagString_right;
    
    for (int i=0; i<self.rightArray.count; i++) {
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:(i+Right_button_tag)];
        NSString *text = [NSString stringWithFormat:@"%@<=>%@",leftBtn.titleLabel.text,rightBtn.titleLabel.text];
        NSRange range = [content rangeOfString:text];
        if (range.location!=NSNotFound && range.length!=NSNotFound) {
            tagString_right = [NSString stringWithFormat:@"%d",i+Right_button_tag];
            break;
        }
    }
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    NSMutableArray *array2 = [[NSMutableArray alloc]init];
    
    int count = self.tmpLeftArray.count<=self.tmpRightArray.count?self.tmpLeftArray.count:self.tmpRightArray.count;
    if (count==0) {
        [array1 addObject:tagString_left];[array2 addObject:tagString_right];
        UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_right integerValue]];
        rightBtn.backgroundColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
        [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_left integerValue]];
        leftBtn.backgroundColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
        [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        if ((![self.tmpLeftArray containsObject:tagString_left]) && (![self.tmpRightArray containsObject:tagString_right])) {
            [array1 addObject:tagString_left];[array2 addObject:tagString_right];
            UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_right integerValue]];
            rightBtn.backgroundColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
            [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_left integerValue]];
            leftBtn.backgroundColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
            [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [leftBtn addTarget:self action:@selector(leftButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        for (int i=0; i<count; i++) {
            NSString *str1 = [NSString stringWithFormat:@"%@",[self.tmpLeftArray objectAtIndex:i]];
            NSString *str2 = [NSString stringWithFormat:@"%@",[self.tmpRightArray objectAtIndex:i]];
            
            if ([str1 isEqualToString:tagString_left]) {
                [array1 addObject:str1];[array2 addObject:tagString_right];
                if (![self.tmpRightArray containsObject:tagString_right]) {
                    UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:[tagString_right integerValue]];
                    rightBtn.backgroundColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
                    [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                    [rightBtn addTarget:self action:@selector(rightButtonCancelSelected:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else {
                if (![str2 isEqualToString:tagString_right]) {
                    [array1 addObject:str1];[array2 addObject:str2];
                }
            }
        }
        
        if (self.tmpLeftArray.count>count) {
            [array1 addObject:[self.tmpLeftArray objectAtIndex:count]];
        }
        if (self.tmpRightArray.count>count) {
            [array2 addObject:[self.tmpRightArray objectAtIndex:count]];
        }
    }
    
    NSPredicate *thePredicate1 = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", array1];
    [self.tmpLeftArray filterUsingPredicate:thePredicate1];
    if (self.tmpLeftArray.count>0) {
        for (int i=0; i<self.tmpLeftArray.count; i++) {
            UIButton *leftBtn= (UIButton *)[self.wordsContainerView viewWithTag:[[self.tmpLeftArray objectAtIndex:i] integerValue]];
            leftBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            [leftBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [leftBtn addTarget:self action:@selector(leftButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    NSPredicate *thePredicate2 = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", array2];
    [self.tmpRightArray filterUsingPredicate:thePredicate2];
    if (self.tmpRightArray.count>0) {
        for (int i=0; i<self.tmpRightArray.count; i++) {
            UIButton *rightBtn= (UIButton *)[self.wordsContainerView viewWithTag:[[self.tmpRightArray objectAtIndex:i] integerValue]];
            rightBtn.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            [rightBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [rightBtn addTarget:self action:@selector(rightButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    self.tmpLeftArray = array1;
    self.tmpRightArray = array2;
    
    [self addLine];
}
//道具  减少时间
-(void)liningViewReduceTimeButtonClicked {
    [DataService sharedService].number_reduceTime -= 1;
    if ([DataService sharedService].number_reduceTime==0) {
        self.homeControl.reduceTimeButton.enabled = NO;
    }
    if (self.homeControl.spendSecond > 5) {
        self.homeControl.spendSecond = self.homeControl.spendSecond -5;
    }else{
        self.homeControl.spendSecond = 0;
    }
    self.homeControl.timerLabel.text = [Utility formateDateStringWithSecond:(NSInteger)self.homeControl.spendSecond];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){self.view.frame.size.width/2,120,70,50}];
    [label setFont:[UIFont systemFontOfSize:50]];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor orangeColor];
    label.text = @"-5";
    [self.homeControl.view addSubview:label];
    [self.homeControl.view setUserInteractionEnabled:NO];
    label.alpha = 1;
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [self.homeControl.view setUserInteractionEnabled:YES];
    }];
    
    NSMutableDictionary *branch_propDic = [NSMutableDictionary dictionaryWithDictionary:[self.propsArray objectAtIndex:1]];
    NSMutableArray *branch_propArray = [NSMutableArray arrayWithArray:[branch_propDic objectForKey:@"branch_id"]];
    [branch_propArray addObject:[NSNumber numberWithInt:[[self.branchQuestionDic objectForKey:@"id"] intValue]]];
    [branch_propDic setObject:branch_propArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:1 withObject:branch_propDic];
    [Utility returnAnswerPathWithProps:self.propsArray andDate:[DataService sharedService].taskObj.taskStartDate];
}


#pragma mark
#pragma mark - TenSecChallengeResultViewDelegate
-(void)resultViewCommitButtonClicked {//确认完成
    [self.resultView removeFromSuperview];
}
-(void)resultViewRestartButtonClicked {//再次挑战
    [self.resultView removeFromSuperview];
    
    self.checkHomeworkButton.enabled=YES;
    self.number=0;self.branchNumber=0;self.isFirst = NO;
    
    self.homeControl.reduceTimeButton.enabled=NO;
    self.homeControl.appearCorrectButton.enabled=NO;
    [self getQuestionData];
}

#pragma mark
#pragma mark - PostDelegate
-(void)getPostInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
            //上传answer.json文件之后返回的更新时间
            NSString *timeStr = [result objectForKey:@"updated_time"];
            [Utility returnAnswerPAthWithString:timeStr];
            
            if (self.postNumber==0) {
                [self showResultView];
            }else {
                [self.homeControl dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        });
    });
}
-(void)getPostInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
    [Utility errorAlert:errorMsg];
}


-(void)exitLiningView {
    if (self.branchNumber==self.branchQuestionArray.count-1 && self.number==self.questionArray.count-1) {
        [self.homeControl dismissViewControllerAnimated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"作业提示" message:@"确定退出做题?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 100;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    if (alertView.tag == 100) {
        if (buttonIndex==0) {
            if (self.isFirst==YES && isCanUpLoad==YES) {
                self.postNumber = 1;
                if (self.appDel.isReachable == NO) {
                    [Utility errorAlert:@"暂无网络!"];
                }else {
                    [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
                    self.postInter = [[BasePostInterface alloc]init];
                    self.postInter.delegate = self;
                    [self.postInter postAnswerFileWith:[DataService sharedService].taskObj.taskStartDate];
                }
            }else {
                [self.homeControl dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }else {
        [self.homeControl dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
