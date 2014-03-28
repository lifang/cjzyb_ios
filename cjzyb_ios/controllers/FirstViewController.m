//
//  FirstViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FirstViewController.h"

#define Head_Size 102.75
#define Insets 10
#define Label_Height 20
#define Space_head_text 23.25

#define CELL_WIDTH self.view.frame.size.width
#define FIRST_HEADER_IDENTIFIER  @"first_header"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(MessageInterface *)messageInter{
    if (!_messageInter) {
        _messageInter =[[MessageInterface alloc]init];
        _messageInter.delegate = self;
    }
    return _messageInter;
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
-(void)getMessageData {
    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        self.headerArray= nil;self.cellArray= nil;self.arrSelSection=nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.messageInter getMessageInterfaceDelegateWithClassId:[DataService sharedService].theClass.classId andUserId:[DataService sharedService].user.studentId];
//        [self.messageInter getMessageInterfaceDelegateWithClassId:@"83" andUserId:@"73"];
    }
}
-(void)textBarInit {
    self.textViewFirst.frame = CGRectMake(3, 3, 710, 44);
    [self.textBarFirst addSubview:self.textViewFirst];
    
    self.textBarFirst.frame = CGRectMake(0, self.firstTable.frame.size.height, 768, 50);
    [self.view addSubview:self.textBarFirst];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.firstTable registerClass:[FirstViewHeader class] forHeaderFooterViewReuseIdentifier:FIRST_HEADER_IDENTIFIER];

    self.isReloading = NO;
    
    [self textBarInit];
    self.first = 0;
    
    //问答之后更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFirstArrayByThirdView:) name:@"reloadFirstArrayByThirdView" object:nil];
    //取消关注之后更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFirstArrayByFourthView:) name:@"reloadFirstArrayByFourthView" object:nil];
    //删除之后更新界面
    //主
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFirstArrayHeaderBySecondView:) name:@"reloadFirstArrayHeaderBySecondView" object:nil];
    //子
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFirstArrayCellBySecondView:) name:@"reloadFirstArrayCellBySecondView" object:nil];
    [self getMessageData];
    
    //下拉刷新
    __block FirstViewController *firstView = self;
    __block UITableView *table = self.firstTable;
    [_firstTable addPullToRefreshWithActionHandler:^{
        firstView.isReloading = YES;
        [firstView getMessageData];
        [table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    int lastObject = [[[DataService sharedService].numberOfViewArray lastObject]intValue];
    
    if (lastObject==self.first) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowFirst:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHideFirst:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}
- (void)reloadFirstArrayByThirdView:(NSNotification *)notification {
    MessageObject *message = [notification object];
    [self.firstArray insertObject:message atIndex:0];
    self.headerArray= nil;self.cellArray= nil;self.arrSelSection=nil;
    
    [self.firstTable reloadData];

    for (int i=0; i<self.firstArray.count; i++) {
        FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:i];
        header.aSection =i;
    }
}

- (void)reloadFirstArrayByFourthView:(NSNotification *)notification {
    MessageObject *message = [notification object];
    
    for (int i=0; i<self.firstArray.count; i++) {
        MessageObject *msg = [self.firstArray objectAtIndex:i];
        if ([message.messageId integerValue] == [msg.messageId integerValue]) {
            msg.isFollow = NO;
            [self.firstArray replaceObjectAtIndex:i withObject:msg];
            
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:i];
            header.aMessage = msg;
            break;
        }
    }
}
- (void)reloadFirstArrayHeaderBySecondView:(NSNotification *)notification {
    MessageObject *message = [notification object];
    for (int i=0; i<self.firstArray.count; i++) {
        MessageObject *msg = [self.firstArray objectAtIndex:i];
        if ([message.messageId integerValue] == [msg.messageId integerValue]) {
            [self.firstArray removeObjectAtIndex:i];
            
            if (self.arrSelSection.count>0) {
                NSInteger section = [[self.arrSelSection objectAtIndex:0]integerValue];
                if (section == i) {
                    [self.arrSelSection removeAllObjects];
                    [self.headerArray removeAllObjects];
                }
            }
            [self.firstTable beginUpdates];
            [self.firstTable deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
            [self.firstTable endUpdates];
            for (int i=0; i<self.firstArray.count; i++) {
                FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:i];
                header.aSection =i;
            }
            break;
        }
    }
}

-(void)reloadFirstArrayCellBySecondView:(NSNotification *)notification {
    NSIndexPath *idx = [notification object];
    
    if (self.arrSelSection.count>0) {
        NSInteger section = [[self.arrSelSection objectAtIndex:0]integerValue];
        if (section == idx.section) {
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:idx.section];
            MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:idx.section];
            message.replyCount = [NSString stringWithFormat:@"%d",[message.replyCount integerValue]-1];
            [message.replyMessageArray removeObjectAtIndex:idx.row];
            header.aMessage = message;
            [self.firstTable beginUpdates];
            [self.firstTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:idx, nil] withRowAnimation:UITableViewRowAnimationFade];
            [self.firstTable endUpdates];
            [self.cellArray removeAllObjects];
            
            for (int i=0; i<message.replyMessageArray.count; i++) {
                FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:idx.section]];
                cell.aRow = i;
            }
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textViewFirst resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)firstArray {
    if (!_firstArray) {
        _firstArray = [[NSMutableArray alloc]init];
    }
    return _firstArray;
}
-(NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _cellArray;
}

-(NSMutableArray *)headerArray {
    if (!_headerArray) {
        _headerArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _headerArray;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}

-(UIActivityIndicatorView *)indicView {
    if (!_indicView) {
        _indicView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(269, 10, 30, 30)];
        _indicView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_indicView startAnimating];
    }
    return _indicView;
}

-(FocusInterface *)focusInter {
    if (!_focusInter) {
        _focusInter = [[FocusInterface alloc]init];
        _focusInter.delegate = self;
    }
    return _focusInter;
}
-(DeleteMessage *)deleteInter {
    if (!_deleteInter) {
        _deleteInter = [[DeleteMessage alloc]init];
        _deleteInter.delegate = self;
    }
    return _deleteInter;
}
-(ReplyMessageInterface *)rmessageInter {
    if (!_rmessageInter) {
        _rmessageInter = [[ReplyMessageInterface alloc]init];
        _rmessageInter.delegate = self;
    }
    return _rmessageInter;
}
-(PageMessageInterface *)pmessageInter {
    if (!_pmessageInter) {
        _pmessageInter = [[PageMessageInterface alloc]init];
        _pmessageInter.delegate = self;
    }
    return _pmessageInter;
}
-(SendMessageInterface *)sendInter {
    if (!_sendInter) {
        _sendInter = [[SendMessageInterface alloc]init];
        _sendInter.delegate = self;
    }
    return _sendInter;
}

-(NSMutableArray *)followArray {
    if (!_followArray) {
        _followArray = [[NSMutableArray alloc]init];
    }
    return _followArray;
}
#pragma mark
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 160;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:section];
    header.aSection = section;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FirstViewHeader *header = (FirstViewHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:FIRST_HEADER_IDENTIFIER];
    header.delegate = self;
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:section];
    header.aMessage = message;
    if ([message.userId integerValue] == [[DataService sharedService].user.userId integerValue]) {
        header.msgStyle = MessageCellStyleMe;
    }else {
        header.msgStyle = MessageCellStyleOther;
    }
    header.aSection = section;
    
    BOOL isSelSection = NO;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            isSelSection = YES;
            break;
        }
    }
    header.isSelected = isSelSection;

    return header;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.firstArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:section];
            ReplyMessageObject *replyMsg = (ReplyMessageObject *)[message.replyMessageArray lastObject];
            if (replyMsg.pageCountCell>replyMsg.pageCell) {//还有未加载数据
                return message.replyMessageArray.count+1;
            }else
                return message.replyMessageArray.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.section];
    if (indexPath.row<message.replyMessageArray.count) {
        return 160;
    }else {
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"firstCell";
    FirstCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FirstCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.section];
    if (indexPath.row<message.replyMessageArray.count) {
        ReplyMessageObject *replyMessage = (ReplyMessageObject *)[message.replyMessageArray objectAtIndex:indexPath.row];
        if ([replyMessage.sender_id integerValue] == [[DataService sharedService].user.userId integerValue]) {
            cell.msgStyle = ReplyMessageCellStyleMe;
        }else {
            cell.msgStyle = ReplyMessageCellStyleOther;
        }
        cell.aReplyMsg =replyMessage;
        cell.idxPath = indexPath;
        cell.isHiddenLoadButton = YES;
    }else {
        cell.isHiddenLoadButton = NO;;
    }
    
    BOOL isSelSection = NO;
    for (int i = 0; i < self.cellArray.count; i++) {
        NSIndexPath *idxPath = (NSIndexPath *)[self.cellArray objectAtIndex:i];
        if (idxPath.section==indexPath.section && idxPath.row==indexPath.row) {
            isSelSection = YES;
            break;
        }
    }
    cell.isSelected = isSelSection;
    cell.delegate = self;
    cell.aRow = indexPath.row;
    return cell;
}

-(void)initFooterView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 50)];
    header.backgroundColor = [UIColor clearColor];
    [header addSubview:self.indicView];
    UILabel *loadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.indicView.frame.origin.x+30, 10, 200, 30)];
    loadLab.text = @"正在努力加载中...";
    [header addSubview:loadLab];
    self.firstTable.tableFooterView = header;
}
//分页加载获取主消息
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        if (scrollView.contentOffset.y + self.firstTable.frame.size.height >= scrollView.contentSize.height) {
            MessageObject *message = (MessageObject *)[self.firstArray lastObject];
            if (message.pageCountHeader>message.pageHeader) {
                [self initFooterView];
                [self.firstTable setContentOffset:CGPointMake(0, scrollView.contentOffset.y+50)];
                [self.pmessageInter getPageMessageInterfaceDelegateWithClassId:[DataService sharedService].theClass.classId andUserId:[DataService sharedService].user.studentId andPage:message.pageHeader+1];
            }
        }
    }
    
}
#pragma mark
#pragma mark - FirstViewHeaderDelegate  主消息
-(void)comfirmTheCellWith:(NSInteger)aSection {
    if (self.cellArray.count > 0) {
        NSIndexPath *idx = (NSIndexPath *)[self.cellArray objectAtIndex:0];
        if (idx.section == aSection) {
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:idx];
            [cell close];
            [self.cellArray removeAllObjects];
        }
    }
}
-(void)resetTableViewHeaderByIndex:(NSInteger)theSection{
    if (self.headerArray.count > 0) {
        NSInteger aSection = [[self.headerArray objectAtIndex:0]integerValue];
        if (aSection != theSection) {
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:aSection];
            [self comfirmTheCellWith:aSection];
            [header close];
            [self.headerArray removeAllObjects];
        
            header = (FirstViewHeader *)[self.firstTable headerViewForSection:theSection];
            [header open];
            [self.headerArray addObject:[NSString stringWithFormat:@"%d",theSection]];
        }else {
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:theSection];
            [self comfirmTheCellWith:theSection];
            [header close];
            [self.headerArray removeAllObjects];
        }
    }else {
        FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:theSection];
        [header open];
        [self.headerArray addObject:[NSString stringWithFormat:@"%d",theSection]];
    }
}
//调整位置
-(void)setContentOfsetWithSection:(int)aSection {
    NSInteger rows = [self.firstTable numberOfRowsInSection:aSection];
    if(rows > 0) {
        MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:aSection];
        
        int row = 0;
        int replyMsgCount = message.replyMessageArray.count;
        if (replyMsgCount>10) {
            int left = replyMsgCount%10;
            if (left==0) {
                row = replyMsgCount-10;
            }else {
                row = replyMsgCount-left;
            }
        }
        
        [self.firstTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:aSection]
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:YES];
    }
}
- (void)contextMenuHeaderDidSelectCoverOption:(FirstViewHeader *)header{
    [self.textViewFirst resignFirstResponder];
    
    self.tmpSection = header.aSection;
    //判断打开还是关闭
    BOOL isSelSection = NO;
    if (self.arrSelSection.count>0) {
        NSString *string = [NSString stringWithFormat:@"%d",header.aSection];
        NSString *string2 = [self.arrSelSection objectAtIndex:0];
        if ([self.arrSelSection containsObject:string]) {
            isSelSection = YES;
            [self.arrSelSection removeAllObjects];
        }else {
            [self.arrSelSection removeAllObjects];
            [self resetTableViewHeaderByIndex:[string2 integerValue]];
            [self.firstTable beginUpdates];
            [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:[string2 integerValue]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.firstTable endUpdates];
        }
    }

    if (!isSelSection) {//关闭状态
        MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:header.aSection];
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",header.aSection]];
        if ([message.replyCount integerValue]>0) {//有回复的前提下
            
            if (message.replyMessageArray.count==0) {//没有回复信息
                if (self.appDel.isReachable == NO) {
                    [Utility errorAlert:@"暂无网络!"];
                }else {
                    //获取子消息
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.rmessageInter getReplyMessageInterfaceDelegateWithMessageId:message.messageId andPage:1];
                }
            }else {
                [self.firstTable beginUpdates];
                [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.firstTable endUpdates];
                
                [self resetTableViewHeaderByIndex:header.aSection];
            }
        }else {
            [self resetTableViewHeaderByIndex:header.aSection];
        }
        
    }else {//打开状态
        [self resetTableViewHeaderByIndex:header.aSection];
        [self.firstTable beginUpdates];
        [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.firstTable endUpdates];
        
    }
}
- (void)contextMenuHeaderDidSelectFocusOption:(FirstViewHeader *)header {
    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        self.tmpSection = header.aSection;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (header.aMessage.isFollow == YES) {
            [self.focusInter getFocusInterfaceDelegateWithMessageId:header.aMessage.messageId andUserId:[DataService sharedService].user.userId andType:0];
        }else {
            [self.focusInter getFocusInterfaceDelegateWithMessageId:header.aMessage.messageId andUserId:[DataService sharedService].user.userId andType:1];
        }
    }
}
//TODO:回复主消息
- (void)contextMenuHeaderDidSelectCommentOption:(FirstViewHeader *)header {
    
//    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:header.aSection];
//    if ([message.userId integerValue]==[[DataService sharedService].user.userId integerValue]) {
//        //do nothing
//    }else {
        [self.textViewFirst becomeFirstResponder];
        self.tmpSection = header.aSection;
        self.type = 1;//回复的主消息
//    }
}
- (void)contextMenuHeaderDidSelectDeleteOption:(FirstViewHeader *)header {
    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [header.superview sendSubviewToBack:header];
        self.tmpSection = header.aSection;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:header.aSection];
        [self.deleteInter getDeleteMessageDelegateDelegateWithMessageId:message.messageId andType:1];
    }
}

#pragma mark
#pragma mark - FirstCellDelegate
-(void)resetTableViewCellByIndex:(NSIndexPath *)aIndex{
    if (self.cellArray.count > 0) {
        NSIndexPath *idx = (NSIndexPath *)[self.cellArray objectAtIndex:0];
        if (idx.section!=aIndex.section || idx.row!=aIndex.row) {
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:idx];
            [cell close];
            [self.cellArray removeAllObjects];
            
            cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
            [cell open];
            [self.cellArray addObject:aIndex];
        }else {
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
            [cell close];
            [self.cellArray removeAllObjects];
        }
    }else {
        FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
        [cell open];
        [self.cellArray addObject:aIndex];
    }
}

- (void)contextMenuCellDidSelectCoverOption:(FirstCell *)cell {
    [self.textViewFirst resignFirstResponder];
    self.theIndex = [self.firstTable indexPathForCell:cell];
    [self resetTableViewCellByIndex:self.theIndex];
}
//TODO:回复子消息
- (void)contextMenuCellDidSelectCommentOption:(FirstCell *)cell {
    self.theIndex = [self.firstTable indexPathForCell:cell];
//    
//    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.theIndex.section];
//    ReplyMessageObject *replyMsg = (ReplyMessageObject *)[message.replyMessageArray objectAtIndex:self.theIndex.row];
//    if ([replyMsg.sender_id integerValue]==[[DataService sharedService].user.userId integerValue]) {
//        //do nothing
//    }else {
        [self.textViewFirst becomeFirstResponder];
        self.type = 0;//回复的子消息
//    }
}
- (void)contextMenuCellDidSelectDeleteOption:(FirstCell *)cell {
    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [cell.superview sendSubviewToBack:cell];
        self.theIndex = [self.firstTable indexPathForCell:cell];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.theIndex.section];
        ReplyMessageObject *replyMsg = (ReplyMessageObject *)[message.replyMessageArray objectAtIndex:self.theIndex.row];
        
        [self.deleteInter getDeleteMessageDelegateDelegateWithMessageId:replyMsg.micropost_id andType:0];
    }
}

//点击加载更多
- (void)contextMenuCellDidSelectLoadOption:(FirstCell *)cell {
    self.theIndex = [self.firstTable indexPathForCell:cell];
    self.tmpSection = self.theIndex.section;

    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.theIndex.section];
        
        //获取子消息
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        int page = 1;
        int replyCount = [message.replyCount integerValue];
        int replyMsgCount = message.replyMessageArray.count;
        int left_number = replyCount-replyMsgCount;
        if (left_number>0) {
            page += replyMsgCount/10;
        }
        
        [self.rmessageInter getReplyMessageInterfaceDelegateWithMessageId:message.messageId andPage:page];
    }
}
#pragma mark
#pragma mark - Keyboard notifications
- (void)keyboardWillShowFirst:(NSNotification *)notification {
    int lastObject = [[[DataService sharedService].numberOfViewArray lastObject]intValue];
    if (lastObject == self.first) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             
                             CGRect frame = keyboardRect;
                             frame.origin.y -= self.textBarFirst.frame.size.height;
                             frame.size.height = self.textBarFirst.frame.size.height;
                             self.textBarFirst.frame = frame;
                         }];
    }
}
- (void)keyboardWillHideFirst:(NSNotification *)notification {
    int lastObject = [[[DataService sharedService].numberOfViewArray lastObject]intValue];
    if (lastObject == self.first) {
        NSDictionary *userInfo = [notification userInfo];
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.textBarFirst.frame = CGRectMake(0, self.view.frame.size.height, 768, 50);
                         }];
    }
}

#pragma mark ---- 计算文本的字数
- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    NSString *string = self.textViewFirst.text;
    int wordcount = [self textLength:string];
    
	NSInteger count  = 60 - wordcount;
    if (count<0) {
        [self.textCountLabel setText:[NSString stringWithFormat:@"%i/60",60]];
    }else {
        [self.textCountLabel setText:[NSString stringWithFormat:@"%i/60",wordcount]];
    }
}

#pragma mark
#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.textViewFirst becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textViewFirst resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)_textView {
    [self calculateTextLength];
    CGSize size = self.textViewFirst.contentSize;
    size.height -= 2;
    if ( size.height >= 368 ) {
        size.height = 368;
    }
    else if ( size.height <= 44 ) {
        size.height = 44;
    }
    if ( size.height != self.textViewFirst.frame.size.height ) {
        CGFloat span = size.height - self.textViewFirst.frame.size.height;
        CGRect frame = self.textBarFirst.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        self.textBarFirst.frame = frame;

        frame = self.textViewFirst.frame;
        frame.size = size;
        self.textViewFirst.frame = frame;
        
        frame = self.textCountLabel.frame;
        frame.origin.y -= span;
        frame.size = size;
        self.textCountLabel.frame = frame;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        int wordcount = [self textLength:self.textViewFirst.text];
        if (wordcount>60) {
            [Utility errorAlert:@"最多输入60个字!"];
        }else {
            [textView resignFirstResponder];
            if (self.type == 1) {//回复的主消息
                if (self.appDel.isReachable == NO) {
                    [Utility errorAlert:@"暂无网络!"];
                }else {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.tmpSection];
                    [self.sendInter getSendDelegateWithSendId:[DataService sharedService].user.userId andSendType:@"1" andClassId:[DataService sharedService].theClass.classId andReceiverId:message.userId andReceiverType:message.userType andmessageId:message.messageId andContent:self.textViewFirst.text andType:self.type];
                }

            }else {//回复的子消息
                if (self.appDel.isReachable == NO) {
                    [Utility errorAlert:@"暂无网络!"];
                }else {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.theIndex.section];
                    ReplyMessageObject *replyMsg = (ReplyMessageObject *)[message.replyMessageArray objectAtIndex:self.theIndex.row];
                    [self.sendInter getSendDelegateWithSendId:[DataService sharedService].user.userId andSendType:@"1" andClassId:[DataService sharedService].theClass.classId andReceiverId:replyMsg.sender_id andReceiverType:replyMsg.sender_types andmessageId:message.messageId andContent:self.textViewFirst.text andType:self.type];
                }
            }
        }
        return NO;
    }
    
    return YES;
}
#pragma mark
#pragma mark - 主消息
-(void)getMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //用户
            NSDictionary *userDic = [result objectForKey:@"student"];
            [DataService sharedService].user = [UserObject userFromDictionary:userDic];
            //班级
            NSDictionary *classDic =[result objectForKey:@"class"];
            [DataService sharedService].theClass = [ClassObject classFromDictionary:classDic];
            //消息
            NSDictionary *messages = [result objectForKey:@"microposts"];
            NSArray *array = [messages objectForKey:@"details_microposts"];
            self.followArray = [NSMutableArray arrayWithArray:[result objectForKey:@"follow_microposts_id"]];
            if (array.count>0) {
                if (self.isReloading == YES) {
                    self.firstArray = nil;
                    self.isReloading = NO;
                }
                for (int i=0; i<array.count; i++) {
                    NSDictionary *aDic = [array objectAtIndex:i];
                    MessageObject *msg = [MessageObject messageFromDictionary:aDic];
                    NSNumber *msgId = [NSNumber numberWithInteger:[msg.messageId integerValue]];
                    if ([self.followArray containsObject:msgId]) {
                        msg.isFollow = YES;
                    }else {
                        msg.isFollow = NO;
                    }
                    msg.pageHeader = [[messages objectForKey:@"page"]integerValue];
                    msg.pageCountHeader = [[messages objectForKey:@"pages_count"]integerValue];
                    [self.firstArray addObject:msg];
                }
                [self.firstTable reloadData];
            }else {
                [Utility errorAlert:@"暂无数据!"];
            }
            
        });
    });
}
-(void)getMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark
#pragma mark - 分页加载主消息
-(void)getPageMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.firstTable.tableFooterView = nil;
            //消息
            NSDictionary *messages = [result objectForKey:@"microposts"];
            NSArray *array = [messages objectForKey:@"details_microposts"];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *aDic = [array objectAtIndex:i];
                    MessageObject *msg = [MessageObject messageFromDictionary:aDic];
                    msg.pageHeader = [[messages objectForKey:@"page"]integerValue];
                    msg.pageCountHeader = [[messages objectForKey:@"pages_count"]integerValue];
                    [self.firstArray addObject:msg];
                }
            }
            [self.firstTable reloadData];
        });
    });
}
-(void)getPageMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}


#pragma mark
#pragma mark - 子消息
-(void)getReplyMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *aDic = [result objectForKey:@"reply_microposts"];
            
            NSArray *array = [aDic objectForKey:@"reply_microposts"];
            MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.tmpSection];
            if ([message.replyCount integerValue]<=10) {
                message.replyMessageArray = [[NSMutableArray alloc]init];
            }
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    ReplyMessageObject *replyMsg = [ReplyMessageObject replyMessageFromDictionary:dic];
                    replyMsg.pageCell = [[aDic objectForKey:@"page"]integerValue];
                    replyMsg.pageCountCell = [[aDic objectForKey:@"pages_count"]integerValue];
                    [message.replyMessageArray addObject:replyMsg];
                }
                [self.firstTable beginUpdates];
                [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:self.tmpSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.firstTable endUpdates];
            }
            [self.headerArray removeAllObjects];
            [self resetTableViewHeaderByIndex:self.tmpSection];
            
            [self setContentOfsetWithSection:self.tmpSection];
        });
    });
}
-(void)getReplyMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark
#pragma mark - 关注
-(void)getFocusInfoDidFinished:(NSDictionary *)result andType:(NSInteger)type{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:self.tmpSection];
            MessageObject *message = header.aMessage;
            if (type == 0) {
                message.followCount = [NSString stringWithFormat:@"%d",[message.followCount integerValue]-1];
                message.isFollow = NO;
                NSNumber *followNum = [NSNumber numberWithInteger:[header.aMessage.messageId integerValue]];
                
                for (NSNumber *number in self.followArray) {
                    if ([number integerValue] == [followNum integerValue]) {
                        [self.followArray removeObject:number];
                        break;
                    }
                }
            }else{
                message.followCount = [NSString stringWithFormat:@"%d",[message.followCount integerValue]+1];
                message.isFollow = YES;
                
                [self.followArray addObject:[NSNumber numberWithInteger:[header.aMessage.messageId integerValue]]];
            }
            header.aMessage = message;
            
        });
    });
}
-(void)getFocusInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark
#pragma mark - 删除

-(void)getDeleteMsgInfoDidFinished:(NSDictionary *)result andType:(NSInteger)type{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (type==1) {
                [self.arrSelSection removeAllObjects];
                [self.firstArray removeObjectAtIndex:self.tmpSection];
                [self.firstTable beginUpdates];
                [self.firstTable deleteSections:[NSIndexSet indexSetWithIndex:self.tmpSection] withRowAnimation:UITableViewRowAnimationFade];
                [self.firstTable endUpdates];
                for (int i=0; i<self.firstArray.count; i++) {
                    FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:i];
                    header.aSection =i;
                }
                [self.headerArray removeAllObjects];
            }else {
                FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:self.theIndex.section];
                MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.theIndex.section];
                message.replyCount = [NSString stringWithFormat:@"%d",[message.replyCount integerValue]-1];
                [message.replyMessageArray removeObjectAtIndex:self.theIndex.row];
                header.aMessage = message;
                
                [self.firstTable beginUpdates];
                [self.firstTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.theIndex, nil] withRowAnimation:UITableViewRowAnimationFade];
                [self.firstTable endUpdates];
                [self.cellArray removeAllObjects];
                
                for (int i=0; i<message.replyMessageArray.count; i++) {
                    FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:self.theIndex.section]];
                    cell.aRow = i;
                }
            }
        });
    });
}
-(void)getDeleteMsgInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark
#pragma mark - 回复
-(void)getSendInfoDidFinished:(NSDictionary *)result anType:(NSInteger)type{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.textViewFirst.text = @"";self.textCountLabel.text = @"0/60";
            if (type==1) {//回复的主消息
                NSArray *array = [result objectForKey:@"replymicropost"];
                NSDictionary *dic = [array objectAtIndex:0];
                ReplyMessageObject *replyMsg = [ReplyMessageObject replyMessageFromDictionary:dic];
                FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:self.tmpSection];
                MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.tmpSection];
                message.replyCount = [NSString stringWithFormat:@"%d",[message.replyCount integerValue]+1];
                [message.replyMessageArray insertObject:replyMsg atIndex:0];
                header.aMessage = message;
                if ([message.replyCount integerValue]==1) {
                    [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",self.tmpSection]];
                    [self.firstTable beginUpdates];
                    [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:self.tmpSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.firstTable endUpdates];
                }else {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:self.tmpSection];
                    [self.firstTable beginUpdates];
                    [self.firstTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationFade];
                    [self.firstTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.firstTable endUpdates];
                }
                for (int i=0; i<message.replyMessageArray.count; i++) {
                    FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:self.tmpSection]];
                    cell.aRow = i;
                }
                
            }else {//回复的子消息
                NSArray *array = [result objectForKey:@"replymicropost"];
                NSDictionary *dic = [array objectAtIndex:0];
                ReplyMessageObject *replyMsg = [ReplyMessageObject replyMessageFromDictionary:dic];
                FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:self.theIndex.section];
                MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.theIndex.section];
                message.replyCount = [NSString stringWithFormat:@"%d",[message.replyCount integerValue]+1];
                [message.replyMessageArray insertObject:replyMsg atIndex:0];
                header.aMessage = message;
                [self.cellArray removeAllObjects];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:self.theIndex.section];
                [self.firstTable beginUpdates];
                [self.firstTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationFade];
                [self.firstTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.firstTable endUpdates];
                
                for (int i=0; i<message.replyMessageArray.count; i++) {
                    FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:self.theIndex.section]];
                    cell.aRow = i;
                }
                
                index = [NSIndexPath indexPathForRow:self.theIndex.row+1 inSection:self.theIndex.section];
                [self.cellArray addObject:index];
                [self resetTableViewCellByIndex:index];
            }
        });
    });
}
-(void)getSendInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
