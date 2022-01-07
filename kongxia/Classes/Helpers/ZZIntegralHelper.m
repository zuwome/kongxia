//
//  ZZIntegralHelper.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegralHelper.h"

@implementation ZZIntegralHelper


/**
 请求积分信息并返回对应的内容

 @param successBlock 成功返回
 @param failure 返回失败
 */
+(void)requestIntegralDetailInfoSuccess:(void(^)(ZZIntegralModel *model))successBlock
                                failure:(void(^)(ZZError *error))failure {
    [ZZRequest method:@"GET" path:@"/api/integral/task" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        if (data) {
            ZZIntegralModel *model = [[ZZIntegralModel alloc]initWithDictionary:data error:nil];
            if (model&&successBlock) {
                if (successBlock) {
                    successBlock(model);
                }
            }
        }
    }];
}

/**
 增加积分的
 
 */
+(void)shareTheSnapshotWithType:(NSString *)type success:(void(^)(void))successBlock
                        failure:(void(^)(ZZError *error))failure {
    
    [ZZRequest method:@"POST" path:@"/api/integral/add" params:@{@"type":type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }else{
                if (successBlock) {
                    successBlock();
                }
            }
        });
    }];
    
}

/**
 请求积分兑换列表
 
 @param successBlock 请求兑换列表成功
 @param failure  请求失败
 */
+ (void)requestExChanageIntegralListSuccess:(void(^)(ZZIntegralExChangeModel *model))successBlock
                                    failure:(void(^)(ZZError *error))failure{
    [ZZRequest method:@"GET" path:@"/api/integral/exchange" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }else{
                ZZIntegralExChangeModel *model = [[ZZIntegralExChangeModel alloc]initWithDictionary:data error:nil];
                if (successBlock) {
                    successBlock(model);
                }
            }
        });
    }];
}
/**
 积分兑换么币
 
 @param exChangeNumber 要兑换的积分数
 @param successBlock 兑换成功
 @param failure 兑换失败
 */
+ (void)exChangeIntegralNumber:(int)exChangeNumber
                       success:(void(^)(void))successBlock
                       failure:(void(^)(ZZError *error))failure {
    [ZZRequest method:@"POST" path:@"/api/integral/exchange" params:@{@"integral":[NSString stringWithFormat:@"%d",exChangeNumber]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }else{
                if (successBlock) {
                    successBlock();
                }
            }
        });
    }];
}
/**
 积分签到
 
 @param successBlock 签到成功
 @param failure 签到失败
 */
+ (void)signInSuccess:(void(^)(void))successBlock
              failure:(void(^)(ZZError *error))failure {
    [ZZRequest method:@"POST" path:@"/api/integral/sign" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }else{
                if (successBlock) {
                    successBlock();
                }
            }
        });
    }];
}
@end

