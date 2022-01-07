//
//  ZZAFNHelper.m
//  zuwome
//
//  Created by angBiu on 16/8/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAFNHelper.h"

@implementation ZZAFNHelper

static AFHTTPSessionManager *manager;

+ (id)shareInstance //获取网络请求单例
{
    __strong static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 15;
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 是否允许,NO-- 不允许无效的证书
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        //设置证书
        [securityPolicy setPinnedCertificates:certSet];
        manager.securityPolicy = securityPolicy;
    });
    
    return manager;
}

+ (AFURLSessionManager *)sharedURLSession
{
    
    __strong static AFURLSessionManager *urlsession = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        urlsession = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return urlsession;
}

@end
