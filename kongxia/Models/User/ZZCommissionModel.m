//
//  ZZCommissionModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/12.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionModel.h"
#import "HttpDNS.h"

@implementation ZZCommissionModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"tip" : [ZZCommissionInfoModel class],
             };
}

- (NSString *)inviteURL {
#ifdef DEBUG
    NSString *path = H5Url.shareApp_debug;
    return [NSString stringWithFormat:@"%@&uid=%@&code=%@&name=%@", path, [ZZUserHelper shareInstance].loginer.uid, _code, [ZZUserHelper shareInstance].loginer.nickname];
#else
     return [NSString stringWithFormat:@"%@?channelCode=allChannel&uid=%@&code=%@&name=%@", _tip_b.url, [ZZUserHelper shareInstance].loginer.uid, _code, [ZZUserHelper shareInstance].loginer.nickname];
#endif
}

#pragma mark - getters and setters
- (void)setCode:(NSString *)code {
    _code = code;
#ifdef DEBUG
    NSString *path = H5Url.shareApp_debug;
#else
    NSString *path = H5Url.shareApp;
#endif

    NSString *inviteCode = [NSString stringWithFormat:@"%@&uid=%@&code=%@&name=%@", path, [ZZUserHelper shareInstance].loginer.uid, _code, [ZZUserHelper shareInstance].loginer.nickname];
    _inviteURL = inviteCode;
}

@end


@implementation ZZCommissionInfoModel


@end
