//
//  ZZPayManager.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//支付网络管理器

#import <Foundation/Foundation.h>

@interface ZZPayManager : NSObject

/**
 检测并下载本地的内购数据

 @param completionCall 成功的数组返回
 */
+(void)checkAndDownloadInAppPurchase:(void (^)(NSArray *payArray))completionCall;
//下载内购的数据 每次启动的时候调用一次
+(void)downloadInAppPurchase:(void (^)(NSArray *payArray))completionCall ;
/**
  内购失败 上传数据
 */
+ (void)uploadToServerData:(NSDictionary *)payFailureData ;

/**
  内购成功上传给服务器

 @param paySuccessData 内购成功的数据
 @param completionCall 成功后回调数据
 */
+ (void)uploadToServerData:(NSDictionary *)paySuccessData completionCall:(void (^)(id payData))completionCall;
@end
