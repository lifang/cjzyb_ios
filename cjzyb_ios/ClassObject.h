//
//  ClassObject.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** ClassObject
 *
 * 班级对象
 */
@interface ClassObject : NSObject

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tName;
@property (nonatomic, strong) NSString *tId;

+(ClassObject *)classFromDictionary:(NSDictionary *)aDic;
///保存当前用户班级
-(void)archiverClass;

///删除当前本地用户班级
-(void)unarchiverClass;
@end
