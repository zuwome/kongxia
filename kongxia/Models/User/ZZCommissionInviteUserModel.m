//
//  ZZCommissionInviteUserModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionInviteUserModel.h"

@implementation ZZCommissionInviteUserModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"allUserList" : [ZZCommissionInviteUserInfoModel class],
             };
}

@end


@implementation ZZCommissionInviteUserInfoModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"to" : [ZZUser class],
             };
}

@end
