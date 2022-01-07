//
//  ZZIntegralHelper.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZIntegralModel.h"//积分的model
#import "ZZIntegralExChangeModel.h"
/**
 我的积分管理类
 */
@interface ZZIntegralHelper : NSObject
/**
 请求积分信息并返回对应的内容
 
 @param successBlock 成功返回
 @param failure 返回失败
 */
+ (void)requestIntegralDetailInfoSuccess:(void(^)(ZZIntegralModel *model))successBlock
                                 failure:(void(^)(ZZError *error))failure ;



/**
 分享快照或者签到

 @param successBlock 分享成功或者签到成功
 @param failure 失败
 */
+(void)shareTheSnapshotWithType:(NSString *)type success:(void(^)(void))successBlock
                       failure:(void(^)(ZZError *error))failure;
/**
 请求积分兑换列表

 @param successBlock 请求兑换列表成功
 @param failure  请求失败
 */
+ (void)requestExChanageIntegralListSuccess:(void(^)(ZZIntegralExChangeModel *model))successBlock
                                    failure:(void(^)(ZZError *error))failure ;


/**
 积分兑换么币

 @param exChangeNumber 要兑换的积分数
 @param successBlock 兑换成功
 @param failure 兑换失败
 */
+ (void)exChangeIntegralNumber:(int)exChangeNumber
                       success:(void(^)(void))successBlock
                       failure:(void(^)(ZZError *error))failure;


/**
 积分签到

 @param successBlock 签到成功
 @param failure 签到失败
 */
+ (void)signInSuccess:(void(^)(void))successBlock
              failure:(void(^)(ZZError *error))failure;


@end
