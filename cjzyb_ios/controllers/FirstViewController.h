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
#import "UserObject.h"
#import "ClassObject.h"
#import "ComtomTxt.h"

#import "MessageInterface.h"
#import "PageMessageInterface.h"//分页加载
#import "ReplyMessageInterface.h"//回复信息
#import "FocusInterface.h"//关注
#import "DeleteMessage.h"//删除
#import "SendMessageInterface.h"//回复

#import "FirstViewHeader.h"
@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MessageInterfaceDelegate,PMessageInterfaceDelegate,RMessageInterfaceDelegate,FirstViewHeaderDelegate,FirstCellDelegate,FocusInterfaceDelegate,DeleteMessageDelegate,SendMessageInterfaceDelegate>

@property (nonatomic, strong) MessageInterface *messageInter;
@property (nonatomic, strong) PageMessageInterface *pmessageInter;
@property (nonatomic, strong) ReplyMessageInterface *rmessageInter;
@property (nonatomic, strong) FocusInterface *focusInter;
@property (nonatomic, strong) DeleteMessage *deleteInter;
@property (nonatomic, strong) SendMessageInterface *sendInter;

@property (nonatomic, strong) IBOutlet UITableView *firstTable;
@property (nonatomic, strong) NSMutableArray *firstArray;//消息数目
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, assign) NSInteger tmpSection;
//cell
@property (nonatomic, strong) NSMutableArray *cellArray;//记录弹出菜单的cell
@property (nonatomic, strong) NSMutableArray *deleteCellArray;

//header
@property (nonatomic, strong) NSMutableArray *headerArray;//记录弹出菜单的header
@property (nonatomic, strong) NSMutableArray *deleteHeaderArray;


@property (nonatomic, strong) NSMutableArray *followArray;

@property (nonatomic, assign) NSInteger type;//1:回复的是header       0:回复的是cell
//回复
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) IBOutlet UIView *textBar;
@property (nonatomic, strong) IBOutlet ComtomTxt *textView;
@property (nonatomic, strong) NSIndexPath *theIndex;
//删除





@end
