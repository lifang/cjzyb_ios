//
//  HomeworkTypeObj.h
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
///作业类型
typedef enum {
    ///时速挑战
    HomeworkType_quick,
    ///朗读任务
    HomeworkType_reading,
    ///听写任务
    HomeworkType_listeningAndWrite,
    ///选择挑战
    HomeworkType_select,
    ///连线挑战
    HomeworkType_line,
    ///完形填空
    HomeworkType_fillInBlanks,
    ///排序挑战
    HomeworkType_sort,
    ///其他
    HomeworkType_other,
    
}HomeworkType;

/** HomeworkTypeObj
 *
 * 题型
 */
@interface HomeworkTypeObj : NSObject
@property (strong,nonatomic) NSString *homeworkTypeID;
///当前类型任务是否完成
@property (assign,nonatomic) BOOL homeworkTypeIsFinished;
///当前类型任务排名
@property (strong,nonatomic) NSString *homeworkTypeRanking;
///作业类型
@property (assign,nonatomic) HomeworkType homeworkType;

///当前类型任务是否有排名
@property (assign,nonatomic) BOOL homeworkTypeIsRanking;
@end
