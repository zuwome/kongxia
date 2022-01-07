//
//  ZZUserFollowModel.h
//  zuwome
//
//  Created by angBiu on 16/8/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZUserFollowModel : JSONModel

@property (nonatomic, assign) NSInteger follow_status;//0未关注  1关注 2互相关注
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) NSString *sort_value1;
@property (nonatomic, strong) NSString *sort_value2;
@property (nonatomic, assign) NSInteger read;//0代表未读 1已读（新增）

/**
 *  获取粉丝列表(个人页)--登录
 */
+ (void)getUserFansListWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;
/**
 *  获取粉丝列表(个人页)--未登录
 */
+ (void)getUnloginUserFansListWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;
/**
 *  获取关注列表(个人页)
 */
+ (void)getUserAttentionListParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;
/**
 *  获取关注列表(个人页)--未登录
 */
+ (void)getUnloginUserAttentionListParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;
/**
 *  获取粉丝列表(我的页面)
 */
- (void)getFansListWithParam:(NSDictionary *)param next:(requestCallback)next;
/**
 *  获取关注列表(我的页面)
 */
- (void)getAttentionListParam:(NSDictionary *)param next:(requestCallback)next;

@end
