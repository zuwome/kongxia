//
//  ZZUUIDManager.m
//  zuwome
//
//  Created by qiming xiao on 2019/2/12.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZUUIDManager.h"
#import "WBKeyChain.h"

@interface ZZUUIDManager ()

@end

@implementation ZZUUIDManager

+ (NSString *)getUUID {
    NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
    if ([uuid isEqualToString: @""] || !uuid) {
        // 生成uuid
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        // 将该uuid用keychain存储
        [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
        [[ZZUserHelper shareInstance].loginer updateWithParam:@{@"uuid" : uuid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                
            }
        }];
    }
    
    return uuid;
}

@end
