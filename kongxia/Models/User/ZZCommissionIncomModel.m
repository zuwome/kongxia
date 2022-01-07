//
//  ZZCommissionIncomModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionIncomModel.h"

@implementation ZZCommissionIncomModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"to" : [ZZUser class],
             };
}

@end
