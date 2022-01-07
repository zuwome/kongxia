//
//  ZZSMS.m
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSMS.h"
#import "WBKeyChain.h"
@implementation ZZSMS

+ (void)sendCodeByPhone:(NSDictionary *)param next:(requestCallback)next {
    NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
    if (isNullString(uuid)) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    NSMutableDictionary *uploadParam = [NSMutableDictionary dictionary];
    [uploadParam addEntriesFromDictionary:param];
    [uploadParam setObject:uuid forKey:@"uuid"];
    [ZZRequest method:@"POST" path:@"/sms/send" params:uploadParam next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)verifyPhone:(NSString *)phone code:(NSString *)code next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/sms/verify" params:@{@"phone":phone, @"code":code} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
