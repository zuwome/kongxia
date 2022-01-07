//
//  ZZUserOnlineStateManage.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//融云用户在线状态获取

#import <Foundation/Foundation.h>
@interface ZZUserOnlineStateManage : NSObject
/**
 根据查询的用户的uid 来返回是否是好友状态
 
 @param queryUserId 被查询用户的uid

 @param callIsFriend 好友状态  yes  是  NO不是
 */
+(void)isfriendWithQueryUserId:(NSString *)queryUserId isFriend:(void(^)(BOOL isFriend))callIsFriend;


/**
 根据被查询的用户的uid来判断,该用户是否在线

 @param queryUserId 被查询用户的uid
 @return 在线状态 YES 在线 NO 不在线
 */

+ (void)userIsOnlineWithQueryUserId:(NSString *)queryUserId isOnline:(void (^)(BOOL isOnline))completed ;



/**
 查询用户是否是好友且在线

 @param queryUserId 被查询的用户的uid
 @return yes 是好友且在线,NO 不是好友或者不在线
 */
+ (BOOL)userIsOnLineAndIsFriendWhenQueryUserId:(NSString *)queryUserId;


@end
