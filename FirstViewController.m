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
-(void)testData {
    for (int i=0; i<20; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",M_ID,@"陆平",M_From,str,M_Content,@"2014-01-11 17:58",M_Time,@"dfwfs",M_head,@"334566",M_focus,@"4435",M_answer,@"ss",M_To, nil];
        MessageObject *message = [MessageObject messageFromDictionary:dic];
        [self.firstArray addObject:message];
    }
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
    [self testData];
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

#pragma mark
#pragma mark - UITableViewDelegate

-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:18];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(CELL_WIDTH-Insets*4-Head_Size, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.firstArray.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.row];
    CGSize size = [self getSizeWithString:message.messageContent];
    
    return Insets*6+Label_Height+size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"firstCell%d";
    FirstCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FirstCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.row];
    cell.aMessage = message;
    cell.idxPath = indexPath;
    cell.delegate = self;
    cell.isSelected = NO;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark
#pragma mark - FirstCellDelegate
-(void)tableViewReload {
    [self.firstTable reloadData];
}
-(void)resetTableViewCellByIndex:(NSIndexPath *)aIndex{
    if (self.selectedArray.count > 0) {
        NSInteger aRow = [[self.selectedArray objectAtIndex:0]integerValue];
        if (aRow != aIndex.row) {
            NSIndexPath *idx = [NSIndexPath indexPathForRow:aRow inSection:0];
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:idx];
            [cell close];
            [self.selectedArray removeAllObjects];
            
            cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
            [cell open];
            [self.selectedArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
        }else {
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
            [cell close];
            [self.selectedArray removeAllObjects];
        }
    }else {
        FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:aIndex];
        [cell open];
        [self.selectedArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
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
    [self.selectedArray removeAllObjects];
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
        //TODO:添加事件
        [self resetTableViewCellByIndex:self.theIndex];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",M_ID,@"陆平wefw",M_From,self.textView.text,M_Content,@"2014-02-26 17:58",M_Time,@"dfwfs",M_head,@"334566",M_focus,@"4435",M_answer,@"ss",M_To, nil];
        MessageObject *message = [MessageObject messageFromDictionary:dic];
        
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.theIndex.row+1 inSection:0];
        [self.firstArray insertObject:message atIndex:idxPath.row];
        
        [self.firstTable insertRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.firstTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idxPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        self.textView.text = @"";
        
        return NO;
    }
    
    return YES;
}

@end
