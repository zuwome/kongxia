//
//  ZZOrderNotificationHelper.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderNotificationHelper.h"
#import <RongIMKit/RongIMKit.h>
#import "ZZChatOrderInfoModel.h"
@implementation ZZOrderNotificationHelper
/**
 本地的推送
 
 @param notification 订单本地推送
 */
+ (void)localPushNotificationMessage:(RCMessage*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZChatOrderInfoModel *messageModel = (ZZChatOrderInfoModel *)message.content;
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.soundName=UILocalNotificationDefaultSoundName;
        if ([messageModel.typeContent isEqualToString:@""]||messageModel.typeContent ==nil) {
            messageModel.typeContent = @"收到一条新的信息";
        }
        notification.alertBody = messageModel.typeContent;
        notification.repeatInterval = 0;
        notification.userInfo = @{@"rc":@{@"fId":[ZZUserHelper shareInstance].loginer.uid,
                                          @"tId":message.targetId,
                                          @"oName":message.objectName,
                                          @"mId":[NSNumber numberWithLong:message.messageId]}};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    });
}


/**
 远端的推送
 
 @param notification 订单远端推送
 */
+ (void)remotePushNotification:(NSNotification *)remoteNotification {
    
}
@end
