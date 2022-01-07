//
//  WBKeyChain.h
//  WanShoes
//
//  Created by YuTianLong on 2017/5/17.
//  Copyright © 2017年 WXYS. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const USERNAME_KEY = @"USERNAME_KEY";
static NSString *const PASSWORD_KEY = @"PASSWORD_KEY";

@interface WBKeyChain : NSObject

/**
*  存储字符串到 KeyChain
*
*  @param string  content
*  @param key     key
*/
+ (void)keyChainSave:(NSString *)string key:(NSString *)key;

/**
 *  从 KeyChain 中读取存储的字符串
 *
 *  @param key key
 *
 *  @return content
 */
+ (NSString *)keyChainLoadWithKey:(NSString *)key;

/**
 *  从 KeyChain 中删除某个key与value
 */
+ (void)keyChainDeleteWithKey:(NSString *)key;

/**
 *  删除整个 KeyChain 信息
 */
+ (void)keyChainDelete;

@end
