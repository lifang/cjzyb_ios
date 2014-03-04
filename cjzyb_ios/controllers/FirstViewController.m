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


-(void)testDataWithStr:(NSString *)str {
    NSDictionary *result = [Utility initWithJSONFile:str];
    self.followArray = [NSArray arrayWithArray:[result objectForKey:@"follow_microposts_id"]];
    NSDictionary *messages = [result objectForKey:@"microposts"];
    self.page = [[messages objectForKey:@"page"]integerValue];
    self.pageCount = [[messages objectForKey:@"pages_count"]integerValue];
    NSArray *array = [messages objectForKey:@"details_microposts"];
    if (array.count>0) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
            MessageObject *message = [MessageObject messageFromDictionary:dic];
            if ([self.followArray containsObject:message.messageId]) {
                message.isFollow = YES;
            }else {
                message.isFollow = NO;
            }
            
            [self.firstArray addObject:message];
        }
        [self.firstTable reloadData];
    }
    
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
    
    
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
    
    [self testDataWithStr:@"get_class_info"];
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
-(NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}
-(NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [[NSMutableArray alloc]init];
    }
    return _deleteArray;
}
-(NSMutableArray *)headerArray {
    if (!_headerArray) {
        _headerArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _headerArray;
}
//-(MJRefreshHeaderView *)headerRefreshView{
//    if (!_headerRefreshView) {
//        _headerRefreshView = [[MJRefreshHeaderView alloc] init];
//        _headerRefreshView.scrollView = self.firstTable;
//        _headerRefreshView.delegate = self;
//    }
//    return _headerRefreshView;
//}
//-(MJRefreshFooterView *)footerRefreshView{
//    if (!_footerRefreshView) {
//        _footerRefreshView = [[MJRefreshFooterView alloc] init];
//        _footerRefreshView.delegate = self;
//        _footerRefreshView.scrollView = self.firstTable;
//        
//    }
//    return _footerRefreshView;
//}
-(void)dealloc{
    [self.footerRefreshView free];
    [self.headerRefreshView free];
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
    if ([message.userId integerValue] == [[DataService sharedService].user_id integerValue]) {
        header.msgStyle = MessageCellStyleMe;
    }else {
        header.msgStyle = MessageCellStyleOther;
    }
    header.aSection = section;
    return header;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.firstArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:section];
    return message.replyMessageArray.count;
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
    if ([replyMessage.sender_id integerValue] == [[DataService sharedService].user_id integerValue]) {
        cell.msgStyle = MessageCellStyleMe;
    }else {
        cell.msgStyle = MessageCellStyleOther;
    }
    
    cell.idxPath = indexPath;
//    cell.delegate = self;
    cell.isSelected = NO;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark
#pragma mark - FirstViewHeaderDelegate

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
    if (self.deleteArray.count>0) {
        int k = 0;
        for (int i=0; i<self.deleteArray.count; i++) {
            NSInteger aSec = [[self.deleteArray objectAtIndex:i]integerValue];
            if (aSec<header.aSection) {
                k++;
            }
        }
        header.aSection -= k;
        [self resetTableViewHeaderByIndex:header.aSection];
    }else {
        [self resetTableViewHeaderByIndex:header.aSection];
    }
}
- (void)contextMenuHeaderDidSelectFocusOption:(FirstViewHeader *)header {
    
}
- (void)contextMenuHeaderDidSelectCommentOption:(FirstViewHeader *)header {
    
}
- (void)contextMenuHeaderDidSelectDeleteOption:(FirstViewHeader *)header {
    [header.superview sendSubviewToBack:header];
    [self.deleteArray addObject:[NSString stringWithFormat:@"%d",header.aSection]];
    [self.headerArray removeAllObjects];
    if (self.deleteArray.count>0) {
        int k = 0;
        for (int i=0; i<self.deleteArray.count; i++) {
            NSInteger aSec = [[self.deleteArray objectAtIndex:i]integerValue];
            if (aSec<header.aSection) {
                k++;
            }
        }
        header.aSection -= k;
        [self.firstArray removeObjectAtIndex:header.aSection];
        [self.firstTable deleteSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark
#pragma mark - FirstCellDelegate
//-(void)tableViewReload {
//    [self.firstTable reloadData];
//}
//-(void)resetTableViewCellByIndex:(NSIndexPath *)aIndex{
//    if (self.selectedArray.count > 0) {
//        NSInteger aRow = [[self.selectedArray objectAtIndex:0]integerValue];
//        if (aRow != aIndex.row) {
//            NSIndexPath *idx = [NSIndexPath indexPathForRow:aRow inSection:0];
//            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:idx];
//            [cell close];
//            [self.selectedArray removeAllObjects];
//            
//            cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
//            [cell open];
//            [self.selectedArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
//        }else {
//            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
//            [cell close];
//            [self.selectedArray removeAllObjects];
//        }
//    }else {
//        FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
//        [cell open];
//        [self.selectedArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
//    }
//}
//
//- (void)contextMenuCellDidSelectCoverOption:(FirstCell *)cell {
//    [self.textView resignFirstResponder];
//    self.theIndex = [self.firstTable indexPathForCell:cell];
//    [self resetTableViewCellByIndex:self.theIndex];
//    
////    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////    ReplyMessageInterface *log = [[ReplyMessageInterface alloc]init];
////    self.rmessageInter = log;
////    self.rmessageInter.delegate = self;
////    [self.rmessageInter getReplyMessageInterfaceDelegateWithMessageId:@"342" andPage:1];
//    NSDictionary *result = [Utility initWithJSONFile:@"get_reply_microposts"];
//    NSDictionary *aDic = [result objectForKey:@"reply_microposts"];
//    NSArray *array = [aDic objectForKey:@"reply_microposts"];
//    if (array.count>0) {
//        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
//        for (int i=0; i<array.count; i++) {
//            NSDictionary *dic = [array objectAtIndex:i];
//            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.theIndex.row+1+i inSection:0];
//            [self.firstArray insertObject:dic atIndex:idxPath.row];
//            [tempArray addObject:idxPath];
//        }
//        [self.firstTable insertRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.firstTable reloadRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}
//- (void)contextMenuCellDidSelectFocusOption:(FirstCell *)cell {
//    
//}
//- (void)contextMenuCellDidSelectCommentOption:(FirstCell *)cell {
//    [self.textView becomeFirstResponder];
//    self.theIndex = [self.firstTable indexPathForCell:cell];
//}
//- (void)contextMenuCellDidSelectDeleteOption:(FirstCell *)cell {
//    [cell.superview sendSubviewToBack:cell];
//    self.theIndex = [self.firstTable indexPathForCell:cell];
//    [self.selectedArray removeAllObjects];
//    [self.firstArray removeObjectAtIndex:self.theIndex.row];
//    [self.firstTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:self.theIndex, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

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
#pragma mark - MessageInterfaceDelegate
-(void)getMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.firstArray= nil;
            //消息
            NSDictionary *messages = [result objectForKey:@"microposts"];
            self.page = [[messages objectForKey:@"page"]integerValue];
            self.pageCount = [[messages objectForKey:@"pages_count"]integerValue];
            NSArray *array = [messages objectForKey:@"details_microposts"];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *aDic = [array objectAtIndex:i];
                    MessageObject *msg = [MessageObject messageFromDictionary:aDic];
                    [self.firstArray addObject:msg];
                }
            }
            [self.firstTable reloadData];
            
            if (self.pageCount>self.page) {
                [self.footerRefreshView endRefreshing];
                self.footerRefreshView.isForbidden = NO;
            }else {
                [self.footerRefreshView endRefreshing];
                self.footerRefreshView.isForbidden = YES;
            }
        });
    });
}
-(void)getMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark
#pragma mark - MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    //TODO:分页加载
    if (self.headerRefreshView == refreshView) {
        self.footerRefreshView.isForbidden = YES;
        [self testDataWithStr:@"get_class_info"];
    }else {
        self.headerRefreshView.isForbidden = YES;
        self.page += 1;
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        PageMessageInterface *log = [[PageMessageInterface alloc]init];
//        self.pmessageInter = log;
//        self.pmessageInter.delegate = self;
//        [self.pmessageInter getPageMessageInterfaceDelegateWithClassId:@"83" andUserId:@"73" andPage:self.page];
//        log = nil;
        [self testDataWithStr:@"get_microposts"];
    }
    
}
#pragma mark
#pragma mark - PMessageInterfaceDelegate
-(void)getPageMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //消息
            NSDictionary *messages = [result objectForKey:@"microposts"];
            self.page = [[messages objectForKey:@"page"]integerValue];
            self.pageCount = [[messages objectForKey:@"pages_count"]integerValue];
            NSArray *array = [messages objectForKey:@"details_microposts"];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *aDic = [array objectAtIndex:i];
                    MessageObject *msg = [MessageObject messageFromDictionary:aDic];
                    [self.firstArray addObject:msg];
                }
            }
            [self.firstTable reloadData];
            
            if (self.pageCount>self.page) {
                [self.footerRefreshView endRefreshing];
                self.footerRefreshView.isForbidden = NO;
            }else {
                [self.footerRefreshView endRefreshing];
                self.footerRefreshView.isForbidden = YES;
            }
        });
    });
}
-(void)getPageMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}


#pragma mark
#pragma mark - RMessageInterfaceDelegate
-(void)getReplyMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //消息
            NSDictionary *messages = [result objectForKey:@"microposts"];
            self.page = [[messages objectForKey:@"page"]integerValue];
            self.pageCount = [[messages objectForKey:@"pages_count"]integerValue];
            NSArray *array = [messages objectForKey:@"details_microposts"];
            if (array.count>0) {
                for (int i=0; i<array.count; i++) {
                    NSDictionary *aDic = [array objectAtIndex:i];
                    MessageObject *msg = [MessageObject messageFromDictionary:aDic];
                    [self.firstArray addObject:msg];
                }
            }
            [self.firstTable reloadData];
            
            if (self.pageCount>self.page) {
                [self.footerRefreshView endRefreshing];
                self.footerRefreshView.isForbidden = NO;
            }else {
                [self.footerRefreshView endRefreshing];
                self.footerRefreshView.isForbidden = YES;
            }
        });
    });
}
-(void)getReplyMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
