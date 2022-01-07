//
//  ZZKeyValueStore.h
//  zuwome
//
//  Created by angBiu on 2017/2/28.
//  Copyright © 2017年 zz. All rights reserved.
//

#define kTableName_VideoSave  @"TableName_VideoSave"

#import <Foundation/Foundation.h>

@interface ZZKeyValueStore : NSObject

/**
 获取存储的数据

 @param key key
 @return value
 */
+ (id)getValueWithKey:(NSString *)key;
/**
 数据存储

 @param value value
 @param key key
 */
+ (void)saveValue:(id)value key:(NSString *)key;
/**
 获取存储的数据
 
 @param key key
 @return value
 */
+ (id)getValueWithKey:(NSString *)key tableName:(NSString *)tableName;
/**
 数据存储 --- 表区分开
 @param value value
 @param key key
 */
+ (void)saveValue:(id)value key:(NSString *)key tableName:(NSString *)tableName;

/**
 清除某个表的数据
 @param tableName tableName
 */
+ (void)clearTable:(NSString *)tableName;


+ (void)cleanObject:(NSString *)key;

+ (void)createTable:(NSString *)tableName;

@end
