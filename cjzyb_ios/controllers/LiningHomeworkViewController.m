//
//  LiningHomeworkViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LiningHomeworkViewController.h"
#import "ParseQuestionJsonFileTool.h"
#import "LiningDrawLinesView.h"
#import "HomeworkContainerController.h"
#define BUTTON_WIDTH 180
#define BUTTON_SPACE 50
@interface LiningHomeworkViewController ()
///背景划线画板
@property (weak, nonatomic) IBOutlet LiningDrawLinesView *drawLinesBoardView;
///存放左边单词的LiningItemButton
@property (nonatomic,strong) NSMutableArray *leftButtonViewArray;
///存放右边单词的LiningItemButton
@property (nonatomic,strong) NSMutableArray *rightButtonViewArray;

@property (nonatomic,strong) LiningItemButton *leftSelectedButton;

@property (nonatomic,strong) LiningItemButton *rightSelectedButton;
@end

@implementation LiningHomeworkViewController

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
//    [self.drawLinesBoardView redrawLinesWithLineObjArray:@[[LineObj initLineObjWithStartPoint:(CGPoint){10,20} withEndPoint:(CGPoint){100,200}],[LineObj initLineObjWithStartPoint:(CGPoint){10,500} withEndPoint:(CGPoint){100,20}]]];
    [self loadLiningSubjectsFronJsonFile];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark action选择题目操作

///提示正确答案
-(void)tipCorrectAnswer{
    BOOL isTiped = NO;
    for (LiningItemButton *button in self.leftButtonViewArray) {
        if (!button.isTiped) {
            for (LiningItemButton *rightButton in self.rightButtonViewArray) {
                if (rightButton.liningSentenceObj == button.liningSentenceObj) {
                    rightButton.isTiped = YES;
                    button.isTiped = YES;
                    rightButton.layer.borderColor = button.layer.borderColor;
                    break;
                }
            }
            isTiped = YES;
            break;
        }
    }
    if (isTiped) {
        
    }
}

///重新加载到第一题
-(void)reloadFirstLineSubject{
    if (self.liningSubjectArray.count > 0) {
        self.currentlineSubjectObj = [self.liningSubjectArray firstObject];
    }
    if (self.currentlineSubjectObj) {
        [self reloadLineItemButton];
    }else{
        [Utility errorAlert:@"当前题目没有数据"];
    }
}
///加载到下一题
-(void)reloadNextLineSubject{
    int index = [self.liningSubjectArray indexOfObject:self.currentlineSubjectObj];
    if (index < self.liningSubjectArray.count-1) {
        self.currentlineSubjectObj = [self.liningSubjectArray objectAtIndex:index+1];
        [self reloadLineItemButton];
    }else{//点击最后一个小题题目
    
    }
}

///划线
-(void)drawLinesBetweenSentences{
    NSMutableArray *lines = [NSMutableArray array];
    for (LiningItemButton *leftButton in self.leftButtonViewArray) {
        if (leftButton.liningOppositeItemButton) {
            LiningItemButton *rightButton = leftButton.liningOppositeItemButton;
            LineObj *line = [[LineObj alloc] init];
            CGRect leftRect = leftButton.frame;
            CGRect rightRect = rightButton.frame;
            CGPoint backLeftPoint = (CGPoint){CGRectGetMaxX(leftRect),CGRectGetMinY(leftRect)+CGRectGetWidth(leftRect)/2};
            CGPoint backRightPoint = (CGPoint){CGRectGetMinX(rightRect),CGRectGetMinY(rightRect)+CGRectGetWidth(rightRect)/2};
            line.startPoint = [self.view convertPoint:backLeftPoint toView:self.drawLinesBoardView];
            line.endPoint =  [self.view convertPoint:backRightPoint toView:self.drawLinesBoardView];
            
            [lines addObject:line];
        }
    }
    [self.drawLinesBoardView redrawLinesWithLineObjArray:lines];
}
///点击每个词的button时调用
-(void)lineItemButtonClicked:(LiningItemButton*)button{
    if (!button.isLeft) {//right
        if (button.isTaped) {
            if (button.liningOppositeItemButton && self.leftSelectedButton && self.leftSelectedButton.liningOppositeItemButton == button) {
                button.liningOppositeItemButton.isTaped = NO;
                button.liningOppositeItemButton.liningOppositeItemButton = nil;
                button.liningOppositeItemButton = nil;
                button.isTaped = NO;
                self.rightSelectedButton = nil;
            }else{
                if (!self.rightSelectedButton.liningOppositeItemButton) {
                    self.rightSelectedButton.isTaped = NO;
                }
                self.rightSelectedButton = button;
//                button.isTaped = NO;
            }
        }else{
            if (self.rightSelectedButton && !self.rightSelectedButton.liningOppositeItemButton) {
                self.rightSelectedButton.isTaped = NO;
            }
            self.rightSelectedButton = button;
            if (self.leftSelectedButton && !self.leftSelectedButton.liningOppositeItemButton && self.leftSelectedButton.isTaped) {
                self.leftSelectedButton.liningOppositeItemButton = button;
                button.liningOppositeItemButton = self.leftSelectedButton;
            }
            button.isTaped = !button.isTaped;
        }
        
    }else{//left
        if (button.isTaped) {
            if (button.liningOppositeItemButton && self.rightSelectedButton && self.rightSelectedButton.liningOppositeItemButton == button) {
                button.liningOppositeItemButton.isTaped = NO;
                button.liningOppositeItemButton.liningOppositeItemButton = nil;
                button.liningOppositeItemButton = nil;
                button.isTaped = NO;
                self.leftSelectedButton = nil;
            }else{
                if (!self.leftSelectedButton.liningOppositeItemButton) {
                    self.leftSelectedButton.isTaped = NO;
                }
                self.leftSelectedButton = button;
//                button.isTaped = NO;
            }
        }else{
            if (self.leftSelectedButton && !self.leftSelectedButton.liningOppositeItemButton) {
                self.leftSelectedButton.isTaped = NO;
            }
            self.leftSelectedButton = button;
            if (self.rightSelectedButton && !self.rightSelectedButton.liningOppositeItemButton && self.rightSelectedButton.isTaped) {
                self.rightSelectedButton.liningOppositeItemButton = button;
                button.liningOppositeItemButton = self.rightSelectedButton;
            }
            button.isTaped = !button.isTaped;
        }
        
    }
    
    [self drawLinesBetweenSentences];
}

///设置按钮对应的LineSubjectObj对象
-(LineDualSentenceObj*)updateLineItemLineSentenceObjWithItemIndex:(int)index{
    while (YES) {
        NSLog(@"circulate///////////////////////////");
        int tempIndex = arc4random()%self.currentlineSubjectObj.lineSubjectSentenceArray.count;
        LineDualSentenceObj *sentence = [self.currentlineSubjectObj.lineSubjectSentenceArray objectAtIndex:tempIndex];
        BOOL isExist = NO;
        if (index%2 == 0) {//right
            for (LiningItemButton *button in self.rightButtonViewArray) {
                if (button.liningSentenceObj == sentence) {
                    isExist = YES;
                    break;
                }
            }
        }else{
            for (LiningItemButton *button in self.leftButtonViewArray) {
                if (button.liningSentenceObj == sentence) {
                    isExist = YES;
                    break;
                }
            }
        }
        if (!isExist) {
            return sentence;
        }
    }
    
    return nil;
}

///设置按钮的位置
-(CGRect)updateLineItemButtonFrame:(int)index{
    float drawBoardLeft = CGRectGetMinX(self.drawLinesBoardView.frame);
    float drawBoardRight = CGRectGetMaxX(self.drawLinesBoardView.frame);
    float drawBoardTop = CGRectGetMinY(self.drawLinesBoardView.frame)+50;
    float left = 0;
    float top = (BUTTON_SPACE + BUTTON_WIDTH)*(index/2)+ drawBoardTop;
    if (index%2 == 0) {
        left = drawBoardRight - BUTTON_SPACE*2 - BUTTON_WIDTH;
    }else{
        left = drawBoardLeft + BUTTON_SPACE*2;
    }
    return (CGRect){left,top,BUTTON_WIDTH,BUTTON_WIDTH};
}

///重新初始化按钮
-(void)reloadLineItemButton{
    if (!self.currentlineSubjectObj) {
        return;
    }
    for (UIView *sub in self.view.subviews) {
        if ([sub isKindOfClass:[LiningItemButton class]]) {
            [sub removeFromSuperview];
        }
    }
    [self.rightButtonViewArray removeAllObjects];
    [self.leftButtonViewArray removeAllObjects];
    [self.drawLinesBoardView redrawLinesWithLineObjArray:nil];
    for (int index = 0; index < self.currentlineSubjectObj.lineSubjectSentenceArray.count*2; index++) {
        LiningItemButton *button = [[LiningItemButton alloc] initDefaultLiningItemButton];
        button.frame = [self updateLineItemButtonFrame:index];
        button.liningSentenceObj = [self updateLineItemLineSentenceObjWithItemIndex:index];
        [button addTarget:self action:@selector(lineItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (index%2 == 0) {//right
             button.liningLocationIndex = self.rightButtonViewArray.count;
            [self.rightButtonViewArray addObject:button];
            button.isLeft = NO;
        }else{//left
             button.liningLocationIndex = self.leftButtonViewArray.count;
            [self.leftButtonViewArray addObject:button];
            button.isLeft = YES;
        }
        [self.view addSubview:button];
    }
    
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.5];
    [animation setRemovedOnCompletion:YES];
    [animation setDelegate:self];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:animation forKey:@"PushLeft"];
}

///从json文件中加载连线题数据
-(void)loadLiningSubjectsFronJsonFile{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"question.geojson" ofType:nil];
    [ParseQuestionJsonFileTool parseQuestionJsonFile:filePath withLiningSubjectArray:^(NSArray *liningSubjectArr, NSInteger specifiedTime) {
        self.liningSubjectArray = liningSubjectArr;
        [self reloadFirstLineSubject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withParseError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
    }];
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark property
-(NSMutableArray *)leftButtonViewArray{
    if (!_leftButtonViewArray) {
        _leftButtonViewArray = [NSMutableArray array];
    }
    return _leftButtonViewArray;
}

-(NSMutableArray *)rightButtonViewArray{
    if (!_rightButtonViewArray) {
        _rightButtonViewArray = [NSMutableArray array];
    }
    return _rightButtonViewArray;
}

-(NSArray *)liningSubjectArray{
    if (!_liningSubjectArray) {
        _liningSubjectArray = [NSArray array];
    }
    return _liningSubjectArray;
}

#pragma mark --

@end
