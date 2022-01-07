//
//  ZZRuleHelper.h
//  zuwome
//
//  Created by wlsy on 16/1/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZRequest.h"
/**
 *  选择理由
 */
@interface ZZRuleHelper : NSObject

+ (void)pullRefuseList:(requestCallback)next;
+ (void)pullCancelList:(requestCallback)next;
+ (void)pullRefundList:(requestCallback)next;
+ (void)pullAppealList:(requestCallback)next;
+ (void)pullDepositList:(requestCallback)next;
+ (void)pullRefund:(NSDictionary *)param next:(requestCallback)next;

@end
