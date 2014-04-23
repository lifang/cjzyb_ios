//
//  HintHelper.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HintHelper.h"
#import "HomeworkViewController.h"

@implementation HintHelper

#pragma mark ---------------------------------->>
#pragma mark -------------->>modal delegate
-(void)doNext
{
    switch (_curType) {
        case EMHintDialogTypeMainLeftButton:
            [modalState presentModalMessage:kFirstMessage where:_vc.view];
            break;
        case EMHintDialogTypePersonImage:
            [modalState presentModalMessage:ksixthMessage where:_vc.view];
            break;
        case EMHintDialogTypePersonInfo:
            [modalState presentModalMessage:kSecondMessage where:_vc.view];
            break;
        case EMHintDialogTypeHomeWorkRefresh:
            [modalState presentModalMessage:kThirdMessage where:_vc.view];
            break;
        case EMHintDialogTypeHomeWorkHistory:
            [modalState presentModalMessage:kFourthMessage where:_vc.view];
            break;
        case EMHintDialogTypeHomeWorkSlide:
            [modalState presentModalMessage:kfifthMessage where:_vc.view];
            break;
            
        default:
            [modalState presentModalMessage:kFirstMessage where:_vc.view];
            break;
    }
}

#pragma mark ---------------------------------->>
#pragma mark -------------->>HInt Delegate
-(BOOL)hintStateShouldCloseIfPermitted:(id)hintState
{
    _curType ++;
    
    if(_curType>EMHintDialogTypeHomeWorkSlide)
    {
        _curType = 0;//reset for next time
        return YES;
    }
    [self doNext];
    return NO;
}
-(void)hintStateWillClose:(id)hintState
{
}
-(void)hintStateDidClose:(id)hintState
{
}

-(CGRect)hintStateRectToHint:(id)hintState
{
    CGRect rect;
    switch (_curType) {
        case EMHintDialogTypeMainLeftButton:
            rect = CGRectMake(50,33,50,50);
            break;
        case EMHintDialogTypePersonImage:
            rect = CGRectMake(574,33,48,48);
            break;
        case EMHintDialogTypePersonInfo:
            rect = CGRectMake(735,33,50,50);
            break;
        case EMHintDialogTypeHomeWorkRefresh:
            rect = CGRectMake(92,110,60,60);
            break;
        case EMHintDialogTypeHomeWorkHistory:
            rect = CGRectMake(672,110,60,60);
            break;
        case EMHintDialogTypeHomeWorkSlide:
            rect = CGRectMake(0, 0, 1, 1);
            break;
            
        default:
            rect = CGRectMake(0, 0, 1, 1);
            break;
    }
    return rect;
}


-(UIView*)hintStateViewForDialog:(id)hintState
{
    return nil;
}

- (id)initWithViewController:(DRLeftTabBarViewController *)vc {
    self = [super init];
    if (self) {
        _vc = vc;
        _curType = EMHintDialogTypeMainLeftButton;

        modalState = [[EMHint alloc] init];
        [modalState setHintDelegate:self];
        [modalState presentModalMessage:kFirstMessage where:_vc.view];
    }
    return self;
}
@end
