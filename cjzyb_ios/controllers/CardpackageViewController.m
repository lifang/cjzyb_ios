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
        [self.cardInter getCardInterfaceDelegateWithStudentId:[DataService sharedService].user.studentId andClassId:[DataService sharedService].theClass.classId andType:@"0"];
    }
}

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(IBAction)refreshCardPackageData:(id)sender {
    [self.defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.defaultBtn setBackgroundColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1]];
    [self getCardData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.typeArray = [NSArray arrayWithObjects:@"默认",@"默认",@"听写",@"朗读",@"十速",@"选择",@"连线",@"完型",@"排序", nil];
    
    [self getCardData];
    self.myScrollView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.myPageControl = [[MyPageControl alloc]initWithFrame:CGRectMake(0, 920, 768, 30)];
    self.myPageControl.backgroundColor = [UIColor clearColor];
    [self.myPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.myPageControl];
    
    //翻页之后停止播放声音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePlayerByView:) name:@"changePlayerByView" object:nil];
    
    
    [self.pullTable.layer setCornerRadius:8.0f];
    [self.pullTable.layer setMasksToBounds:YES];
    
    [self.defaultBtn.layer setCornerRadius:8.0f];
    [self.defaultBtn.layer setMasksToBounds:YES];
    [self.defaultBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
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
    NSInteger postStr = [[notification object]integerValue];
    if (postStr>=0) {
        if (self.arrSelSection.count>0) {
            NSInteger tmpTag = [[self.arrSelSection objectAtIndex:0]integerValue];
            if (postStr == tmpTag) {
                [self stop];
            }
        }
    }else {
        if (self.arrSelSection.count>0) {
            [self stop];
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
        self.myPageControl.numberOfPages = 0;
        [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.pullTable]) {
        if (dropDown1Open) {
            return 9;
        }
        else
        {
            return 1;
        }
    }else
        return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.pullTable]){
        return 44;
    }else
        return 360;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.pullTable]) {
        static NSString *CellIdentifier = @"Cell";
        static NSString *DropDownCellIdentifier = @"DropDownCell";
        if(indexPath.row==0) {
            DropDownCell *cell = (DropDownCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[DropDownCell class]])
                    {
                        cell = (DropDownCell *)currentObject;
                        cell.backgroundColor = [UIColor clearColor];
                        cell.contentView.backgroundColor = [UIColor clearColor];
                        break;
                    }
                }
            }
            
            [[cell textLabel] setText:@"默认"];
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            NSString *label = [NSString stringWithFormat:@"%@", [self.typeArray objectAtIndex:indexPath.row]];
            [[cell textLabel] setText:label];
            return cell;
        }
    }else {
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path0 = [NSIndexPath indexPathForRow:1 inSection:[indexPath section]];
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:2 inSection:[indexPath section]];
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:3 inSection:[indexPath section]];
    NSIndexPath *path3 = [NSIndexPath indexPathForRow:4 inSection:[indexPath section]];
    NSIndexPath *path4 = [NSIndexPath indexPathForRow:5 inSection:[indexPath section]];
    NSIndexPath *path5 = [NSIndexPath indexPathForRow:6 inSection:[indexPath section]];
    NSIndexPath *path6 = [NSIndexPath indexPathForRow:7 inSection:[indexPath section]];
    NSIndexPath *path7 = [NSIndexPath indexPathForRow:8 inSection:[indexPath section]];
    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2,path3,path4,path5,path6,path7, nil];
    
    if ([tableView isEqual:self.pullTable]){
        if(indexPath.row==0) {
            
            DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:indexPath];
            if ([cell isOpen]){
                [UIView animateWithDuration:0.25 animations:^{
                    [cell setClosed];
                    dropDown1Open = [cell isOpen];
                    [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                } completion:^(BOOL finished){
                    CGRect frame = self.pullTable.frame;
                    frame.size.height = 44;
                    self.pullTable.frame = frame;
                }];
            }
            else{
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect frame = self.pullTable.frame;
                    frame.size.height = 396;
                    self.pullTable.frame = frame;
                } completion:^(BOOL finished){
                    [cell setOpen];
                    dropDown1Open = [cell isOpen];
                    [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            }
        }
        else{
            NSString* dropDown1 = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
            DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:path];
            [[cell textLabel] setText:dropDown1];
            
            CGRect frame = self.pullTable.frame;
            frame.size.height = 44;
            self.pullTable.frame = frame;
            [cell setClosed];
            dropDown1Open = [cell isOpen];
            [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            
            [self.searchTxt resignFirstResponder];
            self.cardArray = nil;
            int number = [self.typeArray indexOfObject:dropDown1];
            
            if (number==0 || number==1) {
                self.cardArray = [NSMutableArray arrayWithArray:self.dataArray];
            }else {
                for (CardObject *card in self.dataArray) {
                    if ([card.types integerValue] == (number-2)) {
                        [self.cardArray addObject:card];
                    }
                }
            }
            tmpPage = 0;
            [self displayNewView];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"CardCustomView" owner:self options:nil];
    CardCustomView *cView = (CardCustomView *)[viewArray objectAtIndex:0];
    cView.tag = currentTag;
    cView.aCard = aCard;
    cView.viewtag = currentTag;
    cView.delegate = self;
    
    cView.frame = CGRectMake(34.67+(332+34.67)*col, 14, 332, 332);
    [cell.contentView addSubview:cView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.myScrollView.frame.size.width;
    int page = floor((self.myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
    tmpPage = page;
}
#pragma mark  --
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
    NSString *str = self.searchTxt.text;
    str = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (str.length==0) {
        [Utility errorAlert:@"搜索内容不能为空!"];
    }else {
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
}
//点击键盘return键搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnTapped:nil];
    return YES;
}

#pragma mark
#pragma mark - CardInterfaceDelegate
-(void)getCardInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.defaultBtn setTitleColor:[UIColor colorWithRed:63/255.0 green:72/255.0 blue:83/255.0 alpha:1] forState:UIControlStateNormal];
            [self.defaultBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
            
            NSArray *array = [result objectForKey:@"knowledges_card"];
            self.cardArray = nil;[[CMRManager sharedService] Reset];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    CardObject *card = [CardObject cardFromDictionary:dic];
                    
                    if ([card.types integerValue]==5) {
                        [[CMRManager sharedService] AddContact:[card.carId intValue] name:card.full_text phone:nil];
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
    [self.defaultBtn setTitleColor:[UIColor colorWithRed:63/255.0 green:72/255.0 blue:83/255.0 alpha:1] forState:UIControlStateNormal];
    [self.defaultBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [Utility errorAlert:errorMsg];
}

#pragma mark 
#pragma mark - 第二个页面
-(void)myMovieStartPlay:(NSNotification*)notify {
    [MBProgressHUD hideAllHUDsForView:self.appDel.window animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerLoadStateDidChangeNotification
                                                  object:self.appDel.player];
}
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.appDel.player];
    
    [self.appDel.player stop];
    self.appDel.player = nil;
    [self.arrSelSection removeAllObjects];
}


-(void)playWithTag:(NSInteger)tag {
    [MBProgressHUD showHUDAddedTo:self.appDel.window animated:YES];
    CardObject *card = [self.cardArray objectAtIndex:tag];
    
    NSURL *url;
    int type = [card.types integerValue];
    if (type==3) {
        NSArray *array = [card.content componentsSeparatedByString:@"</file>"];
        NSString *title_sub  =[array objectAtIndex:0];
        NSString *title=[title_sub stringByReplacingOccurrencesOfString:@"<file>" withString:@""];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHOST,title]];
    }else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHOST,card.resource_url]];
    }
    
    self.appDel.player = nil;
    self.appDel.player = [[MPMoviePlayerController alloc]
                          initWithContentURL:url];
    [self.appDel.player play];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.appDel.player];
    //开始阶段的缓冲到准备完毕
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieStartPlay:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:self.appDel.player];
    
    [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",tag]];
}
-(void)stop {
    [self.appDel.player stop];
    self.appDel.player = nil;
    [self.arrSelSection removeAllObjects];
}
-(void)pressedVoiceBtn:(UIButton *)btn {
    if (self.arrSelSection.count>0) {
        NSInteger tmpTag = [[self.arrSelSection objectAtIndex:0]integerValue];
        if (tmpTag == btn.tag) {
            [self stop];
        }else {
            [self.appDel.player stop];
            [self.arrSelSection removeAllObjects];
            [self playWithTag:btn.tag];
        }
    }else {
        [self playWithTag:btn.tag];
    }
}

static NSInteger temButtonTag = -1;

-(void)pressedDeleteBtn:(UIButton *)btn {
    temButtonTag = btn.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确认删除卡片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (buttonIndex==1) {
        if (self.appDel.isReachable == NO) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            CardObject *card = [self.cardArray objectAtIndex:temButtonTag];
            [self.deleteInter getDeleteCardDelegateDelegateWithCardId:card.carId andTag:temButtonTag];
        }
    }
}
-(void)pressedShowFullText:(NSString *)fullText andBtn:(UIButton *)btn {
    
    self.fullTextView = [[FullText alloc]initWithNibName:@"FullText" bundle:nil];
    [self.fullTextView setText:fullText];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    __block UIBarButtonItem *barItemm = barItem;
    self.poprController = [[WYPopoverController alloc] initWithContentViewController:self.fullTextView];
    self.poprController.delegate = self;
    self.poprController.theme.tintColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillTopColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillBottomColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.glossShadowColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.popoverContentSize = (CGSize){332,300};
    [self.poprController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        barItemm=nil;
    }];
}
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
    [self.fullTextView.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.fullTextView = nil;
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

@end
