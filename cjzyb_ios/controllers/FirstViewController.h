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
#import "ReplyMessageObject.h"
#import "ComtomTxt.h"

#import "MessageInterface.h"
#import "PageMessageInterface.h"//分页加载
#import "ReplyMessageInterface.h"//回复信息
#import "MJRefresh.h"

#import "FirstViewHeader.h"
@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MessageInterfaceDelegate,MJRefreshBaseViewDelegate,PMessageInterfaceDelegate,RMessageInterfaceDelegate,FirstViewHeaderDelegate>


@property (nonatomic, strong) MessageInterface *messageInter;
@property (nonatomic, strong) PageMessageInterface *pmessageInter;
@property (nonatomic, strong) ReplyMessageInterface *rmessageInter;
@property (nonatomic, strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic, strong) MJRefreshFooterView *footerRefreshView;

@property (nonatomic, strong) IBOutlet UITableView *firstTable;
@property (nonatomic, strong) NSMutableArray *firstArray;//消息数目
@property (nonatomic, strong) NSMutableArray *selectedArray;//记录弹出菜单的cell

@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSArray *followArray;


//回复
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) IBOutlet UIView *textBar;
@property (nonatomic, strong) IBOutlet ComtomTxt *textView;
@property (nonatomic, strong) NSIndexPath *theIndex;
//删除


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;
@end
