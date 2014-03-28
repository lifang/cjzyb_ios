//
//  RankingObject.h
//  cjzyb_ios
//
//  Created by david on 14-3-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** RankingObject
 *
 * 排名对象
 */
@interface RankingObject : NSObject
///id
@property (strong,nonatomic) NSString *rankingID;
///分数
@property (strong,nonatomic) NSString *rankingScore;
///排名
@property (strong,nonatomic) NSString *rankingNumber;
///头像url
@property (strong,nonatomic) NSString *rankingHeaderURL;
///名称
@property (strong,nonatomic) NSString *rankingName;

///用户id
@property (strong,nonatomic) NSString *rankingUserId;
@end
