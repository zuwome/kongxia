//
//  ZZSnatchModel.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSnatchModel.h"

@implementation ZZSnatchDetailModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"skill" : [ZZSkill class],
             @"from": [ZZUser class],
             };
}

@end

@implementation ZZSnatchModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
