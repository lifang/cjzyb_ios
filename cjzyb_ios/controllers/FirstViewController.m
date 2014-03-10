//
//  FirstViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FirstViewController.h"

#define Head_Size 80.0
#define Insets 10
#define Label_Height 20
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

-(void)getMessageData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MessageInterface *log = [[MessageInterface alloc]init];
    self.messageInter = log;
    self.messageInter.delegate = self;
    [self.messageInter getMessageInterfaceDelegateWithClassId:@"83" andUserId:@"73"];
}
-(void)textBarInit {
    self.keyboardHeight = -46;
    
    self.textView.frame = CGRectMake(3, 3, 762, 44);
    [self.textBar addSubview:self.textView];
    
    self.textBar.frame = CGRectMake(0, self.view.frame.size.height, 768, 50);
    [self.view addSubview:self.textBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.firstTable registerClass:[FirstViewHeader class] forHeaderFooterViewReuseIdentifier:FIRST_HEADER_IDENTIFIER];

    [self getMessageData];
    [self textBarInit];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
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
-(NSMutableArray *)deleteArray {
    if (!_deleteHeaderArray) {
        _deleteHeaderArray = [[NSMutableArray alloc]init];
    }
    return _deleteHeaderArray;
}
-(NSMutableArray *)headerArray {
    if (!_headerArray) {
        _headerArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _headerArray;
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
-(SendMessageInterface *)sendInter {
    if (!_sendInter) {
        _sendInter = [[SendMessageInterface alloc]init];
        _sendInter.delegate = self;
    }
    return _sendInter;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}
-(NSMutableArray *)followArray {
    if (!_followArray) {
        _followArray = [[NSMutableArray alloc]init];
    }
    return _followArray;
}
#pragma mark
#pragma mark - UITableViewDelegate

-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:18];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(CELL_WIDTH-Insets*4-Head_Size, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:section];
    CGSize size = [self getSizeWithString:message.messageContent];
    return Insets*6+Label_Height+size.height;
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
            return message.replyMessageArray.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.section];
    ReplyMessageObject *replyMessage = (ReplyMessageObject *)[message.replyMessageArray objectAtIndex:indexPath.row];
    CGSize size = [self getSizeWithString:replyMessage.content];
    return Insets*6+Label_Height+size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"firstCell%d";
    FirstCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FirstCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.section];
    ReplyMessageObject *replyMessage = (ReplyMessageObject *)[message.replyMessageArray objectAtIndex:indexPath.row];
    if ([replyMessage.sender_id integerValue] == [[DataService sharedService].user.userId integerValue]) {
        cell.msgStyle = ReplyMessageCellStyleMe;
    }else {
        cell.msgStyle = ReplyMessageCellStyleOther;
    }
    cell.aReplyMsg =replyMessage;
    cell.idxPath = indexPath;
    cell.delegate = self;
    cell.isSelected = NO;
    return cell;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.firstTable numberOfRowsInSection:self.tmpSection];
    if(rows > 0) {
        [self.firstTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:self.tmpSection]
                                   atScrollPosition:UITableViewScrollPositionBottom
                                           animated:animated];
    }
}
#pragma mark
#pragma mark - FirstViewHeaderDelegate  主消息

-(void)resetTableViewHeaderByIndex:(NSInteger)theSection{
    if (self.headerArray.count > 0) {
        NSInteger aSection = [[self.headerArray objectAtIndex:0]integerValue];
        if (aSection != theSection) {
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:aSection];
            [header close];
            [self.headerArray removeAllObjects];
            
            header = (FirstViewHeader *)[self.firstTable headerViewForSection:theSection];
            [header open];
            [self.headerArray addObject:[NSString stringWithFormat:@"%d",theSection]];
        }else {
            FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:theSection];
            [header close];
            [self.headerArray removeAllObjects];
        }
    }else {
        FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:theSection];
        [header open];
        [self.headerArray addObject:[NSString stringWithFormat:@"%d",theSection]];
    }
}
- (void)contextMenuHeaderDidSelectCoverOption:(FirstViewHeader *)header{
    [self.textView resignFirstResponder];
    
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
            [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:[string2 integerValue]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self resetTableViewHeaderByIndex:[string2 integerValue]];
        }
    }

    if (!isSelSection) {//关闭状态
        MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:header.aSection];
        if ([message.replyCount integerValue]>0) {//有回复的前提下
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",header.aSection]];
            if (message.replyMessageArray.count==0) {//没有回复信息
                //获取子消息
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                ReplyMessageInterface *log = [[ReplyMessageInterface alloc]init];
                self.rmessageInter = log;
                self.rmessageInter.delegate = self;
                [self.rmessageInter getReplyMessageInterfaceDelegateWithMessageId:message.messageId andPage:1];
            }else {
                
                [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self resetTableViewHeaderByIndex:header.aSection];
                [self scrollToBottomAnimated:YES];
            }
        }else {
            [self resetTableViewHeaderByIndex:header.aSection];
        }
        
    }else {//打开状态
        [self resetTableViewHeaderByIndex:header.aSection];
        [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
- (void)contextMenuHeaderDidSelectFocusOption:(FirstViewHeader *)header {
    self.tmpSection = header.aSection;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (header.aMessage.isFollow == YES) {
        [self.focusInter getFocusInterfaceDelegateWithMessageId:header.aMessage.messageId andUserId:header.aMessage.userId andType:0];
    }else {
        [self.focusInter getFocusInterfaceDelegateWithMessageId:header.aMessage.messageId andUserId:header.aMessage.userId andType:1];
    }
}

- (void)contextMenuHeaderDidSelectCommentOption:(FirstViewHeader *)header {
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:header.aSection];
    if ([message.userId integerValue]==[[DataService sharedService].user.userId integerValue]) {
        //do nothing
    }else {
        [self.textView becomeFirstResponder];
        self.tmpSection = header.aSection;
        self.type = 1;//回复的主消息
    }
}
- (void)contextMenuHeaderDidSelectDeleteOption:(FirstViewHeader *)header {
    [header.superview sendSubviewToBack:header];
    self.tmpSection = header.aSection;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:header.aSection];
    [self.deleteInter getDeleteMessageDelegateDelegateWithMessageId:message.messageId];
}

#pragma mark
#pragma mark - FirstCellDelegate
-(void)tableViewReload {
    [self.firstTable reloadData];
}
-(void)resetTableViewCellByIndex:(NSIndexPath *)aIndex{
    if (self.cellArray.count > 0) {
        NSInteger aRow = [[self.cellArray objectAtIndex:0]integerValue];
        if (aRow != aIndex.row) {
            NSIndexPath *idx = [NSIndexPath indexPathForRow:aRow inSection:0];
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:idx];
            [cell close];
            [self.cellArray removeAllObjects];
            
            cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
            [cell open];
            [self.cellArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
        }else {
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
            [cell close];
            [self.cellArray removeAllObjects];
        }
    }else {
        FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
        [cell open];
        [self.cellArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
    }
}

- (void)contextMenuCellDidSelectCoverOption:(FirstCell *)cell {
    [self.textView resignFirstResponder];
    self.theIndex = [self.firstTable indexPathForCell:cell];
    [self resetTableViewCellByIndex:self.theIndex];
}
- (void)contextMenuCellDidSelectFocusOption:(FirstCell *)cell {
    
}
- (void)contextMenuCellDidSelectCommentOption:(FirstCell *)cell {
    [self.textView becomeFirstResponder];
    self.theIndex = [self.firstTable indexPathForCell:cell];
}
- (void)contextMenuCellDidSelectDeleteOption:(FirstCell *)cell {
    [cell.superview sendSubviewToBack:cell];
    self.theIndex = [self.firstTable indexPathForCell:cell];
    
    [self.cellArray removeAllObjects];
    [self.firstArray removeObjectAtIndex:self.theIndex.row];
    [self.firstTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.theIndex, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark
#pragma mark - Keyboard notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = self.textBar.frame;
                         frame.origin.y += self.keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         self.textBar.frame = frame;
                         
                         self.keyboardHeight = keyboardRect.size.height;
                     }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.textBar.frame = CGRectMake(0, self.view.frame.size.height, 768, 50);
                         
                         self.keyboardHeight = -46;
                     }];
    
}

#pragma mark
#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)_textView {
    CGSize size = self.textView.contentSize;
    size.height -= 2;
    if ( size.height >= 368 ) {
        size.height = 368;
    }
    else if ( size.height <= 44 ) {
        size.height = 44;
    }
    if ( size.height != self.textView.frame.size.height ) {
        CGFloat span = size.height - self.textView.frame.size.height;
        CGRect frame = self.textBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        self.textBar.frame = frame;

        frame = self.textView.frame;
        frame.size = size;
        self.textView.frame = frame;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        if (self.type == 1) {//回复的主消息
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.tmpSection];
            [self.sendInter getSendDelegateWithSendId:[DataService sharedService].user.userId andSendType:@"1" andClassId:[DataService sharedService].theClass.classId andReceiverId:message.userId andReceiverType:message.userType andmessageId:message.messageId andContent:self.textView.text andType:self.type];
        }
        //TODO:添加事件
//        [self resetTableViewCellByIndex:self.theIndex];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",M_ID,@"陆平wefw",M_From,self.textView.text,M_Content,@"2014-02-26 17:58",M_Time,@"dfwfs",M_head,@"334566",M_focus,@"4435",M_answer,@"ss",M_To, nil];
//        MessageObject *message = [MessageObject messageFromDictionary:dic];
//        
//        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.theIndex.row+1 inSection:0];
//        [self.firstArray insertObject:message atIndex:idxPath.row];
//        
//        [self.firstTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.firstTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//        self.textView.text = @"";
        
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
            self.firstArray= nil;
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
            }
            [self.firstTable reloadData];
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
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    ReplyMessageObject *replyMsg = [ReplyMessageObject replyMessageFromDictionary:dic];
                    
                    if ([self.followArray containsObject:replyMsg.micropost_id]) {
                        replyMsg.isFollow = YES;
                    }else {
                        replyMsg.isFollow = NO;
                    }
                    replyMsg.pageCell = [[aDic objectForKey:@"page"]integerValue];
                    replyMsg.pageCountCell = [[aDic objectForKey:@"pages_count"]integerValue];
                    
                    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.tmpSection];
                    [message.replyMessageArray addObject:replyMsg];
                }
                [self.firstTable reloadSections:[NSIndexSet indexSetWithIndex:self.tmpSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self resetTableViewHeaderByIndex:self.tmpSection];
            
            [self scrollToBottomAnimated:YES];
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
            }else{
                message.followCount = [NSString stringWithFormat:@"%d",[message.followCount integerValue]+1];
                message.isFollow = YES;
            }
            header.aMessage = message;
            [self.followArray addObject:[NSNumber numberWithInteger:[header.aMessage.messageId integerValue]]];
        });
    });
}
-(void)getFocusInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark
#pragma mark - 删除

-(void)getDeleteMsgInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.firstArray removeObjectAtIndex:self.tmpSection];
            [self.firstTable deleteSections:[NSIndexSet indexSetWithIndex:self.tmpSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            for (int i=self.tmpSection; i<self.firstArray.count; i++) {
                FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:i];
                header.aSection -= 1;
            }
            [self.headerArray removeAllObjects];
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
            if (type==1) {//回复的主消息
                NSDictionary *dic = [result objectForKey:@""];
                ReplyMessageObject *replyMsg = [ReplyMessageObject replyMessageFromDictionary:dic];
                FirstViewHeader *header = (FirstViewHeader *)[self.firstTable headerViewForSection:self.tmpSection];
                MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:self.tmpSection];
                message.replyCount = [NSString stringWithFormat:@"%d",[message.replyCount integerValue]+1];
                [message.replyMessageArray insertObject:replyMsg atIndex:0];
                header.aMessage = message;
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:self.tmpSection];
                [self.firstTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.firstTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self.headerArray removeAllObjects];
                [self resetTableViewHeaderByIndex:self.tmpSection];
            }
        });
    });
}
-(void)getSendInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
