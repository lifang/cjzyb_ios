//
//  FirstViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstCell.h"
#import "MessageObject.h"

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FirstCellDelegate,UITextViewDelegate>
{
    struct {
        unsigned int delegateWillReloadData:1;
        unsigned int delegateDidReloadData:1;
        unsigned int reloading:1;
    } _flags;
}

@property (nonatomic, strong) IBOutlet UITableView *firstTable;
@property (nonatomic, strong) NSMutableArray *firstArray;//消息数目
@property (nonatomic, strong) NSMutableArray *selectedArray;//记录弹出菜单的cell
//回复
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) IBOutlet UIView *textBar;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSIndexPath *theIndex;
//删除
@property (assign, nonatomic) BOOL customEditing;


- (void)tableViewWillReloadData:(UITableView *)tableView;
- (void)tableViewDidReloadData:(UITableView *)tableView;
@end
