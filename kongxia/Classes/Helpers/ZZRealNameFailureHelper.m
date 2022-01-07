//
//  ZZRealNameFailureHelper.m
//  zuwome
//
//  Created by 潘杨 on 2018/7/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRealNameFailureHelper.h"

@implementation ZZRealNameFailureHelper
/**
 上传用户的实名认证的结果
 */
+ (void)uploadDic:(NSDictionary *)dic DetailInfoSuccess:(void(^)(ZZRealNameFailureModel *model))successBlock
          failure:(void(^)(ZZError *error))failure {
    [ZZRequest method:@"POST" path:@"/api/user/realname_fail" params:dic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                ZZRealNameFailureModel *model = [[ZZRealNameFailureModel alloc]initWithDictionary:data error:nil];
                if (successBlock) {
                    successBlock(model);
                }
            }
            if (failure) {
                failure(error);
            }
        });
    }];
}
@end
