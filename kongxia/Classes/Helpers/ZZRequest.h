//
//  ZZRequest.h
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <AFNetworking.h>
#import <Foundation/Foundation.h>
#import "ZZError.h"


typedef void (^requestCallback)(ZZError *error, id data, NSURLSessionDataTask *task);
typedef void(^RequestSuccess)(NSInteger statusCode, NSDictionary* responseObject);
typedef void(^RequestFailure)(NSInteger statusCode, NSError* error);

@interface ZZRequest : NSObject

+ (void)getBizToken:(NSDictionary *)params
          userImage:(UIImage *)userImage
            success:(RequestSuccess)successBlock
            failure:(RequestFailure)failureBlock;

+ (void)verifyWithParam:(NSDictionary *)params
                 verify:(NSData *)megliveData
                success:(RequestSuccess)successBlock
                failure:(RequestFailure)failureBlock;

/**
 默认网络超时15秒的
 */
+ (void)method:(NSString *)method
           path:(NSString *)path
        params:(NSDictionary *)params
          next:(requestCallback)next;


/**
 包含超时时间的请求

 @param timeOut 超时时间
 @param method 请求方式
 @param path 请求网址
 @param params 请求参数
 @param next 回调
 */
+ (void)requestWithtimeout:(float)timeOut method:(NSString *)method
          path:(NSString *)path
        params:(NSDictionary *)params
          next:(requestCallback)next;
@end
