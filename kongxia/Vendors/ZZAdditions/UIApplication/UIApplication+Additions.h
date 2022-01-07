//
//  UIApplication+Additions.h
//  danpian
//
//  Created by wlsy on 14/11/11.
//  Copyright (c) 2014年 mou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (Additions)

+ (id)objectForKey:(NSString *)key;

/// Save an object in NSUserDefaults.
/// @param object An NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary object.
/// @param key The associated key.
+ (void)setObject:(id)object forKey:(NSString *)key;


+ (NSString *)bundleName;
+ (NSString *)version;
+ (CGSize)screenSize;

@end
