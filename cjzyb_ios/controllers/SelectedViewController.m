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

static BOOL isCanUpLoad = NO;

@interface SelectedViewController ()
@property (nonatomic, strong) TenSecChallengeResultView *resultView;
@property (nonatomic, strong) WYPopoverController *poprController;
@property (nonatomic, assign) int prop_number;
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
-(void)UIset {
    self.clozeVV = [[ClozeView alloc]initWithFrame:CGRectMake(-768, 20, 768, 400)];
    self.clozeVV.delegate = self;
    
    [self.clozeVV setText:[self.questionDic objectForKey:@"full_text"]];
    self.clozeVV.backgroundColor = [UIColor clearColor];
    [self.myScroll addSubview:self.clozeVV];
    
    CGRect frame = self.clozeVV.frame;
    self.myScroll.contentSize = CGSizeMake(768,self.clozeVV.frame.size.height+10);
    [self.myScroll setScrollEnabled:YES];
    
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.clozeVV.frame = frame;
    } completion:^(BOOL finished){
        [MBProgressHUD hideHUDForView:self.myScroll animated:YES];
    }];
}
-(void)setUI {
    [self.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
    [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.checkHomeworkButton addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.clozeVV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.clozeVV removeFromSuperview];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.myScroll];
    hud.dimBackground = NO;
    [hud showWhileExecuting:@selector(UIset) onTarget:self withObject:nil animated:YES];
    [self.myScroll addSubview:hud];
}
-(void)HistoryUIset {
    self.clozeVV = [[ClozeView alloc]initWithFrame:CGRectMake(-768, 20, 768, 400)];
    [self.clozeVV setText:[self.questionDic objectForKey:@"full_text"]];
    self.clozeVV.backgroundColor = [UIColor clearColor];
    
    for (int i=0; i<self.answerArray.count; i++) {
        UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:i+UnderLab_tag];
        NSDictionary *dic = [self.answerArray objectAtIndex:i];
        NSString *answer = [dic objectForKey:@"answer"];
        [label setText:answer];
    }
    
    [self.myScroll addSubview:self.clozeVV];
    
    self.myScroll.contentSize = CGSizeMake(768,self.clozeVV.frame.size.height+10);
    [self.myScroll setScrollEnabled:YES];
    
    
    CGRect frame = self.clozeVV.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.clozeVV.frame = frame;
    } completion:^(BOOL finished){
        [MBProgressHUD hideHUDForView:self.myScroll animated:YES];
    }];
}
-(void)setHistoryUI {

    if (self.number==self.history_questionArray.count-1) {
        [self.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.checkHomeworkButton addTarget:self action:@selector(finishHistoryQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [self.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
        [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.checkHomeworkButton addTarget:self action:@selector(nextHistoryQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.clozeVV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.clozeVV removeFromSuperview];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.myScroll];
    hud.dimBackground = NO;
    [hud showWhileExecuting:@selector(HistoryUIset) onTarget:self withObject:nil animated:YES];
    [self.myScroll addSubview:hud];
}
-(void)nextHistoryQuestion:(id)sender {
    self.number++;
    [self getQuestionData];
}
-(void)finishHistoryQuestion:(id)sender {
    [self.homeControl dismissViewControllerAnimated:YES completion:nil];
}

-(void)getQuestionData {
    self.branchScore = 0;
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    self.answerArray = [NSMutableArray arrayWithArray:[self.questionDic objectForKey:@"branch_questions"]];

    if ([DataService sharedService].isHistory==YES) {
        self.history_questionDic = [self.history_questionArray objectAtIndex:self.number];
        NSArray *history_branchQuestionArray = [self.history_questionDic objectForKey:@"branch_questions"];
        int rotio = 0;
        NSMutableString *answerStr = [NSMutableString string];
        for (int i=0; i<history_branchQuestionArray.count; i++) {
            NSDictionary *history_branchQuestionDic = [history_branchQuestionArray objectAtIndex:i];
            rotio += [[history_branchQuestionDic objectForKey:@"ratio"]integerValue];
            [answerStr appendFormat:@"%d.%@  ",(i+1),[history_branchQuestionDic objectForKey:@"answer"]];
        }
        
        self.historyAnswer.text = [NSString stringWithFormat:@"你的选择: %@",answerStr];
        
        [self setHistoryUI];
    }else {
        [self setUI];
    }
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
    
    self.poprController.popoverContentSize = (CGSize){350,175};
    [self.poprController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        barItemm=nil;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.historyView.hidden=YES;
    self.again_radio=0;
    //选择答案之后更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAnswerByClozeView:) name:@"reloadAnswerByClozeView" object:nil];
    
    NSDictionary * dic = [Utility initWithJSONFile:[DataService sharedService].taskObj.taskStartDate];
    self.clozeDic = [dic objectForKey:@"cloze"];
    self.questionArray = [NSMutableArray arrayWithArray:[self.clozeDic objectForKey:@"questions"]];
    self.specified_time = [[self.clozeDic objectForKey:@"specified_time"]intValue];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myScroll setContentOffset:CGPointMake(0, 0)];
    self.homeControl = (HomeworkContainerController *)self.parentViewController;
    self.homeControl.appearCorrectButton.enabled=NO;
    self.homeControl.reduceTimeButton.enabled = NO;
    self.number=0;self.isFirst= NO;
    self.prop_number=-1;
    //TODO:初始化答案的字典
    self.answerDic = [Utility returnAnswerDictionaryWithName:CLOZE andDate:[DataService sharedService].taskObj.taskStartDate];
    
    int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
    
    if ([DataService sharedService].taskObj.isExpire == YES) {//作业过期时间
        
        NSMutableArray *h_questions = [[NSMutableArray alloc]init];
        for (int i=0; i<self.questionArray.count; i++) {
            NSMutableDictionary *question = [[NSMutableDictionary alloc]init];
            NSDictionary *dic = [self.questionArray objectAtIndex:i];
            NSArray *b_array = [dic objectForKey:@"branch_questions"];
            NSMutableArray *h_b_question = [[NSMutableArray alloc]init];
            for (int k=0; k<b_array.count; k++) {
                NSDictionary *b_dic = [b_array objectAtIndex:k];
                NSDictionary *answer_dic = [NSDictionary dictionaryWithObjectsAndKeys:[b_dic objectForKey:@"id"],@"id",@"0",@"ratio",@"您未作答",@"answer", nil];
                [h_b_question addObject:answer_dic];
            }
            [question setObject:[dic objectForKey:@"id"] forKey:@"id"];
            [question setObject:h_b_question forKey:@"branch_questions"];
            [h_questions addObject:question];
        }
        if (number_question<0) {//没有过往记录
            [self.answerDic setObject:h_questions forKey:@"questions"];
        }else {
            NSMutableArray *a_question =[NSMutableArray arrayWithArray:[self.answerDic objectForKey:@"questions"]];
            for (int i=0; i<h_questions.count; i++) {
                NSDictionary *dic = [h_questions objectAtIndex:i];
                NSArray *b_array = [dic objectForKey:@"branch_questions"];
                
                if (i<=a_question.count-1) {
                    NSMutableDictionary *a_dic = [NSMutableDictionary dictionaryWithDictionary:[a_question objectAtIndex:i]];
                    NSMutableArray *a_array = [NSMutableArray arrayWithArray:[a_dic objectForKey:@"branch_questions"]];
                    
                    for (int k=0; k<b_array.count; k++) {
                        NSDictionary *b_dic = [b_array objectAtIndex:k];
                        if (k<=a_array.count-1) {
                            
                        }else {
                            [a_array addObject:b_dic];
                        }
                    }
                    [a_dic setObject:a_array forKey:@"branch_questions"];
                    [a_question replaceObjectAtIndex:i withObject:a_dic];
                }else {
                    [a_question addObject:dic];
                }
            }
            [self.answerDic setObject:a_question forKey:@"questions"];
        }
    }
    
    if ([DataService sharedService].isHistory==YES) {
        if (number_question<0 && [DataService sharedService].taskObj.isExpire == NO) {
            [Utility errorAlert:@"暂无历史记录!"];
        }else {
            self.historyView.hidden=NO;
            self.history_questionArray = [NSMutableArray arrayWithArray:[self.answerDic objectForKey:@"questions"]];
            self.homeControl.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:[[self.answerDic objectForKey:@"use_time"]integerValue]]];
            
            CGFloat score_radio=0;int count =0;
            for (int i=0; i<self.history_questionArray.count; i++) {
                NSDictionary *question_dic = [self.history_questionArray objectAtIndex:i];
                NSArray *branchArray = [question_dic objectForKey:@"branch_questions"];
                
                for (int j=0; j<branchArray.count; j++) {
                    count++;
                    NSDictionary *branch_dic = [branchArray objectAtIndex:j];
                    CGFloat radio = [[branch_dic objectForKey:@"ratio"]floatValue];
                    score_radio += radio;
                }
            }
            score_radio = score_radio/count;
            self.homeControl.rotioLabel.text = [NSString stringWithFormat:@"%d%%", (int)score_radio];
            
            [self getQuestionData];
        }
    }else {
        self.propsArray = [Utility returnAnswerPropsandDate:[DataService sharedService].taskObj.taskStartDate];
        int status = [[self.answerDic objectForKey:@"status"]intValue];
        if (status == 1) {
            
        }else if ([DataService sharedService].taskObj.isExpire == NO){
           
                self.isFirst= YES;
                if ([DataService sharedService].number_reduceTime>0) {
                    self.homeControl.reduceTimeButton.enabled = YES;
                }
                if ([DataService sharedService].number_correctAnswer>0) {
                    self.homeControl.appearCorrectButton.enabled=YES;
                }
                
                self.number = number_question+1;
                int useTime = [[self.answerDic objectForKey:@"use_time"]integerValue];
                self.homeControl.spendSecond = useTime;
                NSString *timeStr = [Utility formateDateStringWithSecond:useTime];
                self.homeControl.timerLabel.text = timeStr;
            }
        
        [self getQuestionData];
    }
    
}

- (void)reloadAnswerByClozeView:(NSNotification *)notification {
    NSString *answerStr = [notification object];
    UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:self.tmpTag+UnderLab_tag];
    
    int font_size = 20;
    for (int i=33; i>=20; i--) {
        CGSize sizeSub = [answerStr sizeWithFont:[UIFont systemFontOfSize:i]];
        if (sizeSub.width-150<=0) {
            font_size = i;
            break;
        }
    }
    label.font = [UIFont systemFontOfSize:font_size];
    [label setText:answerStr];
    [self.poprController dismissPopoverAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkAnswer:(id)sender {
    self.homeControl.appearCorrectButton.enabled=NO;
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
        [self.homeControl stopTimer];
        for (int i=0; i<self.answerArray.count; i++) {
            UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:i+UnderLab_tag];
            
            NSDictionary *dic = [self.answerArray objectAtIndex:i];
            NSString *answer = [dic objectForKey:@"answer"];
            if ([label.text isEqualToString:answer]) {
                label.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
                self.branchScore++;
            }else {
                label.textColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
                if (self.isFirst==YES) {
                [DataService sharedService].cardsCount += 1;
                }
            }
            self.clozeVV.delegate = nil;
        }
        if (self.number == self.questionArray.count-1) {
            self.homeControl.reduceTimeButton.enabled=NO;
            [self.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
            [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.checkHomeworkButton addTarget:self action:@selector(finishQuestion:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [self.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
            [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.checkHomeworkButton addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (self.branchScore == self.answerArray.count) {
            TRUESOUND;
        }else {
            FALSESOUND;
        }
        self.again_radio +=  (self.branchScore/((float)self.answerArray.count))*100;
        //TODO:写入json
        if (self.isFirst==YES) {
            int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
            if (number_question >= self.number) {
                //表示已经做过这道题
            }else {
                if (self.number == self.questionArray.count-1) {
                    [self.answerDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"status"];
                    NSString *str = [Utility returnTypeOfQuestionWithString:CLOZE];
                    [[DataService sharedService].taskObj.finish_types addObject:str];
                }
                NSString *time = [Utility getNowDateFromatAnDate];
                [self.answerDic setObject:time forKey:@"update_time"];
                [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.number] forKey:@"questions_item"];
                [self.answerDic setObject:[NSString stringWithFormat:@"%lld",self.homeControl.spendSecond] forKey:@"use_time"];
                
                //一道题目------------------------------------------------------------------
                //正确率
                CGFloat ratio = 0;
                NSMutableArray *branch_questions = [[NSMutableArray alloc]init];
                for (int i=0; i<self.answerArray.count; i++) {
                    UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:i+UnderLab_tag];
                    
                    NSDictionary *a_dic = [self.answerArray objectAtIndex:i];
                    NSString *answer = [a_dic objectForKey:@"answer"];
                    if ([label.text isEqualToString:answer]) {
                        label.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
                        ratio=100;
                    }else {
                        ratio=0;
                        label.textColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
                    }
                    
                    NSString *a_id = [NSString stringWithFormat:@"%@",[a_dic objectForKey:@"id"]];
                    NSDictionary *answer_dic = [NSDictionary dictionaryWithObjectsAndKeys:a_id,@"id",[NSString stringWithFormat:@"%.2f",ratio],@"ratio",label.text,@"answer", nil];
                    [branch_questions addObject:answer_dic];
                }
                
                NSMutableArray *questions = [NSMutableArray arrayWithArray:[self.answerDic objectForKey:@"questions"]];
                
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.questionDic objectForKey:@"id"],@"id",branch_questions,@"branch_questions", nil];
                [questions addObject:dictionary];
                [self.answerDic setObject:questions forKey:@"questions"];
                
                [Utility returnAnswerPathWithDictionary:self.answerDic andName:CLOZE andDate:[DataService sharedService].taskObj.taskStartDate];
                isCanUpLoad = YES;
            }
        }
    }
}

-(void)nextQuestion:(id)sender {
    [self.homeControl startTimer];self.prop_number=-1;
    if ([DataService sharedService].number_correctAnswer>0) {
        self.homeControl.appearCorrectButton.enabled=YES;
    }
    self.number ++;
    [self getQuestionData];
}
//结果
-(void)showResultView {
    for (HomeworkTypeObj *type in [DataService sharedService].taskObj.taskHomeworkTypeArray) {
        if (type.homeworkType == self.homeControl.homeworkType) {
            type.homeworkTypeIsFinished = YES;
        }
    }
    
    
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"TenSecChallengeResultView" owner:self options:nil];
    self.resultView = (TenSecChallengeResultView *)[viewArray objectAtIndex:0];
    self.resultView.delegate = self;
    self.resultView.timeCount = self.homeControl.spendSecond;
    
    if (self.isFirst == YES) {
        NSString *path = [Utility returnPath];
        NSString *documentDirectory = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate];
        NSString *jsPath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"answer_%@.json",[DataService sharedService].user.userId]];
        
        NSError *error = nil;
        Class JSONSerialization = [Utility JSONParserClass];
        NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
        
        NSMutableDictionary *answerDic = [dataObject objectForKey:CLOZE];
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
        
        self.resultView.resultBgView.hidden=NO;
        self.resultView.noneArchiveView.hidden=YES;
        self.resultView.ratio = (NSInteger)score_radio;
        self.resultView.timeLimit = self.specified_time;
        self.resultView.isEarly = [Utility compareTime];
    }else {
        self.resultView.noneArchiveView.hidden=NO;
        self.resultView.resultBgView.hidden=YES;
        self.resultView.ratio = (NSInteger)(self.again_radio/self.questionArray.count);
    }
    
    [self.resultView initView];
    
    [self.myScroll addSubview: self.resultView];
}

-(void)finishQuestion:(id)sender {
    self.homeControl.appearCorrectButton.enabled=NO;
    self.homeControl.reduceTimeButton.enabled=NO;
    

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
#pragma mark - PostDelegate
-(void)getPostInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
            //上传answer.json文件之后返回的更新时间
            NSString *timeStr = [result objectForKey:@"updated_time"];
            [Utility returnAnswerPAthWithString:timeStr];
            self.checkHomeworkButton.enabled=NO;
            isCanUpLoad=NO;
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
    [Utility uploadFaild];
    [self.homeControl dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark - TenSecChallengeResultViewDelegate
-(void)resultViewCommitButtonClicked {//确认完成
    [self.resultView removeFromSuperview];
    [self.homeControl dismissViewControllerAnimated:YES completion:nil];
}
-(void)resultViewRestartButtonClicked {//再次挑战
    [self.resultView removeFromSuperview];
    self.checkHomeworkButton.enabled=YES;
    self.homeControl.reduceTimeButton.enabled=NO;
    self.homeControl.appearCorrectButton.enabled=NO;
    self.number=0;self.isFirst = NO;
    self.homeControl.spendSecond = 0;
    [self.homeControl startTimer];
    [self getQuestionData];
}

#pragma mark
#pragma mark - 道具
-(void)showClozeCorrectAnswer {
    self.prop_number += 1;[DataService sharedService].number_correctAnswer -= 1;
    if ([DataService sharedService].number_correctAnswer==0) {
        self.homeControl.appearCorrectButton.enabled = NO;
    }
    
    NSArray *branch_questions = [self.questionDic objectForKey:@"branch_questions"];
    if ((self.prop_number == (branch_questions.count-1)) || ([DataService sharedService].number_correctAnswer==0)) {
        self.homeControl.appearCorrectButton.enabled = NO;
    }
    //道具写入JSON
    NSMutableDictionary *branch_propDic = [NSMutableDictionary dictionaryWithDictionary:[self.propsArray objectAtIndex:0]];
    NSMutableArray *branch_propArray = [NSMutableArray arrayWithArray:[branch_propDic objectForKey:@"branch_id"]];
    NSDictionary *branch_dic = [branch_questions objectAtIndex:self.prop_number];
    [branch_propArray addObject:[NSNumber numberWithInt:[[branch_dic objectForKey:@"id"] intValue]]];
    [branch_propDic setObject:branch_propArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:0 withObject:branch_propDic];
    [Utility returnAnswerPathWithProps:self.propsArray andDate:[DataService sharedService].taskObj.taskStartDate];
    
    //显示正确答案
    UnderLineLabel *label = (UnderLineLabel *)[self.clozeVV viewWithTag:self.prop_number+UnderLab_tag];
    NSDictionary *dic = [self.answerArray objectAtIndex:self.prop_number];
    NSString *answer = [dic objectForKey:@"answer"];
    label.text = answer;
    label.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
}
- (void)clozeViewReduceTimeButtonClicked {
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
    NSArray *branch_questions = [self.questionDic objectForKey:@"branch_questions"];
    NSDictionary *branch_dic = [branch_questions objectAtIndex:0];
    [branch_propArray addObject:[NSNumber numberWithInt:[[branch_dic objectForKey:@"id"] intValue]]];
    [branch_propDic setObject:branch_propArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:1 withObject:branch_propDic];
    [Utility returnAnswerPathWithProps:self.propsArray andDate:[DataService sharedService].taskObj.taskStartDate];
}

-(void)exitClozeView {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"作业提示" message:@"确定退出做题?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 100;
    [alert show];
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
    }
}
@end
