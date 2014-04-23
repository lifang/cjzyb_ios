//
//  UserObjDaoInterface.h
//  cjzyb_ios
//
//  Created by david on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassObject.h"
#import "UserObject.h"
/** UserObjDaoInterface
 *
 * 和当前用户相关操作
 */
@interface UserObjDaoInterface : NSObject

/*!
 * @brief 修改用户的昵称和头像
 * @param  userId 要修改的用户id
   @param  name 用户名称
＊@param  nickName 要修改的昵称，可以为空

 *@param  headerData 要修改的头像图片数据,可以为空
 
 * @return
 */
+(void)modifyUserNickNameAndHeaderImageWithUserId:(NSString*)userId withUserName:(NSString*)name withUserNickName:(NSString*)nickName withHeaderData:(NSData*)headerData withSuccess:(void (^)(NSString *msg))success withFailure:(void(^)(NSError *error))failure;

/*!
 * @brief 获取用户成就信息
 *
 * @param  userId 当前用户id
   @param  gradeID 当前所在班级的id
 *
 * @return
 */
+(void)downloadUserAchievementWithUserId:(NSString*)userId withGradeID:(NSString*)gradeID withSuccess:(void(^)(int youxi,int xunsu,int jiezu,int jingzhun,int niuqi))success withFailure:(void(^)(NSError *error))failure;

/*!
 * @brief 加入新班级
 *
 * @param  userId 当前用户id
 *@param  identifyCode 加入指定班级所需要的验证码
 * @return userObj 获取当前用户信息 ，gradeObj 当前加入的班级信息
 */
+(void)joinNewGradeWithUserId:(NSString*)userId withIdentifyCode:(NSString*)identifyCode withSuccess:(void(^)(UserObject *userObj,ClassObject *gradeObj))success withFailure:(void(^)(NSError *error))failure;


///获取当前用户加入的班级列表
+(void)dowloadGradeListWithUserId:(NSString*)userId withSuccess:(void(^)(NSArray *gradeList))success withFailure:(void(^)(NSError *error))failure;

/*!
 * @brief 切换班级
 *
 * @param  userId 当前用户id
 *@param  gradeId 当前用户所在班级id
 * @return userObj 获取当前用户信息 ，gradeObj 当前加入的班级信息
 */
+(void)exchangeGradeWithUserId:(NSString*)userId withGradeId:(NSString*)gradeId withSuccess:(void(^)(UserObject *userObj,ClassObject *gradeObj))success withFailure:(void(^)(NSError *error))failure;
@end
