//
//  ZZPayManager.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPayManager.h"
#import "ZZRequest.h"
#import "ZZMeBiModel.h"
#import "SandBoxHelper.h"
#import "SandBoxHelper.h"
#define InAppPurchaseKey @"InAppPurchaseKey"//存储内购的数据
#define InAppPurchaseRequestTimeKey @"InAppPurchaseRequestTimeKey"//存储内购上次请求的时间

#import "ZZDateHelper.h"
@implementation ZZPayManager
//判断本地是否有数据有的话就从本地取没有再去调用
+(void)checkAndDownloadInAppPurchase:(void (^)(NSArray *payArray))completionCall {
    
   NSArray *array = [[NSUserDefaults standardUserDefaults]  objectForKey:InAppPurchaseKey];
    if (array) {
        NSArray *modelArray = [ZZMeBiModel arrayOfModelsFromDictionaries:array error:nil];
        if (completionCall) {
            completionCall(modelArray);
        }
        return;
    }
    [ZZPayManager downloadInAppPurchase:^(NSArray *payArray) {
        if (completionCall) {
            completionCall(payArray);
        }
    }];
}
//下载内购的数据 每次启动的时候调用一次
+(void)downloadInAppPurchase:(void (^)(NSArray *payArray))completionCall {
    
    //判断如果半小时内重复请求的话就直接返回上次请求的结果
    NSDate *date = [[NSUserDefaults standardUserDefaults]  objectForKey:InAppPurchaseRequestTimeKey];
    if (date ) {
     NSDate *overdueDate =   [date initWithTimeIntervalSinceNow:30*60];
        if ([overdueDate compare:[NSDate date]] ==NSOrderedDescending) {
            NSArray *array = [[NSUserDefaults standardUserDefaults]  objectForKey:InAppPurchaseKey];
            if (array) {
                NSArray *modelArray = [ZZMeBiModel arrayOfModelsFromDictionaries:array error:nil];
                if (completionCall) {
                    completionCall(modelArray);
                }
                NSLog(@"PY_半小时内重复请求的话就直接返回上次请求的结果");
                return;
            }
        }
    }
    
    // 租我么 内购:/system/in_app_purchase/list
    // 空虾  内购: /system/in_app_purchase/listkx
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/system/in_app_purchase/listkx"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSLog(@"PY_内购数据请求下来");
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:InAppPurchaseKey];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:InAppPurchaseRequestTimeKey];

            [[NSUserDefaults standardUserDefaults] synchronize];
            NSArray *model = [ZZMeBiModel arrayOfModelsFromDictionaries:data error:nil];
            if (completionCall) {
                completionCall(model);
            }
        }
    }];
}

/**
 内购成功上传给服务器

 @param paySuccessData 内购成功的数据
 */
+ (void)uploadToServerData:(NSDictionary *)paySuccessData completionCall:(void (^)(id payData))completionCall {
    
    // 租我么: 内购完成 /api/user/mcoin/recharge
    // 空虾:   内购完成 /api/user/mcoin/rechargekx

    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/mcoin/rechargekx"] params:paySuccessData next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSLog(@"PY_内购数据请求下来");
            if (!data[@"error"]) {
                [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id userData, NSURLSessionDataTask *task) {
                    ZZUser *user = [ZZUser yy_modelWithJSON:data];
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                    completionCall(data);
                }];
                return ;
            }
            completionCall(data);
        }
        else {
            
        }
    }];
}


/**
 么币充值失败

 @param payFailureData 失败的数据
 */
+ (void)uploadToServerData:(NSDictionary *)payFailureData {
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/mcoin/recharge/cancel"] params:payFailureData next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSLog(@"取消内购告诉服务器,然后引导去其他方式充值");
        }
    }];
}
@end
