//
//  ZZKeyValueStore.m
//  zuwome
//
//  Created by angBiu on 2017/2/28.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZKeyValueStore.h"

#import <YTKKeyValueStore/YTKKeyValueStore.h>

@implementation ZZKeyValueStore

+ (id)getValueWithKey:(NSString *)key
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:@"user_table"];
    NSDictionary *aDict = [store getObjectById:key fromTable:@"user_table"];
    id object = [aDict objectForKey:@"value"];//旧版的写错。。只能判断两者其中一个有就返回
    return object ? object:aDict;
}

+ (void)saveValue:(id)value key:(NSString *)key
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:@"user_table"];
    NSDictionary *aDict = @{@"value":value};
    [store putObject:aDict withId:key intoTable:@"user_table"];
}

+ (id)getValueWithKey:(NSString *)key tableName:(NSString *)tableName
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:tableName];
    NSDictionary *aDict = [store getObjectById:key fromTable:tableName];
    id object = [aDict objectForKey:@"value"];//旧版的写错。。只能判断两者其中一个有就返回
    return object ? object:aDict;
}

+ (void)saveValue:(id)value key:(NSString *)key tableName:(NSString *)tableName
{
    if (!value) {
        return;
    }
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:tableName];
    NSDictionary *aDict = @{@"value":value};
    [store putObject:aDict withId:key intoTable:tableName];
}

+ (void)clearTable:(NSString *)tableName
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store clearTable:tableName];
}

+ (void)cleanObject:(NSString *)key {
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:@"user_table"];
    
    [store deleteObjectById:key fromTable:@"user_table"];
}

+ (void)createTable:(NSString *)tableName {
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:tableName];
}

@end
