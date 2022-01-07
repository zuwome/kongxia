//
//  ZZUserDefaultsHelper.h
//  zuwome
//
//  Created by angBiu on 16/5/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZUserDefaultsHelper : NSObject

// 本类用来 简化保存持久化数据的操作, 基于 NSUserDefaults

// 添加
+ (void)setObject:(id)destObj forDestKey:(NSString *)destKey;

// 读取
+ (id)objectForDestKey:(NSString *)destkey;

// 删除
+ (void)removeObjectForDestKey:(NSString *)destkey;

@end
