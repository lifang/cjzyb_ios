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
@property (nonatomic, strong) TenSecChallengeResultView *resultView;
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
- (void) roundView: (UIView *) view{
    [view.layer setCornerRadius: (view.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
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
    [self.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
    [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.checkHomeworkButton addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(108, 53, 640, frame.origin.y+Textfield_Height+Textfield_Space_Height)];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
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
    self.branchScore = 0;
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    self.branchQuestionArray = [self.questionDic objectForKey:@"branch_questions"];
    self.branchQuestionDic = [self.branchQuestionArray objectAtIndex:self.branchNumber];
    
    [self setUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self roundView:self.listenBtn];
    
    NSDictionary * dic = [Utility initWithJSONFile:@"question"];
    NSDictionary *listebDic = [dic objectForKey:@"listening"];
    self.questionArray = [NSMutableArray arrayWithArray:[listebDic objectForKey:@"questions"]];
    self.specified_time = [[listebDic objectForKey:@"specified_time"]intValue];

    [Utility shared].isOrg = YES;
}
-(void)listenMusicViewUI {
    self.homeControl.djView.hidden = YES;
    [self.homeControl stopTimer];
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    self.branchQuestionArray = [self.questionDic objectForKey:@"branch_questions"];
    
    [self.checkHomeworkButton setTitle:@"继续" forState:UIControlStateNormal];
    [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.checkHomeworkButton addTarget:self action:@selector(goOn:) forControlEvents:UIControlEventTouchUpInside];
    self.listenMusicView.frame = CGRectMake(0, -75, 768, 949);
    [self.view addSubview:self.listenMusicView];
}

-(void)goOn:(id)sender {
    [self.listenMusicView removeFromSuperview];
    
    [self.appDel.avPlayer stop];
    self.appDel.avPlayer=nil;
    self.listenBtn.enabled=YES;
    self.homeControl.djView.hidden = NO;
    [self.homeControl startTimer];
    
    [self getQuestionData];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.homeControl = (HomeworkContainerController *)self.parentViewController;
    self.homeControl.reduceTimeButton.enabled = NO;
    self.propsArray = [Utility returnAnswerProps];
    //TODO:初始化答案的字典
    self.answerDic = [Utility returnAnswerDictionaryWithName:LISTEN];
    int status = [[self.answerDic objectForKey:@"status"]intValue];
    if (status == 1) {
        self.number=0;self.branchNumber=0;self.isFirst = NO;
    }else {
        self.isFirst = YES;
        if ([DataService sharedService].number_reduceTime>0) {
            self.homeControl.reduceTimeButton.enabled = YES;
        }
        
        int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
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
        }else {
            self.number=0;self.branchNumber=0;
        }
    }

    [self listenMusicViewUI];
    ////////////////////////////////////////////////////////////////////////
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
-(NSMutableArray *)propsArray {
    if (!_propsArray) {
        _propsArray = [[NSMutableArray alloc]init];
    }
    return _propsArray;
}
-(NSMutableArray *)tmpArray {
    if (!_tmpArray) {
        _tmpArray = [[NSMutableArray alloc]init];
    }
    return _tmpArray;
}
-(NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [[NSMutableArray alloc]init];
    }
    return _urlArray;
}
static int numberOfMusic =0;
//预听
-(void)playMusic {
    NSError *error;
    self.appDel.avPlayer = nil;
    self.appDel.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self.urlArray objectAtIndex:numberOfMusic]] error:&error];
    self.appDel.avPlayer.volume = 1;
    self.appDel.avPlayer.delegate=self;
    [self.appDel.avPlayer play];
}
-(IBAction)listenMusic:(id)sender {
    self.urlArray = nil;
    self.listenBtn.enabled=NO;
    [self.listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
//    for (int i=self.branchNumber; i<self.branchQuestionArray.count; i++) {
//        NSDictionary *dic = [self.branchQuestionArray objectAtIndex:i];
//        NSString *nameString = [NSString stringWithFormat:@"%@-%@.mp3",LISTEN,[dic objectForKey:@"id"]];
//        NSString *savePath=[path stringByAppendingPathComponent:nameString];
//        [self.urlArray addObject:savePath];
//    }
    NSString *str1 = [[NSBundle mainBundle] pathForResource:@"right_sound" ofType:@"mp3"];
    [self.urlArray addObject:str1];
    NSString *str2 = [[NSBundle mainBundle] pathForResource:@"wrong_sound" ofType:@"mp3"];
    [self.urlArray addObject:str2];
    NSString *str3 = [[NSBundle mainBundle] pathForResource:@"btnEffect" ofType:@"wav"];
    [self.urlArray addObject:str3];
    numberOfMusic=0;
    [self playMusic];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        numberOfMusic++;
        if (numberOfMusic<self.urlArray.count) {
            [self performSelector:@selector(playMusic) withObject:nil afterDelay:2];
        }else {
            numberOfMusic = 0;
            [self.appDel.avPlayer stop];
            self.appDel.avPlayer=nil;
            self.listenBtn.enabled=YES;
            [self.listenBtn setImage:[UIImage imageNamed:@"ios-stop"] forState:UIControlStateNormal];
        }
    }
}
-(IBAction)branchListenMusic:(id)sender {
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *nameString = [NSString stringWithFormat:@"%@-%@.mp3",LISTEN,[self.branchQuestionDic objectForKey:@"id"]];
    NSString *savePath=[path stringByAppendingPathComponent:nameString];
    
    NSError *error;
    self.appDel.avPlayer = nil;
    self.appDel.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:savePath] error:&error];
    self.appDel.avPlayer.volume = 1;
    [self.appDel.avPlayer play];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)returnLabel {
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1];
    lab.font = [UIFont systemFontOfSize:22];
    return lab;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textColor = [UIColor blackColor];
}
//替换元音字母
-(NSString *)replaceYYLetterWithString:(NSString *)str {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[Utility handleTheLetter:str]];
    NSArray *array = [NSArray arrayWithObjects:@"A",@"E",@"I",@"O",@"U", nil];
    for (int i=0; i<array.count; i++) {
        NSString *letter = [array objectAtIndex:i];
        if ([mutableArray containsObject:letter]) {
            int index = [mutableArray indexOfObject:letter];
            [mutableArray replaceObjectAtIndex:index withObject:@"-"];
        }else if ([mutableArray containsObject:[letter lowercaseString]]){
            int index = [mutableArray indexOfObject:[letter lowercaseString]];
            [mutableArray replaceObjectAtIndex:index withObject:@"-"];
        }
    }
    NSString *string = [mutableArray componentsJoinedByString:@""];
    
    return string;
}
-(void)resetUI {
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
            self.branchScore += 1;

            int index = [[green_array objectAtIndex:i]intValue];
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:index+Textfield_Tag];
            textField.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        }
    }
    
    //黄色－－部分匹配＋基本正确
    if (![[self.resultDic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"yellow"]!=nil) {
        NSMutableArray *yellow_array = [self.resultDic objectForKey:@"yellow"];
        for (int i=0; i<yellow_array.count; i++) {
            self.branchScore += 0.8;
            
            int index = [[yellow_array objectAtIndex:i]intValue];
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:index+Textfield_Tag];
            textField.textColor = [UIColor colorWithRed:0/255.0 green:5/255.0 blue:28/255.0 alpha:1];

            NSArray *sureArray = [self.resultDic objectForKey:@"sure"];
            CGRect frame = textField.frame;
            frame.origin.y += frame.size.height;
            frame.size.height = 40;
            UILabel *lab = [self returnLabel];
            lab.frame = frame;
            lab.tag = 765;
            lab.text = [sureArray objectAtIndex:i];
            [self.wordsContainerView addSubview:lab];
            
            int indexx = arc4random() % (sureArray.count);
            NSString *letterStr = [sureArray objectAtIndex:indexx];
            NSString *text = [self replaceYYLetterWithString:letterStr];
            self.remindLab.text = text;
        }
    }
    
    if (![[self.resultDic objectForKey:@"wrong"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"wrong"]!=nil) {
        NSMutableArray *yellow_array = [self.resultDic objectForKey:@"wrong"];
        for (int i=0; i<yellow_array.count; i++) {
            int index = [[yellow_array objectAtIndex:i]intValue];
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:index+Textfield_Tag];
            textField.textColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
        }
    }
}

//检查
-(void)checkAnswer:(id)sender {
    self.branchScore = 0;
    NSString *str = @"";NSMutableString *anserString = [NSMutableString string];
    for (int i=0; i<self.orgArray.count; i++) {
        UITextField *txtField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
        [txtField resignFirstResponder];
        if (i==self.orgArray.count-1) {
            [anserString appendFormat:@"%@",txtField.text];
        }else {
            [anserString appendFormat:@"%@;||;",txtField.text];
        }
        if (txtField.text.length<=0) {
            str = @"请填写完整!";
            anserString = [NSMutableString string];
            break;
        }
    }
    
    if (str.length>0) {
        [Utility errorAlert:str];
    }else {
        [self.homeControl stopTimer];
        
        [Utility shared].isOrg = NO;
        NSArray *array = [anserString componentsSeparatedByString:@";||;"];
        self.tmpArray = [NSMutableArray arrayWithArray:array];
        NSString *originString = [self.tmpArray componentsJoinedByString:@" "];
        NSArray *array1 = [Utility handleTheString:originString];
        NSArray *array2 = [Utility metaphoneArray:array1];
        
        [Utility shared].sureArray = [[NSMutableArray alloc]init];
        [Utility shared].greenArray = [[NSMutableArray alloc]init];
        [Utility shared].yellowArray = [[NSMutableArray alloc]init];
        [Utility shared].wrongArray = [[NSMutableArray alloc]init];
        
        self.resultDic = [Utility listenCompareWithArray:array1 andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray];
        
        [self resetUI];
        
        
        self.scoreRadio = (self.branchScore/((float)self.orgArray.count))*100;
        NSLog(@"radio = %.2f",self.scoreRadio);
        if (self.scoreRadio-80>=0) {//超过8成的真确率
            if (self.branchNumber==self.branchQuestionArray.count-1 && self.number==self.questionArray.count-1) {
                [self.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
                [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.checkHomeworkButton addTarget:self action:@selector(finishQuestion:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [self.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
                [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.checkHomeworkButton addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
            }
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
    if (self.branchNumber==self.branchQuestionArray.count-1 && self.number==self.questionArray.count-1) {
        [self.answerDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"status"];
    }
    NSString *time = [Utility getNowDateFromatAnDate];
    [self.answerDic setObject:time forKey:@"update_time"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.number] forKey:@"questions_item"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.branchNumber] forKey:@"branch_item"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%lld",self.homeControl.spendSecond] forKey:@"use_time"];
    //一道题目------------------------------------------------------------------
    NSString *a_id = [NSString stringWithFormat:@"%@",[self.branchQuestionDic objectForKey:@"id"]];
    NSDictionary *answer_dic = [NSDictionary dictionaryWithObjectsAndKeys:a_id,@"id",[NSString stringWithFormat:@"%.2f",self.scoreRadio],@"ratio",string,@"answer", nil];
    
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
    
    [Utility returnAnswerPathWithDictionary:self.answerDic andName:LISTEN];
}
-(void)nextQuestion:(id)sender {
    
    if (self.branchNumber == self.branchQuestionArray.count-1) {
        self.number++;self.branchNumber = 0;
        [self listenMusicViewUI];
        ////////////////////////////////////////////////////////////////////////
    }else {
        [self.homeControl startTimer];
        self.branchNumber++;
        [self getQuestionData];
    }
    
}
//结果
-(void)showResultView {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:@"answer.json"];
    
    NSError *error = nil;
    Class JSONSerialization = [Utility JSONParserClass];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
    NSMutableDictionary *answerDic = [dataObject objectForKey:LISTEN];
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
    self.homeControl.reduceTimeButton.enabled=NO;
    self.checkHomeworkButton.enabled=NO;
    if ([[Utility isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        if (self.isFirst==YES) {
            [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
            self.postInter = [[BasePostInterface alloc]init];
            self.postInter.delegate = self;
            [self.postInter postAnswerFile];
        }else {
            [self showResultView];
        }
    }
}

#pragma mark
#pragma mark - PostDelegate
-(void)getPostInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
            [self showResultView];
        });
    });
}
-(void)getPostInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.appDel.window animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark
#pragma mark - TenSecChallengeResultViewDelegate
-(void)resultViewCommitButtonClicked {//确认完成
    [self.resultView removeFromSuperview];
}
-(void)resultViewRestartButtonClicked {//再次挑战
    [self.resultView removeFromSuperview];
    self.homeControl.reduceTimeButton.enabled=NO;
    self.checkHomeworkButton.enabled=YES;
    self.number=0;self.branchNumber=0;self.isFirst = NO;
    [self listenMusicViewUI];
    ////////////////////////////////////////////////////////////////////////
}
#pragma mark
#pragma mark - 道具
-(void)listenViewReduceTimeButtonClicked {
    [DataService sharedService].number_reduceTime -= 1;
    if ([DataService sharedService].number_reduceTime==0) {
        self.homeControl.reduceTimeButton.enabled = NO;
    }
    
    if (self.homeControl.spendSecond > 5) {
        self.homeControl.spendSecond = self.homeControl.spendSecond -5;
    }else{
        self.homeControl.spendSecond = 0;
    }
    self.homeControl.timerLabel.text = [Utility formateDateStringWithSecond:self.homeControl.spendSecond];
    
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
    [Utility returnAnswerPathWithProps:self.propsArray];
}
@end
