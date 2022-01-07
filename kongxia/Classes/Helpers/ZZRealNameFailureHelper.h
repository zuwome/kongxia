//
//  ZZRealNameFailureHelper.h
//  zuwome
//
//  Created by 潘杨 on 2018/7/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZRealNameFailureModel.h"
/**
 个人认证
 */
@interface ZZRealNameFailureHelper : NSObject


/**
 上传用户的实名认证的结果
 */
+ (void)uploadDic:(NSDictionary *)dic DetailInfoSuccess:(void(^)(ZZRealNameFailureModel *model))successBlock
          failure:(void(^)(ZZError *error))failure;
@end

