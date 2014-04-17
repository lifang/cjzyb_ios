//
//  ListenWriteViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-12.
//  Copyright (c) 2014年 david. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ListenWriteViewController.h"


static BOOL isCanUpLoad = NO;

@interface ListenWriteViewController ()
@property (nonatomic, strong) TenSecChallengeResultView *resultView;
@end

#define Textfield_Tag 76734789
#define Textfield_Width  180
#define Textfield_Height  60
#define Textfield_Space_Width 30
#define Textfield_Space_Height 60

#define Left_button_tag 987
#define Right_button_tag 123


#define Music_tag_normal 55
#define Music_tag_play   66
#define Music_tag_pause  77

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
    txt.autocorrectionType = UITextAutocorrectionTypeNo;
    txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt.backgroundColor = [UIColor whiteColor];
    txt.textColor = [UIColor blackColor];
    txt.textAlignment = NSTextAlignmentCenter;
    txt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt.font = [UIFont systemFontOfSize:33];
    [txt.layer setMasksToBounds:YES];
    [txt.layer setCornerRadius:8];
    
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:txt];
    
    return txt;
}
-(UILabel *)returnHistoryLabel {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:33];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    return label;
}
-(UILabel *)returnPointLabel {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    return label;
}
-(UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(void)setUI {
    self.homeControl.quitHomeworkButton.enabled = YES;
    
    [self.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
    [self.checkHomeworkButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.checkHomeworkButton addTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wordsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.wordsContainerView removeFromSuperview];
    self.wordsContainerView = [[UIView alloc]init];
    self.wordsContainerView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectMake(0, 0, Textfield_Width, Textfield_Height);
    CGRect point_frame = CGRectMake(0, 0, 20, 20);
    
    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
    
    [Utility shared].isOrg = NO;
    [Utility shared].rangeArray = [[NSMutableArray alloc]init];
    self.orgArray = [Utility handleTheString:content];
    
    self.metaphoneArray = [Utility metaphoneArray:self.orgArray];
    self.tmpArray = nil;self.tmpIndexArray = nil;
    
    for (int i=0; i<self.orgArray.count; i++) {
        UITextField *text = [self returnTextField];
        text.tag = i+Textfield_Tag;
        frame.origin.x = 10+(Textfield_Width+Textfield_Space_Width)*(i%3);
        frame.origin.y = 10+(Textfield_Height+Textfield_Space_Height)*(i/3);
        text.frame = frame;
        [self.wordsContainerView addSubview:text];
        
        NSTextCheckingResult *math = (NSTextCheckingResult *)[[Utility shared].rangeArray objectAtIndex:i];
        NSRange range = [math rangeAtIndex:0];
        if (i==0 && range.location != 0) {//第一位出现标点的情况
            NSString *str = [content substringWithRange:NSMakeRange(0, range.location)];
            UILabel *label = [self returnPointLabel];
            point_frame.origin.x = 0;
            point_frame.origin.y = frame.origin.y+frame.size.height-20;
            label.frame = point_frame;
            label.text = str;
            [self.wordsContainerView addSubview:label];
        }else if (i<self.orgArray.count-1){
            NSTextCheckingResult *math2 = (NSTextCheckingResult *)[[Utility shared].rangeArray objectAtIndex:i+1];
            NSRange range2 = [math2 rangeAtIndex:0];
            
            NSString *str = [content substringWithRange:NSMakeRange(range.location+range.length, range2.location-range.location-range.length)];
            str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
            if (str.length>0) {
                UILabel *label = [self returnPointLabel];
                point_frame.origin.x = frame.origin.x+frame.size.width+10;
                point_frame.origin.y = frame.origin.y+frame.size.height-20 ;
                label.frame = point_frame;
                label.text = str;
                [self.wordsContainerView addSubview:label];
            }
        }else {
            int number = content.length - range.location - range.length;
            if (number>0) {
                NSString *str = [content substringWithRange:NSMakeRange(range.location+range.length, number)];
                str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
                if (str.length>0) {
                    UILabel *label = [self returnPointLabel];
                    point_frame.origin.x = frame.origin.x+frame.size.width+10;
                    point_frame.origin.y = frame.origin.y+frame.size.height-20 ;
                    label.frame = point_frame;
                    label.text = str;
                    [self.wordsContainerView addSubview:label];
                }
            }
        }
    }
    [Utility shared].rangeArray = nil;[Utility shared].isOrg = YES;
    self.wordsContainerView.frame = CGRectMake(768, 53, 640, frame.origin.y+Textfield_Height+Textfield_Space_Height);
    [self.view addSubview:self.wordsContainerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(98, 53, 640, frame.origin.y+Textfield_Height+Textfield_Space_Height)];
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
-(void)setHistoryUI
{
    if (self.branchNumber==self.history_branchQuestionArray.count-1 && self.number==self.history_questionArray.count-1) {
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
    self.wordsContainerView = [[UIView alloc]init];
    self.wordsContainerView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectMake(0, 0, 600, 0);
    NSString *content = [self.branchQuestionDic objectForKey:@"content"];
    self.orgArray = [Utility handleTheString:content];
    self.metaphoneArray = [Utility metaphoneArray:self.orgArray];
    
    CGSize textSize=[content sizeWithFont:[UIFont systemFontOfSize:33] constrainedToSize:CGSizeMake(586, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size.height = textSize.height+10;
    UILabel *label = [self returnHistoryLabel];
    label.frame = frame;
    label.text = content;
    [self.wordsContainerView addSubview:label];
    
    self.wordsContainerView.frame = CGRectMake(768, 53, 640, 600);
    [self.view addSubview:self.wordsContainerView];
    
    [Utility shared].isOrg = NO;
    [Utility shared].correctArray = [[NSMutableArray alloc]init];
    [Utility shared].sureArray = [[NSMutableArray alloc]init];
    [Utility shared].greenArray = [[NSMutableArray alloc]init];
    [Utility shared].yellowArray = [[NSMutableArray alloc]init];
    [Utility shared].wrongArray = [[NSMutableArray alloc]init];
    [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
    [Utility shared].firstpoint = 0;
    
    NSString *txt = [self.history_branchQuestionDic objectForKey:@"answer"];
    NSArray *array = [txt componentsSeparatedByString:@";||;"];
    NSString *originString =[array objectAtIndex:0];
    [Utility shared].isOrg = NO;
    NSArray *array1 = [Utility handleTheString:originString];
    NSArray *array2 = [Utility metaphoneArray:array1];
    [Utility shared].sureArray = [[NSMutableArray alloc]init];
    [Utility shared].greenArray = [[NSMutableArray alloc]init];
    [Utility shared].yellowArray = [[NSMutableArray alloc]init];
    [Utility shared].wrongArray = [[NSMutableArray alloc]init];
    [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
    [Utility shared].firstpoint = 0;
    self.resultDic = [Utility listenCompareWithArray:array1 andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray WithRange:[Utility shared].rangeArray];
    NSMutableString *remindString = [NSMutableString string];
    if (![[self.resultDic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"yellow"]!=nil) {
        NSArray *sureArray = [self.resultDic objectForKey:@"sure"];
        for (int i=0; i<sureArray.count; i++) {
            [remindString appendFormat:@"%@  ",[sureArray objectAtIndex:i]];
        }
    }
    self.remindLab.text = remindString;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.wordsContainerView setFrame:CGRectMake(108, 53, 640, frame.origin.y+frame.size.height)];
    } completion:^(BOOL finished){
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
    [self.homeControl dismissViewControllerAnimated:YES completion:nil];
}
-(void)getQuestionData {
    self.branchScore = 0;
    self.questionDic = [self.questionArray objectAtIndex:self.number];
    self.branchQuestionArray = [self.questionDic objectForKey:@"branch_questions"];
    self.branchQuestionDic = [self.branchQuestionArray objectAtIndex:self.branchNumber];
    
    if ([DataService sharedService].isHistory==YES) {
        
        self.history_questionDic = [self.history_questionArray objectAtIndex:self.number];
        self.history_branchQuestionArray = [self.history_questionDic objectForKey:@"branch_questions"];
        self.history_branchQuestionDic = [self.history_branchQuestionArray objectAtIndex:self.branchNumber];
        
        NSString *txt = [self.history_branchQuestionDic objectForKey:@"answer"];
        NSArray *array = [txt componentsSeparatedByString:@";||;"];
        self.historyAnswer.text = [NSString stringWithFormat:@"你的作答: %@",[array objectAtIndex:0]];
        
        self.homeControl.numberOfQuestionLabel.text = [NSString stringWithFormat:@"%d/%d",self.branchNumber+1,self.history_branchQuestionArray.count];
        [self setHistoryUI];
    }else {
        self.homeControl.numberOfQuestionLabel.text = [NSString stringWithFormat:@"%d/%d",self.branchNumber+1,self.branchQuestionArray.count];
        [self setUI];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.again_radio=0;
    self.again_first=YES;
    self.remindView.hidden=YES;
    self.listenBtn.tag = Music_tag_normal;
    self.branch_listenBtn.tag = Music_tag_normal;
    [self.branch_listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
    
    [self roundView:self.listenBtn];
    self.historyView.hidden=YES;
    NSDictionary * dic = [Utility initWithJSONFile:[DataService sharedService].taskObj.taskStartDate];
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
    self.listenBtn.tag = Music_tag_normal;
    self.homeControl.djView.hidden = NO;
    [self.homeControl startTimer];
    
    [self getQuestionData];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.homeControl = (HomeworkContainerController *)self.parentViewController;
    self.homeControl.reduceTimeButton.enabled = NO;
    self.number=0;self.branchNumber=0;self.isFirst = NO;
    //TODO:初始化答案的字典
    
    self.answerDic = [Utility returnAnswerDictionaryWithName:LISTEN andDate:[DataService sharedService].taskObj.taskStartDate];
    int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
    if ([DataService sharedService].taskObj.isExpire == YES) {//作业过期时间
        self.remindLabel.hidden = YES;
        
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
            self.remindLabel.text = @"以下为上面需要多写的词。";
            self.history_questionArray = [NSMutableArray arrayWithArray:[self.answerDic objectForKey:@"questions"]];
            self.historyView.hidden=NO;
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
            
            self.homeControl.rotioLabel.text = [NSString stringWithFormat:@"%d%%",(int)score_radio];
            
            [self getQuestionData];
        }
        
    }else {
        self.propsArray = [Utility returnAnswerPropsandDate:[DataService sharedService].taskObj.taskStartDate];
        self.remindLabel.text = @"以下为上面可能错的词哦！试着将它们填入相应的位置。";
        int status = [[self.answerDic objectForKey:@"status"]intValue];
        if (status == 1) {
            //题目已经完成
        }else if ([DataService sharedService].taskObj.isExpire == NO){
            
            self.isFirst = YES;
            if ([DataService sharedService].number_reduceTime>0) {
                self.homeControl.reduceTimeButton.enabled = YES;
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
            }else {
                self.number=0;self.branchNumber=0;
            }
            
        }
        
        [self listenMusicViewUI];
    }
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
-(NSMutableArray *)tmpIndexArray {
    if (!_tmpIndexArray) {
        _tmpIndexArray = [[NSMutableArray alloc]init];
    }
    return _tmpIndexArray;
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
    
    if (self.listenBtn.tag == Music_tag_normal) {
        self.urlArray = nil;
        self.listenBtn.tag = Music_tag_play;
        self.playMusicModel=0;
        [self.listenBtn setImage:[UIImage imageNamed:@"ios-stop"] forState:UIControlStateNormal];
        NSString *path = [Utility returnPath];
        NSString *documentDirectory = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate];
        for (int i=self.branchNumber; i<self.branchQuestionArray.count; i++) {
            NSDictionary *dic = [self.branchQuestionArray objectAtIndex:i];
            NSString *nameString = [NSString stringWithFormat:@"%@/%@",documentDirectory,[dic objectForKey:@"resource_url"]];
            [self.urlArray addObject:nameString];
        }
        numberOfMusic=0;
        [self playMusic];
    }else if (self.listenBtn.tag == Music_tag_play) {
        [self.listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
        self.listenBtn.tag = Music_tag_pause;
        [self.appDel.avPlayer pause];
        
    }else if (self.listenBtn.tag == Music_tag_pause){
        [self.listenBtn setImage:[UIImage imageNamed:@"ios-stop"] forState:UIControlStateNormal];
        self.listenBtn.tag = Music_tag_play;
        [self.appDel.avPlayer play];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        if (self.playMusicModel==0) {
            numberOfMusic++;
            if (numberOfMusic<self.urlArray.count) {
                [self performSelectorOnMainThread:@selector(playMusic) withObject:nil waitUntilDone:NO];
            }else {
                numberOfMusic = 0;
                [self.appDel.avPlayer stop];
                self.appDel.avPlayer=nil;
                self.listenBtn.tag = Music_tag_normal;
                [self.listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
            }
        }else {
            [self.appDel.avPlayer stop];
            self.appDel.avPlayer=nil;
            [self.branch_listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
        }
        
    }
}
-(IBAction)branchListenMusic:(id)sender {
    
    if (self.branch_listenBtn.tag == Music_tag_normal) {
        self.branch_listenBtn.tag = Music_tag_play;
        [self.branch_listenBtn setImage:[UIImage imageNamed:@"ios-stop"] forState:UIControlStateNormal];
        self.playMusicModel=1;
        NSString *path = [Utility returnPath];
        NSString *documentDirectory = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate];
        
        NSString *nameString = [NSString stringWithFormat:@"%@/%@",documentDirectory,[self.branchQuestionDic objectForKey:@"resource_url"]];
        
        NSError *error;
        self.appDel.avPlayer = nil;
        self.appDel.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:nameString] error:&error];
        self.appDel.avPlayer.volume = 1;
        self.appDel.avPlayer.delegate = self;
        [self.appDel.avPlayer play];
    }else if (self.branch_listenBtn.tag == Music_tag_play){
        self.branch_listenBtn.tag = Music_tag_normal;
        [self.branch_listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
        [self.appDel.avPlayer stop];
        self.appDel.avPlayer=nil;
        
    }
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

#pragma mark
#pragma mark textfield代理

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textColor = [UIColor blackColor];
    
    if (textField.text.length>0) {
        CGRect frame = textField.frame;
        CGRect button_frame = CGRectMake(0, 0, 33, 25);
        int currentTag = textField.tag-Textfield_Tag;
        BOOL isCanMove = NO;
        //左边
        for (int i=0; i<currentTag; i++) {
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
            if (textField.text.length==0) {
                isCanMove=YES;
                break;
            }
        }
        
        if (isCanMove==YES) {
            button_frame.origin.x = frame.origin.x;
            button_frame.origin.y = frame.origin.y+frame.size.height+5;
            self.leftButton.frame = button_frame;
            self.leftButton.tag = currentTag;
            [self.wordsContainerView addSubview:self.leftButton];
        }
        //右边
        isCanMove=NO;
        for (int i=currentTag; i<self.orgArray.count; i++) {
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
            if (textField.text.length==0) {
                isCanMove=YES;
                break;
            }
        }
        
        if (isCanMove==YES) {
            button_frame.origin.x = frame.origin.x+frame.size.width-33;
            button_frame.origin.y = frame.origin.y+frame.size.height+5;
            self.rightButton.frame = button_frame;
            self.rightButton.tag = currentTag;
            [self.wordsContainerView addSubview:self.rightButton];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.leftButton removeFromSuperview];
    [self.rightButton removeFromSuperview];
    self.leftButton=nil;self.rightButton=nil;
}
-(void)textFieldChanged:(NSNotification *)sender {
    UITextField *txtField = (UITextField *)sender.object;
    UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:txtField.tag];
    NSString *str = textField.text;
    str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (str.length>0) {
        CGRect frame = textField.frame;
        CGRect button_frame = CGRectMake(0, 0, 33, 25);
        int currentTag = textField.tag-Textfield_Tag;
        BOOL isCanMove = NO;
        //左边
        for (int i=0; i<currentTag; i++) {
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
            if (textField.text.length==0) {
                isCanMove=YES;
                break;
            }
        }
        
        if (isCanMove==YES) {
            button_frame.origin.x = frame.origin.x;
            button_frame.origin.y = frame.origin.y+frame.size.height+5;
            self.leftButton.frame = button_frame;
            self.leftButton.tag = currentTag;
            [self.wordsContainerView addSubview:self.leftButton];
        }
        //右边
        isCanMove=NO;
        for (int i=currentTag; i<self.orgArray.count; i++) {
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
            if (textField.text.length==0) {
                isCanMove=YES;
                break;
            }
        }
        
        if (isCanMove==YES) {
            button_frame.origin.x = frame.origin.x+frame.size.width-33;
            button_frame.origin.y = frame.origin.y+frame.size.height+5;
            self.rightButton.frame = button_frame;
            self.rightButton.tag = currentTag;
            [self.wordsContainerView addSubview:self.rightButton];
        }
    }else {
        textField.text = nil;
        [self.leftButton removeFromSuperview];
        [self.rightButton removeFromSuperview];
        self.leftButton=nil;self.rightButton=nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        int tag = (textField.tag + 1);
        UITextField *firstTextField;
        for (UIView *view in self.wordsContainerView.subviews) {
            if (view.tag == Textfield_Tag) {
                firstTextField = (UITextField *)view;
            }
            if (view.tag == tag) {
                [view becomeFirstResponder];
                return NO;
            }
        }
        if (firstTextField) {
            [firstTextField becomeFirstResponder];
        }
        return NO;
    }
    return YES;
}

#pragma mark
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
            [mutableArray replaceObjectAtIndex:index withObject:@"_"];
        }
    }
    NSString *string = [mutableArray componentsJoinedByString:@""];
    
    return string;
}
-(void)resetUIWith:(NSString *)string {
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
            
            NSTextCheckingResult *math = (NSTextCheckingResult *)[green_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            NSString *str = [string substringWithRange:NSMakeRange(range.location, range.length)];
            
            int index = [self.tmpArray indexOfObject:str];
            int tag = [[self.tmpIndexArray objectAtIndex:index]integerValue];
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:tag];
            textField.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        }
        
        NSMutableArray *correct_array = [self.resultDic objectForKey:@"correct"];
        if (self.orgArray.count==correct_array.count) {
            
        }else {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.orgArray];
            NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", correct_array];
            
            [tmpArray filterUsingPredicate:thePredicate];
            self.remindView.hidden=NO;
            
            int indexx = arc4random() % (tmpArray.count);
            NSString *letterStr = [tmpArray objectAtIndex:indexx];
            NSString *text = [self replaceYYLetterWithString:letterStr];
            self.remindLab.text = text;
        }
    }else {
        self.remindView.hidden=NO;
        
        int indexx = arc4random() % (self.orgArray.count);
        NSString *letterStr = [self.orgArray objectAtIndex:indexx];
        NSString *text = [self replaceYYLetterWithString:letterStr];
        self.remindLab.text = text;
    }
    
    
    //黄色－－部分匹配＋基本正确
    if (![[self.resultDic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"yellow"]!=nil) {
        NSMutableArray *yellow_array = [self.resultDic objectForKey:@"yellow"];
        for (int i=0; i<yellow_array.count; i++) {
            self.branchScore += 0;
            
            NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            NSString *str = [string substringWithRange:NSMakeRange(range.location, range.length)];
            
            int index = [self.tmpArray indexOfObject:str];
            int tag = [[self.tmpIndexArray objectAtIndex:index]integerValue];
            
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:tag];
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
        }
    }
    
    if (![[self.resultDic objectForKey:@"wrong"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"wrong"]!=nil) {
        NSMutableArray *yellow_array = [self.resultDic objectForKey:@"wrong"];
        for (int i=0; i<yellow_array.count; i++) {
            NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            NSString *str = [string substringWithRange:NSMakeRange(range.location, range.length)];
            
            int index = [self.tmpArray indexOfObject:str];
            UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:index+Textfield_Tag];
            textField.textColor = [UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1];
        }
    }
}
-(void)leftBtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int currentTag = btn.tag;
    
    int number = 0;
    for (int i=currentTag-1; i>=0; i--) {
        UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
        if (textField.text.length==0) {
            number=i;
            break;
        }
    }
    
    for (int i=number+1; i<=currentTag; i++) {
        UITextField *textField1 = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
        UITextField *textField2 = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag-1];
        textField2.text = textField1.text;
        textField1.text = @"";
    }
    UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:currentTag+Textfield_Tag];
    [textField resignFirstResponder];
}
-(void)rightBtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int currentTag = btn.tag;
    
    int number = 0;
    for (int i=currentTag+1; i<=self.orgArray.count; i++) {
        UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
        if (textField.text.length==0) {
            number=i;
            break;
        }
    }
    
    for (int i=number-1; i>=currentTag; i--) {
        UITextField *textField1 = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
        UITextField *textField2 = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag+1];
        textField2.text = textField1.text;
        textField1.text = @"";
    }
    UITextField *textField = (UITextField *)[self.wordsContainerView viewWithTag:currentTag+Textfield_Tag];
    [textField resignFirstResponder];
}

static CGFloat tmp_ratio = -100;
#pragma mark - 做题
//检查
-(void)checkAnswer:(id)sender {
    self.wrongNumber = 0;
    self.tmpIndexArray = nil;
    if (self.appDel.avPlayer) {
        [self.appDel.avPlayer stop];
        self.appDel.avPlayer=nil;
        self.branch_listenBtn.tag = Music_tag_normal;
        [self.branch_listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
    }
    self.branchScore = 0;
    NSMutableString *anserString = [NSMutableString string];
    NSMutableString *wrong_anserString = [NSMutableString string];
    
    BOOL isCanCheck = NO;
    BOOL isFinish = YES;
    for (int i=0; i<self.orgArray.count; i++) {
        UITextField *txtField = (UITextField *)[self.wordsContainerView viewWithTag:i+Textfield_Tag];
        [txtField resignFirstResponder];
        
        if (txtField.text && txtField.text.length>0) {
            [self.tmpIndexArray addObject:[NSString stringWithFormat:@"%d",i+Textfield_Tag]];//记录坐标
            isCanCheck = YES;
            int k=i+1;
            NSMutableString *mutableStr = [NSMutableString string];
            if (k<self.orgArray.count) {
                while (k<self.orgArray.count) {
                    UITextField *txtField2 = (UITextField *)[self.wordsContainerView viewWithTag:k+Textfield_Tag];
                    [mutableStr appendString:txtField2.text];
                    k++;
                }
            }
            NSString *str = mutableStr;
            str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
            if (str.length==0) {
                [anserString appendFormat:@"%@",txtField.text?:@""];
            }else {
                [anserString appendFormat:@"%@ ",txtField.text?:@""];
            }
        }else {
            isFinish = NO;
        }
    }
    
    if (isCanCheck == YES) {
        [self.homeControl stopTimer];
        [Utility shared].isOrg = NO;
        NSArray *array = [anserString componentsSeparatedByString:@" "];
        self.tmpArray = [NSMutableArray arrayWithArray:array];
        NSString *originString = [self.tmpArray componentsJoinedByString:@" "];
        NSArray *array1 = [Utility handleTheString:originString];
        NSArray *array2 = [Utility metaphoneArray:array1];
        self.tmpArray = [NSMutableArray arrayWithArray:array1];
        [Utility shared].correctArray = [[NSMutableArray alloc]init];
        [Utility shared].sureArray = [[NSMutableArray alloc]init];
        [Utility shared].greenArray = [[NSMutableArray alloc]init];
        [Utility shared].yellowArray = [[NSMutableArray alloc]init];
        [Utility shared].wrongArray = [[NSMutableArray alloc]init];
        [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
        [Utility shared].firstpoint = 0;
        
        if (array1.count>0 && array2.count>0&&self.orgArray.count>0&&self.metaphoneArray.count>0) {
            self.resultDic = [Utility listenCompareWithArray:array1 andArray:array2 WithArray:self.orgArray andArray:self.metaphoneArray WithRange:[Utility shared].rangeArray];
            
            [self resetUIWith:originString];
            
            self.scoreRadio = (self.branchScore/((float)self.orgArray.count))*100;
            if (tmp_ratio<0) {
                tmp_ratio = self.scoreRadio;//记录第一次的正确率
            }
            
            BOOL isToJson = NO;//判断是否写入json
            
            if (![[self.resultDic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"yellow"]!=nil) {
                NSMutableArray *yellow_array = [self.resultDic objectForKey:@"yellow"];
                for (int i=0; i<yellow_array.count; i++) {
                    NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
                    NSRange range = [math rangeAtIndex:0];
                    NSString *str = [originString substringWithRange:NSMakeRange(range.location, range.length)];
                    
                    int index = [self.tmpArray indexOfObject:str];
                    [wrong_anserString appendFormat:@"%@;||;",[self.orgArray objectAtIndex:index]];
                }
            }
            
            if (![[self.resultDic objectForKey:@"wrong"]isKindOfClass:[NSNull class]] && [self.resultDic objectForKey:@"wrong"]!=nil) {
                isToJson = NO;//还有错词不写入json
                
                NSMutableArray *yellow_array = [self.resultDic objectForKey:@"wrong"];
                for (int i=0; i<yellow_array.count; i++) {
                    NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
                    NSRange range = [math rangeAtIndex:0];
                    NSString *str = [originString substringWithRange:NSMakeRange(range.location, range.length)];
                    
                    int index = [self.tmpArray indexOfObject:str];
                    if (i==yellow_array.count-1) {
                        [wrong_anserString appendFormat:@"%@",[self.orgArray objectAtIndex:index]];
                    }else {
                        [wrong_anserString appendFormat:@"%@;||;",[self.orgArray objectAtIndex:index]];
                    }
                }
            }else if (isFinish == YES){
                isToJson = YES;//没有错词写入json
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
            }
            
            if (self.again_first == YES) {
                self.again_first=NO;
                self.again_radio += self.scoreRadio;
            }
            if (self.scoreRadio-100>=0) {
                TRUESOUND;
            }else {
                FALSESOUND;
            }
            if (self.isFirst==YES && isToJson==YES) {
                NSString *answer = [NSString stringWithFormat:@"%@;||;%@",anserString,wrong_anserString];
                //TODO:写入json
                int number_question = [[self.answerDic objectForKey:@"questions_item"]intValue];
                int number_branch_question = [[self.answerDic objectForKey:@"branch_item"]intValue];
                if (number_question>self.number) {
                    //表示已经做过这道题
                }else if (number_question==self.number){
                    if (number_branch_question>=self.branchNumber) {
                        //表示已经做过这道题
                    }else {
                        [self writeToAnswerJsonWithString:answer];
                    }
                }else {
                    [self writeToAnswerJsonWithString:answer];
                }
            }
        }
        
    }else {
        [Utility errorAlert:@"请填写听到的单词!"];
    }
}
-(void)writeToAnswerJsonWithString:(NSString *)string {
    isCanUpLoad = YES;
    
    if (self.branchNumber==self.branchQuestionArray.count-1 && self.number==self.questionArray.count-1) {
        [self.answerDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"status"];
        NSString *str = [Utility returnTypeOfQuestionWithString:LISTEN];
        [[DataService sharedService].taskObj.finish_types addObject:str];
    }
    
    NSString *time = [Utility getNowDateFromatAnDate];
    [self.answerDic setObject:time forKey:@"update_time"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.number] forKey:@"questions_item"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%d",self.branchNumber] forKey:@"branch_item"];
    [self.answerDic setObject:[NSString stringWithFormat:@"%lld",self.homeControl.spendSecond] forKey:@"use_time"];
    //一道题目------------------------------------------------------------------
    NSString *a_id = [NSString stringWithFormat:@"%@",[self.branchQuestionDic objectForKey:@"id"]];
    NSDictionary *answer_dic = [NSDictionary dictionaryWithObjectsAndKeys:a_id,@"id",[NSString stringWithFormat:@"%.f",tmp_ratio],@"ratio",string,@"answer", nil];
    tmp_ratio = -100;
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
    
    [Utility returnAnswerPathWithDictionary:self.answerDic andName:LISTEN andDate:[DataService sharedService].taskObj.taskStartDate];
}
-(void)nextQuestion:(id)sender {
    if (self.appDel.avPlayer) {
        [self.appDel.avPlayer stop];
        self.appDel.avPlayer=nil;
    }
    self.remindLab.text = @"";
    self.again_first=YES;self.remindView.hidden=YES;

    if (self.branchNumber == self.branchQuestionArray.count-1) {
        self.number++;self.branchNumber = 0;
        self.listenBtn.tag = Music_tag_normal;
        [self.listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
        
        [self listenMusicViewUI];
    }else {
        self.branch_listenBtn.tag = Music_tag_normal;
        [self.branch_listenBtn setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
        
        [self.homeControl startTimer];
        self.branchNumber++;
        [self getQuestionData];
    }
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
        
        self.resultView.resultBgView.hidden=NO;
        self.resultView.noneArchiveView.hidden=YES;
        self.resultView.ratio = (NSInteger)score_radio;
        self.resultView.timeLimit = self.specified_time;
        self.resultView.isEarly = [Utility compareTime];
    }else {
        int count =0;
        for (int i=0; i<self.questionArray.count; i++) {
            NSDictionary *question_dic = [self.questionArray objectAtIndex:i];
            NSArray *branchArray = [question_dic objectForKey:@"branch_questions"];
            for (int j=0; j<branchArray.count; j++) {
                count++;
            }
        }
        
        self.resultView.noneArchiveView.hidden=NO;
        self.resultView.resultBgView.hidden=YES;
        self.resultView.ratio = (NSInteger)(self.again_radio/count);
    }
    
    [self.resultView initView];
    
    [self.view addSubview: self.resultView];
}
-(void)finishQuestion:(id)sender {
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
            
            [DataService sharedService].cardsCount = [[result objectForKey:@"knowledges_cards_count"]integerValue];
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
    self.homeControl.quitHomeworkButton.enabled = YES;
    [self.resultView removeFromSuperview];
    [self.homeControl dismissViewControllerAnimated:YES completion:nil];
}
-(void)resultViewRestartButtonClicked {//再次挑战
    [self.resultView removeFromSuperview];
    self.homeControl.reduceTimeButton.enabled=NO;
    self.checkHomeworkButton.enabled=YES;self.remindView.hidden=YES;
    self.number=0;self.branchNumber=0;self.isFirst = NO;
    self.homeControl.spendSecond = 0;self.again_radio=0;
    [self.homeControl startTimer];
    [self listenMusicViewUI];
    ////////////////////////////////////////////////////////////////////////
}
#pragma mark
#pragma mark - 道具
//0减少时间   1显示正确答案
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
    
    NSMutableDictionary *branch_propDic = [NSMutableDictionary dictionaryWithDictionary:[self.propsArray objectAtIndex:0]];
    NSMutableArray *branch_propArray = [NSMutableArray arrayWithArray:[branch_propDic objectForKey:@"branch_id"]];
    [branch_propArray addObject:[NSNumber numberWithInt:[[self.branchQuestionDic objectForKey:@"id"] intValue]]];
    [branch_propDic setObject:branch_propArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:0 withObject:branch_propDic];
    [Utility returnAnswerPathWithProps:self.propsArray andDate:[DataService sharedService].taskObj.taskStartDate];
}


-(void)exitListenView {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"作业提示" message:@"确定退出做题?" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
    alert.tag = 100;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (alertView.tag == 100) {
        if (buttonIndex==0) {
            tmp_ratio=-100;
            if (self.appDel.avPlayer) {
                [self.appDel.avPlayer stop];
                self.appDel.avPlayer=nil;
            }
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
