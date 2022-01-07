//
//  ZZRequest.m
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRequest.h"
#import "HttpDNS.h"
#import "ZZAFNHelper.h"
#import "WBKeyChain.h"

@implementation ZZRequest

+ (void)verifyWithParam:(NSMutableDictionary *)params
                 verify:(NSData *)megliveData
                success:(RequestSuccess)successBlock
                failure:(RequestFailure)failureBlock {
    ZZAFNHelper *manager = [ZZAFNHelper shareInstance];
    [manager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"https://api.megvii.com/faceid/v3/sdk/verify"
              parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:megliveData name:@"meglive_data" fileName:@"meglive_data" mimeType:@"text/html"];
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
}

+ (void)getBizToken:(NSDictionary *)params
          userImage:(UIImage *)userImage
            success:(RequestSuccess)successBlock
            failure:(RequestFailure)failureBlock {
    
    ZZAFNHelper *manager = [ZZAFNHelper shareInstance];
    [manager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"https://api.megvii.com/faceid/v3/sdk/get_biz_token" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        NSData *imageData = UIImagePNGRepresentation(userImage);
        [formData appendPartWithFileData:imageData name:@"image_ref1" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                failureBlock([urlResponse statusCode], error);
            });
        }
    }];
}

+ (void)method:(NSString *)method
           path:(NSString *)path
        params:(NSDictionary *)params
          next:(requestCallback)next {

    NSURL *backendURL = [[NSURL alloc] initWithString:kBase_URL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    // 获取IP
    [[HttpDNS shareInstance] getIpByHost:backendURL.host next:^(NSError *error, NSString *ip) {
        NSString *newHost = error? backendURL.host: ip;//当欠费的时候IP 返回的是一串的乱码  这个时候会崩溃的
        ZZAFNHelper *manager = [ZZAFNHelper shareInstance];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20.0;//默认15秒
        NSString *oAuthToken = [ZZUserHelper shareInstance].oAuthToken;
        if (!oAuthToken) {
            oAuthToken = [ZZUserHelper shareInstance].publicToken;
        }
        NSLog(@"apiToken - %@",oAuthToken);
        if (!isNullString(oAuthToken)) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",oAuthToken] forHTTPHeaderField:@"X-Api-Token"];
        }
        NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
        if (isNullString(uuid)) {
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
        }
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",uuid] forHTTPHeaderField:@"uuid"];
        if (backendURL.host) {
            [manager.requestSerializer setValue:backendURL.host forHTTPHeaderField:@"HOST"];
        }
        
        NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
        [p setObject:@"ios" forKey:@"dev"];
        
        [p setObject:[UIApplication version] forKey:@"v"];
        NSString* deviceName = [[ZZUtils deviceVersion] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (deviceName) {
            [p setObject:deviceName forKey:@"dev_name"];
        }
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        if (phoneVersion) {
            [p setObject:phoneVersion forKey:@"dev_version"];
        }
        
        NSString *URLString = ({
            NSString *sURL = [NSString stringWithFormat:@"%@://%@", backendURL.scheme,newHost];
            if (backendURL.port) {
                sURL = [sURL stringByAppendingString:[NSString stringWithFormat:@":%@", backendURL.port]];
            }
            sURL = [sURL stringByAppendingString:path];
            NSURL *URL = [[NSURL alloc] initWithString:sURL];
            if (!URL) {
               sURL = [NSString stringWithFormat:@"%@://%@", backendURL.scheme,backendURL.host];
               URL = [[NSURL alloc] initWithString:sURL];

            }
            [[URL URLByAppendingParameters:p] absoluteString];
        });
        if (!URLString) {
            return ;
        }
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:URLString parameters:params error:nil];

        NSLog(@"当前请求的%@", request);
        NSURLSessionDataTask *operation = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            ZZError *err;
            if (error) {
                err = [[ZZError alloc] initWithDictionary:@{@"message":error.localizedDescription, @"code":@"1111"} error:nil];
            }
            if (responseObject[@"error"]) {
                err = [[ZZError alloc] initWithDictionary:responseObject[@"error"]
                                                    error:nil];
            }
            
            if ([responseObject[@"code"] integerValue] == 400 || [responseObject[@"code"] integerValue] == 304 || [responseObject[@"code"] integerValue] == 305) {
                ZZError *error = [[ZZError alloc] init];
                error.message = responseObject[@"msg"];
                error.code = [responseObject[@"code"] integerValue];
                err = error;
            }
            
            if ([responseObject[@"code"] integerValue] == 405) {
                ZZError *error = [[ZZError alloc] init];
                error.message = responseObject[@"msg"];
                error.code = [responseObject[@"code"] integerValue];
                err = error;
            }
            
            
            if (err.code == 4034) {
                NSRange range = [URLString rangeOfString:@"/api/user/unread2"];
                if (range.location == NSNotFound) {
                    [ZZHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeendrefresh" object:nil];
                    if ([ZZUserHelper shareInstance].oAuthToken) {
                        err = [[ZZError alloc] initWithDictionary:@{@"message":@"请重新登录", @"code":@"1111"} error:nil];
                    } else {
                        err = [[ZZError alloc] initWithDictionary:@{@"message":@"  请登录  ", @"code":@"1111"} error:nil];
                    }
                    [[ZZUserHelper shareInstance] clearLoginer];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"PY_登录界面%s",__func__);
                        if (![response.URL.absoluteString containsString:@"/api/onClickHomePd"]) {
                            [[LoginHelper sharedInstance] showLoginViewIn:[UIApplication sharedApplication].keyWindow.rootViewController];
                        }

                        if (next) {
                            next(err, nil, nil);
                        }
                    });
                }
            }

            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (next) {
                        next(err, err? NULL :responseObject[@"data"], nil);
                    }
                });
            }
        }];
        [operation resume];
        
        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue cancelAllOperations];
                    break;
            }
        }];
        
        [manager.reachabilityManager startMonitoring];
    }];
}

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
                      next:(requestCallback)next {
    
    NSURL *backendURL = [[NSURL alloc] initWithString:kBase_URL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    // 获取IP
    [[HttpDNS shareInstance] getIpByHost:backendURL.host next:^(NSError *error, NSString *ip) {
        NSString *newHost = error? backendURL.host: ip;//当欠费的时候IP 返回的是一串的乱码  这个时候会崩溃的
        ZZAFNHelper *manager = [ZZAFNHelper shareInstance];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = timeOut;
        NSString *oAuthToken = [ZZUserHelper shareInstance].oAuthToken;
        if (!oAuthToken) {
            oAuthToken = [ZZUserHelper shareInstance].publicToken;
        }
        if (!isNullString(oAuthToken)) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",oAuthToken] forHTTPHeaderField:@"X-Api-Token"];
        }
        if (backendURL.host) {
            [manager.requestSerializer setValue:backendURL.host forHTTPHeaderField:@"HOST"];
        }
        
        NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
        [p setObject:@"ios" forKey:@"dev"];
        [p setObject:[UIApplication version] forKey:@"v"];
        NSString* deviceName = [[ZZUtils deviceVersion] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (deviceName) {
            [p setObject:deviceName forKey:@"dev_name"];
        }
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        if (phoneVersion) {
            [p setObject:phoneVersion forKey:@"dev_version"];
        }
        
        NSString *URLString = ({
            NSString *sURL = [NSString stringWithFormat:@"%@://%@", backendURL.scheme,newHost];
            if (backendURL.port) {
                sURL = [sURL stringByAppendingString:[NSString stringWithFormat:@":%@", backendURL.port]];
            }
            sURL = [sURL stringByAppendingString:path];
            NSURL *URL = [[NSURL alloc] initWithString:sURL];
            if (!URL) {
                sURL = [NSString stringWithFormat:@"%@://%@", backendURL.scheme,backendURL.host];
                URL = [[NSURL alloc] initWithString:sURL];
                
            }
            [[URL URLByAppendingParameters:p] absoluteString];
        });
        if (!URLString) {
            return ;
        }
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:URLString parameters:params error:nil];
        
        NSLog(@"当前请求的%@", request);
        NSURLSessionDataTask *operation = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            ZZError *err;
            if (error) {
                err = [[ZZError alloc] initWithDictionary:@{@"message":@"网络错误", @"code":@"1111"} error:nil];
            }
            
            if (responseObject[@"error"]) {
                err = [[ZZError alloc] initWithDictionary:responseObject[@"error"] error:nil];
            }
            if (err.code == 4034) {
                NSRange range = [URLString rangeOfString:@"/api/user/unread2"];
                if (range.location == NSNotFound) {
                    [ZZHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeendrefresh" object:nil];
                    if ([ZZUserHelper shareInstance].oAuthToken) {
                        err = [[ZZError alloc] initWithDictionary:@{@"message":@"请重新登录", @"code":@"1111"} error:nil];
                    } else {
                        err = [[ZZError alloc] initWithDictionary:@{@"message":@"  请登录  ", @"code":@"1111"} error:nil];
                    }
                    [[ZZUserHelper shareInstance] clearLoginer];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"PY_登录界面%s",__func__);
                        [[LoginHelper sharedInstance] showLoginViewIn:[UIApplication sharedApplication].keyWindow.rootViewController];
                        if (next) {
                            next(err, nil, nil);
                        }
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (next) {
                        next(err, err? NULL :responseObject[@"data"], nil);
                    }
                });
            }
        }];
        [operation resume];
        
        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue cancelAllOperations];
                    break;
            }
        }];
        
        [manager.reachabilityManager startMonitoring];
    }];
}
@end
