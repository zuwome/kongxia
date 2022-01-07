//
//  ZZOrderNotificationHelper.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//订单的推送

#import <Foundation/Foundation.h>
@class RCMessage ;

@interface ZZOrderNotificationHelper : NSObject


/**
 本地的推送

 @param notification 订单本地推送
 */
+ (void)localPushNotificationMessage:(RCMessage*)message;


/**
 远端的推送

 @param notification 订单远端推送
 */
+ (void)remotePushNotification:(NSNotification *)remoteNotification;
@end
