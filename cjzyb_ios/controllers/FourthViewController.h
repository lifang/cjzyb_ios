//
//  FourthViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstCell.h"
#import "ComtomTxt.h"
#import "FirstViewHeader.h"
#import "MessageObject.h"
#import "ReplyMessageObject.h"

#import "MyFocusInterface.h"
#import "ReplyMessageInterface.h"//回复信息
#import "FocusInterface.h"//关注
#import "DeleteMessage.h"//删除
#import "SendMessageInterface.h"//回复
/**
 *  关注的消息
 */
@interface FourthViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RMessageInterfaceDelegate,FocusInterfaceDelegate,DeleteMessageDelegate,SendMessageInterfaceDelegate,FirstCellDelegate,FirstViewHeaderDelegate,MyFocusInterfaceDelegate>

@property (nonatomic, strong) MyFocusInterface *mFocusInter;
@property (nonatomic, strong) ReplyMessageInterface *rmessageInter;
@property (nonatomic, strong) FocusInterface *focusInter;
@property (nonatomic, strong) DeleteMessage *deleteInter;
@property (nonatomic, strong) SendMessageInterface *sendInter;
@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, strong) IBOutlet UITableView *fourthTable;
@property (nonatomic, strong) NSMutableArray *fourthArray;//消息数目
//cell
@property (nonatomic, strong) NSMutableArray *cellArray;//记录弹出菜单的cell
@property (nonatomic, strong) NSIndexPath *theIndex;
//header
@property (nonatomic, strong) NSMutableArray *headerArray;//记录弹出菜单的header
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, assign) NSInteger tmpSection;

@property (nonatomic, assign) NSInteger type;//1:回复的是header       0:回复的是cell
@property (nonatomic, strong) UIActivityIndicatorView *indicView;
@property (nonatomic, assign) BOOL isReloading;

@property (nonatomic, strong) IBOutlet UIView *textBar;
@property (nonatomic, strong) IBOutlet ComtomTxt *textView;
@property (nonatomic, strong) IBOutlet UILabel *textCountLabel;
@property (nonatomic, assign) int fourth;
@end
