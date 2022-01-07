//
//  ZZUserDefaultsHelper.m
//  zuwome
//
//  Created by angBiu on 16/5/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserDefaultsHelper.h"

@implementation ZZUserDefaultsHelper

+ (void)setObject:(id)destObj forDestKey:(NSString *)destKey
{
    [[NSUserDefaults standardUserDefaults] setObject:destObj forKey:destKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForDestKey:(NSString *)destkey
{
    id object = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    object = [[NSUserDefaults standardUserDefaults] objectForKey:destkey];
    return object;
}

+ (void)removeObjectForDestKey:(NSString *)destkey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:destkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
