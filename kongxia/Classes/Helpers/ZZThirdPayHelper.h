//
//  ZZThirdPayHelper.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

/**
 *  第三方支付管理
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZThirdPayHelper : NSObject

//查询订单支付状态
+ (void)pingxxRetrieve:(NSString *)payId next:(requestCallback)next;

@end

NS_ASSUME_NONNULL_END
