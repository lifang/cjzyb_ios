//
//  CardpackageViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardpackageViewController.h"
@interface CardpackageViewController ()
@property (nonatomic,strong) WYPopoverController *poprController;
@end

#define TableTag 100999
static NSInteger tmpPage = 0;
@implementation CardpackageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)getCardData {
    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.cardInter getCardInterfaceDelegateWithStudentId:[DataService sharedService].user.studentId andClassId:[DataService sharedService].theClass.classId andType:@"4"];
    }
}

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(IBAction)refreshCardPackageData:(id)sender {
    [self getCardData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"卡包";
    
    [self getCardData];
    self.myScrollView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.myPageControl = [[MyPageControl alloc]initWithFrame:CGRectMake(0, 920, 768, 30)];
    self.myPageControl.backgroundColor = [UIColor clearColor];
    [self.myPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.myPageControl];
    
    //翻页之后停止播放声音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayerByView:) name:@"changePlayerByView" object:nil];
    //选择或者取消标签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTagByView:) name:@"changeTagByView" object:nil];
}
-(void)changePage:(id)sender {
    int whichPage = self.myPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.myScrollView setContentOffset:CGPointMake(768 * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
}
- (void)changePlayerByView:(NSNotification *)notification {
    NSString *postStr = [notification object];
    if (self.arrSelSection.count>0) {
        NSInteger tmpTag = [[self.arrSelSection objectAtIndex:0]integerValue];
        if ([postStr integerValue] == tmpTag) {
            [self stop];
        }
    }
}

- (void)changeTagByView:(NSNotification *)notification {
    CardObject *card = [notification object];
    
    NSInteger card_Id = [card.carId integerValue];
    
    for (int i=0; i<self.dataArray.count; i++) {
        CardObject *card2 = [self.dataArray objectAtIndex:i];
        if ([card2.carId integerValue]==card_Id){
            [self.dataArray replaceObjectAtIndex:i withObject:card];
        }
    }
    
    for (int i=0; i<self.cardArray.count; i++) {
        CardObject *card2 = [self.cardArray objectAtIndex:i];
        if ([card2.carId integerValue]==card_Id) {
            
            if (card2.tagArray.count>0) {
                NSMutableArray *tmpArray = [self compareArray:[DataService sharedService].tagsArray array:card2.tagArray];
                [[CMRManager sharedService] DeleteContact:[card2.carId intValue]];
                [[CMRManager sharedService] AddContact:[card2.carId intValue] name:card2.content phone:tmpArray];
            }else {
                [[CMRManager sharedService] DeleteContact:[card2.carId intValue]];
                [[CMRManager sharedService] AddContact:[card2.carId intValue] name:card2.content phone:nil];
            }
            
            [self.cardArray replaceObjectAtIndex:i withObject:card];
            
            NSInteger tag = i/4+TableTag;
            UITableView *table = (UITableView *)[self.myScrollView viewWithTag:tag];
            NSInteger section = 0;
            if (i%4==0 || i%4==1) {
                section=0;
            }else if (i%4==2 || i%4==3){
                section = 1;
            }

            NSIndexPath *idPath = [NSIndexPath indexPathForRow:section inSection:0];
            UITableViewCell *cell = [table cellForRowAtIndexPath:idPath];

            NSArray *subViews = [cell.contentView subviews];
            for (UIView *vv in subViews) {
                if ([vv isKindOfClass:[CardCustomView class]] && vv.tag==i) {
                    CardCustomView *cardCustom = (CardCustomView *)vv;
                    [cardCustom.cardFirst setTagNameArray:card.tagArray];
                }
            }
            
            break;
        }
    }
}
-(NSMutableArray *)cardArray {
    if (!_cardArray) {
        _cardArray = [[NSMutableArray alloc]init];
    }
    return _cardArray;
}
-(CardInterface *)cardInter {
    if (!_cardInter) {
        _cardInter = [[CardInterface alloc]init];
        _cardInter.delegate = self;
    }
    return _cardInter;
}
-(DeleteCardInterface *)deleteInter {
    if (!_deleteInter) {
        _deleteInter = [[DeleteCardInterface alloc]init];
        _deleteInter.delegate = self;
    }
    return _deleteInter;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - 设置页面

-(void)displayNewView {
    if (self.cardArray.count>0) {
        [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSInteger count = ([self.cardArray count]-1)/4+1;
        self.myPageControl.numberOfPages = count;
        
        self.myScrollView.contentSize = CGSizeMake(768*count, self.myScrollView.frame.size.height);
        for (int i=0; i<count; i++) {
            self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(768*i, 0, 768, self.myScrollView.frame.size.height)];
            self.myTable.tag = i+TableTag;
            self.myTable.delegate = self;
            self.myTable.dataSource = self;
            self.myTable.scrollEnabled = NO;
            self.myTable.backgroundColor = [UIColor clearColor];
            [self.myScrollView addSubview:self.myTable];
        }
        if (count<=tmpPage) {
            self.myPageControl.currentPage = count;
            [self.myScrollView setContentOffset:CGPointMake((count-1)*768, 0)];
        }else {
            self.myPageControl.currentPage = tmpPage;
            [self.myScrollView setContentOffset:CGPointMake(tmpPage*768, 0)];
        }
    }else {
        [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = ([self.cardArray count]-1)/4+1;
    static NSString *CellIdentifier = @"Cellcard";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i<count; i++) {
            if ((tableView.tag-TableTag)==i) {
                [self drawTableViewCell:cell index:[indexPath row] category:i];
            }
        }
	}
    
    return cell;
}

//绘制tableview的cell
-(void)drawTableViewCell:(UITableViewCell *)cell index:(int)row category:(int)category{
    int maxIndex = (row*2+1);
    int number = [self.cardArray count]-4*category;
	if(maxIndex < number) {
		for (int i=0; i<2; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-1 < number) {
			[self displayPhotoes:cell row:row col:0 category:category];
		return;
	}
}
-(void)displayPhotoes:(UITableViewCell *)cell row:(int)row col:(int)col category:(int)category
{
    NSInteger currentTag = 2*row+col+category*4;
    
    CardObject *aCard = (CardObject *)[self.cardArray objectAtIndex:currentTag];
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"CardFirstView" owner:self options:nil];
    CardFirstView *cardFirst = (CardFirstView *)[viewArray objectAtIndex:0];
    
    viewArray = [[NSBundle mainBundle] loadNibNamed:@"CardSecondView" owner:self options:nil];
    CardSecondView *cardSecond = (CardSecondView *)[viewArray objectAtIndex:0];
    
    CardCustomView *cView = [[CardCustomView alloc]initWithFrame:CGRectMake(34.67+(332+34.67)*col, 14, 332, 332) andFirst:cardFirst andSecond:cardSecond andObj:aCard];
    cView.viewtag = currentTag;
    cView.tag = currentTag;
    cView.cardFirst.delegate = self;
    cView.cardSecond.delegate = self;
    [cell.contentView addSubview:cView];
}

-(void)selectedCardView:(id)sender {
    CardCustomView *control = (CardCustomView *)sender;
    [control flipTouched];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.myScrollView.frame.size.width;
    int page = floor((self.myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
    tmpPage = page;
}
#pragma mark
#pragma mark - 选择分类

- (IBAction)redBtnTapped:(id)sender//0
{
    [self.searchTxt resignFirstResponder];
    self.cardArray = nil;
    if (self.dataArray.count>0) {
        for (CardObject *card in self.dataArray) {
            if (card.mistake_types == 0) {
                [self.cardArray addObject:card];
            }
        }
    }
    tmpPage = 0;
    [self displayNewView];
    
}
- (IBAction)writeBtnTapped:(id)sender//1
{
    [self.searchTxt resignFirstResponder];
    self.cardArray = nil;
    if (self.dataArray.count>0) {
        for (CardObject *card in self.dataArray) {
            if (card.mistake_types == 1) {
                [self.cardArray addObject:card];
            }
        }
    }
    tmpPage = 0;
    [self displayNewView];
}
- (IBAction)selectedBtnTapped:(id)sender//2
{
    [self.searchTxt resignFirstResponder];
    self.cardArray = nil;
    if (self.dataArray.count>0) {
        for (CardObject *card in self.dataArray) {
            if (card.mistake_types == 2) {
                [self.cardArray addObject:card];
            }
        }
    }
    tmpPage = 0;
    [self displayNewView];
}
- (IBAction)defaultBtnTapped:(id)sender//3
{
    [self.searchTxt resignFirstResponder];
    self.cardArray = [NSMutableArray arrayWithArray:self.dataArray];
    tmpPage = 0;
    [self displayNewView];
}
-(NSMutableArray *)getDatafromArray:(NSMutableArray *)array1 array:(NSMutableArray *)array2 {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if (array1.count>0) {
        for (NSString *str in array1) {
            if (![tempArray containsObject:str]) {
                [tempArray addObject:str];
            }
        }
    }
    
    if (array2.count>0) {
        for (NSString *str in array2) {
            if (![tempArray containsObject:str]) {
                [tempArray addObject:str];
            }
        }
    }
    
    return tempArray;
}
- (IBAction)searchBtnTapped:(id)sender
{
    [self.searchTxt resignFirstResponder];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray2 = [[NSMutableArray alloc]init];
    self.cardArray = nil;
    [[CMRManager sharedService] Search:self.searchTxt.text searchArray:nil nameMatch:tempArray phoneMatch:tempArray2];;
    
    NSMutableArray *tmpArr = [self getDatafromArray:tempArray array:tempArray2];
    if (tmpArr.count>0) {
        for (int i=0; i<tmpArr.count; i++) {
            NSInteger c_id = [[tmpArr objectAtIndex:i]integerValue];
            
            for (CardObject *card in self.dataArray) {
                if ([card.carId integerValue] == c_id) {
                    [self.cardArray addObject:card];
                }
            }
        }
    }
    tmpPage = 0;
    [self displayNewView];
    tempArray = nil;tempArray2 = nil;
}
#pragma mark
#pragma mark - CardInterfaceDelegate
-(NSMutableArray *)compareArray:(NSMutableArray *)array1 array:(NSMutableArray *)array2 {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<array1.count; i++) {
        TagObject *tagObj = (TagObject *)[array1 objectAtIndex:i];
        for (int k=0; k<array2.count; k++) {
            NSInteger t_id = [[array2 objectAtIndex:k]integerValue];
            if ([tagObj.tagId integerValue]==t_id) {
                [tempArray addObject:tagObj.tagName];
            }
        }
    }
    
    return tempArray;
}
-(void)getCardInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSArray *arrayTag = [result objectForKey:@"tags"];
            [DataService sharedService].tagsArray = [[NSMutableArray alloc]init];
            if (arrayTag.count>0) {
                for (int i=0; i<arrayTag.count; i++) {
                    NSDictionary *dic = [arrayTag objectAtIndex:i];
                    TagObject *tagObj = [TagObject tagFromDictionary:dic];
                    [[DataService sharedService].tagsArray addObject:tagObj];
                }
            }
            
            NSArray *array = [result objectForKey:@"knowledges_card"];
            self.cardArray = nil;[[CMRManager sharedService] Reset];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    CardObject *card = [CardObject cardFromDictionary:dic];
                    
                    if (card.tagArray.count>0) {
                        NSMutableArray *tmpArray = [self compareArray:[DataService sharedService].tagsArray array:card.tagArray];
                        [[CMRManager sharedService] AddContact:[card.carId intValue] name:card.content phone:tmpArray];
                    }else {
                        [[CMRManager sharedService] AddContact:[card.carId intValue] name:card.content phone:nil];
                    }
                    
                    [self.cardArray addObject:card];
                    
                }
                self.dataArray = [[NSMutableArray alloc]initWithArray:self.cardArray];
                [self displayNewView];
            }
        });
    });
}
-(void)getCardInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark 
#pragma mark - 第二个页面
-(void)playWithTag:(NSInteger)tag {
    CardObject *card = [self.cardArray objectAtIndex:tag];
    
    self.appDel.player = nil;
    self.appDel.player = [[MPMoviePlayerController alloc]
                          initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHOST,card.resource_url]]];
    [self.appDel.player play];
    [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",tag]];
}
-(void)stop {
    [self.appDel.player stop];
    self.appDel.player = nil;
    [self.arrSelSection removeAllObjects];
}
-(void)pressedVoiceBtn:(UIButton *)btn {
    NSLog(@"tag = %d",btn.tag);
    
    if (self.arrSelSection.count>0) {
        NSInteger tmpTag = [[self.arrSelSection objectAtIndex:0]integerValue];
        if (tmpTag == btn.tag) {
            [self stop];
        }else {
            [self playWithTag:btn.tag];
        }
    }else {
        [self playWithTag:btn.tag];
    }
}
-(void)pressedDeleteBtn:(UIButton *)btn {
    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        CardObject *card = [self.cardArray objectAtIndex:btn.tag];
        [self.deleteInter getDeleteCardDelegateDelegateWithCardId:card.carId andTag:btn.tag];
    }
}
#pragma mark
#pragma mark - DeleteCardInterfaceDelegate
-(void)getDeleteCardInfoDidFinished:(NSDictionary *)result andTag:(NSInteger)tag{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            CardObject *card = [self.cardArray objectAtIndex:tag];
            [[CMRManager sharedService]DeleteContact:[card.carId intValue]];
            for (CardObject *card2 in self.dataArray) {
                if ([card.carId integerValue] == [card2.carId integerValue]) {
                    [self.dataArray removeObject:card2];
                    break;
                }
            }
            [self.cardArray removeObjectAtIndex:tag];
            [DataService sharedService].cardsCount -= 1;
            [self displayNewView];
        });
    });
}
-(void)getDeleteCardInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark
#pragma mark - 第一个页面
-(void)pressedTxtBtn:(UIButton *)btn {
    CardObject *card = [self.cardArray objectAtIndex:btn.tag];
    TagViewController *tagView = [[TagViewController alloc]initWithNibName:@"TagViewController" bundle:nil];
    tagView.tagArray = [DataService sharedService].tagsArray;
    tagView.filteredArray = [DataService sharedService].tagsArray;
    tagView.aCard = card;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    __block UIBarButtonItem *barItemm = barItem;
    self.poprController = [[WYPopoverController alloc] initWithContentViewController:tagView];
    self.poprController.theme.tintColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillTopColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillBottomColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.glossShadowColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.popoverContentSize = (CGSize){265,263};
    [self.poprController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        barItemm=nil;
    }];
}
@end
