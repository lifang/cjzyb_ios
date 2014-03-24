//
//  TagViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TagViewController.h"

@interface TagViewController ()

@end
#define DETAIL_HEADER @"detailHeader"
#define Button_no_selected  99
#define Button_has_selected 99
@implementation TagViewController

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
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:9];
    [self.tagTable registerClass:[TagViewFooter class] forHeaderFooterViewReuseIdentifier:DETAIL_HEADER];
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.tagtxt];
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
-(TagInterface *)tagInter {
    if (!_tagInter) {
        _tagInter = [[TagInterface alloc]init];
        _tagInter.delegate = self;
    }
    return _tagInter;
}
-(void)setACard:(CardObject *)aCard {
    _aCard = aCard;
    if (_aCard.tagArray.count>0) {
        [self sortArray];
    }
    [self.tagTable reloadData];
}
-(void)setTagArray:(NSMutableArray *)tagArray {
    _tagArray = tagArray;
}
-(SelectedTagInterface *)selectedInter {
    if (!_selectedInter) {
        _selectedInter = [[SelectedTagInterface alloc]init];
        _selectedInter.delegate = self;
    }
    return _selectedInter;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tagArray.count;
}
//排序
-(void)sortArray {
    int count = 0;
    for (int i=0; i<self.aCard.tagArray.count; i++) {
        NSInteger tag_id = [[self.aCard.tagArray objectAtIndex:i]integerValue];
        for (int k=0; k<self.tagArray.count; k++) {
            TagObject *tagObj = [self.tagArray objectAtIndex:k];
            if ([tagObj.tagId integerValue] == tag_id) {
                [self.tagArray exchangeObjectAtIndex:count withObjectAtIndex:k];
                count++;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tag_cell";
    TagCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[TagCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    TagObject *tagObj = (TagObject *)[self.tagArray objectAtIndex:indexPath.row];
    cell.titleLab.text = tagObj.tagName;
    cell.selectedBtn.tag = indexPath.row;
    if (self.aCard.tagArray.count>0) {
        
        BOOL isExit = NO;
        for (NSString *str in self.aCard.tagArray) {
            if ([str integerValue] == [tagObj.tagId integerValue]) {
                isExit = YES;
                [cell.selectedBtn setImage:[UIImage imageNamed:@"card_hasselected"] forState:UIControlStateNormal];
                break;
            }
        }
        if (isExit == NO) {
            [cell.selectedBtn setImage:[UIImage imageNamed:@"card_noselected"] forState:UIControlStateNormal];
        }
    }else {
        [cell.selectedBtn setImage:[UIImage imageNamed:@"card_noselected"] forState:UIControlStateNormal];
    }
    cell.delegate = self;
    return cell;
}

-(void)initFooterView {
    TagViewFooter *footer = [[TagViewFooter alloc]initWithFrame:CGRectMake(0, 0, 265, 50)];
    [footer.coverBt setTitle:[NSString stringWithFormat:@"创建\"%@\"",self.tagtxt.text] forState:UIControlStateNormal];
    footer.delegate = self;
    self.tagTable.tableFooterView = footer;
}


-(void)textFieldChanged:(NSNotification *)sender {
    UITextField *txtField = (UITextField *)sender.object;
    if (txtField.text.length>0) {
        NSString *keyName = @"tagName";
        NSString *searchText = [txtField.text substringWithRange:NSMakeRange(0, 1)];
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyName, searchText];
        self.tagArray = [NSMutableArray arrayWithArray:[self.filteredArray filteredArrayUsingPredicate:predicateString]];
        [self initFooterView];
    }else {
        self.tagArray = self.filteredArray;
        self.tagTable.tableFooterView = nil;
    }
    
    [self.tagTable reloadData];
}
#pragma mark
#pragma mark - SelectedTagInterfaceDelegate
-(void)pressedButton:(UIButton *)btn {
    [self.tagtxt resignFirstResponder];

    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        self.tmpIndex = btn.tag;
        TagObject *tagObj = [self.tagArray objectAtIndex:btn.tag];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //            [self.tagInter getTagInterfaceDelegateWithStudentId:[DataService sharedService].user.studentId andClassId:[DataService sharedService].theClass.classId andCardId:self.aCard.carId andName:self.tagtxt.text];
        
        [self.selectedInter getSelectedTagInterfaceDelegateWithStudentId:@"1" andClassId:@"1" andCardId:self.aCard.carId andCardTagId:tagObj.tagId];
    }
}
-(void)getSelectedTagInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger type = [[result objectForKey:@"type"]integerValue];
            //type=0 错误，1 删除成功，2 添加成功
            TagObject *tagObj = [self.tagArray objectAtIndex:self.tmpIndex];
            if (type==1) {
                [self.aCard.tagArray removeObject:[NSNumber numberWithInteger:[tagObj.tagId integerValue]]];
            }else if (type==2) {
                [self.aCard.tagArray addObject:[NSNumber numberWithInteger:[tagObj.tagId integerValue]]];
            }
            [self sortArray];
            self.tagTable.tableFooterView = nil;
            [self.tagTable reloadData];
            [self.tagTable setContentOffset:CGPointMake(0, 0)];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTagByView" object:self.aCard];
        });
    });
}
-(void)getSelectedTagInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark
#pragma mark - TagInterfaceDelegate
-(void)getTagInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tagtxt.text = @"";
            NSDictionary *dic = [result objectForKey:@"cardtag"];
            TagObject *tagObj = [TagObject tagFromDictionary:dic];
            [[DataService sharedService].tagsArray addObject:tagObj];
            
            self.tagArray = [DataService sharedService].tagsArray;
            [self.aCard.tagArray addObject:tagObj.tagId];
            
            self.tagTable.tableFooterView = nil;
            [self.tagTable reloadData];
            [self.tagTable setContentOffset:CGPointMake(0, 0)];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTagByView" object:self.aCard];
        });
    });
}
-(void)getTagInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
//创建新的
-(void)detailHeader:(TagViewFooter*)header {
    [self.tagtxt resignFirstResponder];

    if (self.appDel.isReachable == NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //            [self.tagInter getTagInterfaceDelegateWithStudentId:[DataService sharedService].user.studentId andClassId:[DataService sharedService].theClass.classId andCardId:self.aCard.carId andName:self.tagtxt.text];
        
        [self.tagInter getTagInterfaceDelegateWithStudentId:@"1" andClassId:@"1" andCardId:self.aCard.carId andName:self.tagtxt.text];
    }
}
@end
