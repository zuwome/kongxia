//
//  ZZLocalPushManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/9/30.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZLocalPushManager.h"
#import "ZZPushMessage.h"
#import "ZZSnatchReceiveModel.h"
#import "ZZPublishModel.h"
#import "ZZNotificationHelper.h"
#import "ZZLiveStreamHelper.h"
//#import "ZZCallIphoneVideoManager.h"

#import <UserNotifications/UserNotifications.h>
@interface ZZLocalPushManager ()

@end

@implementation ZZLocalPushManager

- (void)localPushWithContent:(NSDictionary *)content {
    
    // 如果不是在后台，则不本地推送
    if (![ZZLocalPushManager runningInBackground]) {
        return;
    }
    NSNumber *isShanliao = [content objectForKey:@"by_mcoin"];
    
    if ([isShanliao integerValue] == 0 &&[[content allKeys]  containsObject: @"by_mcoin"] ) {
        // 判断开关是否开启 及 是否在有效时间 抢单的
        if (![ZZUserHelper shareInstance].loginer.push_config.pd_can_push) {
            return;
        }
    }
    NSInteger type = [[content objectForKey:@"type"] integerValue];
 
    [ZZLocalPushManager sendNotificationWhenIOS10AfterWithContent:content type:type];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    [self cancelLocalNotificationWhenIOS10AfterWithKey:key];
}


/**
 取消全部通知
 */
+ (void)cancelLocalAllNotification {
    [self cancelLocalAllNotificationWhenIOS10After];
}

/**
 是否为前台模式

 @return YES 在前台  NO 为后台
 */
+ (BOOL)runningInForeground {
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}


/**
 是否为后台模式

 @return YES 为后台  NO在前台
 */
+ (BOOL)runningInBackground {
    __block UIApplicationState state = UIApplicationStateInactive;
    dispatch_async(dispatch_get_main_queue(), ^{
        state = [UIApplication sharedApplication].applicationState;
    });
    
    BOOL result = (state == UIApplicationStateBackground);
    return result;
}

#pragma mark - iOS  10 以后的推送

/**
 发出通知 -- iOS 10 以后

 @param content 通知的详细内容
 @param type 通知的类型
 */
+ (void)sendNotificationWhenIOS10AfterWithContent:(NSDictionary *)content type:(NSInteger)type {
    UNMutableNotificationContent *centerNotification = [[UNMutableNotificationContent alloc] init];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
    centerNotification.sound = [UNNotificationSound defaultSound];
    
    NSString *alertBody = @"";
    if (type == 2) {    // 收到派单
        ZZSnatchReceiveModel *model = [[ZZSnatchReceiveModel alloc] initWithDictionary:content error:nil];
        
        if (model.pd_receive.pd.type == 2) {
            // 收到线上单
            alertBody = @"您有一个新的可抢任务，请立即查看";
        } else {
            // 收到线下单
            alertBody = @"您有一个新的可抢任务，请立即查看";
        }
   
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_NewPublishOrder object:nil userInfo:nil];
        
    } else if (type == 3) { // 单被抢了
        NSDictionary *aDict = [content objectForKey:@"pd_graber"];
        ZZPublishModel *model = [[ZZPublishModel alloc] initWithDictionary:aDict error:nil];
        if (model.pd.type == 2) {
            // 收到线上单
            alertBody = @"您的闪租线上任务已被抢，请立即查看";
        } else {
            // 收到线下单
            alertBody = @"您的闪租线下任务已被抢，请立即查看";
        }
    } else if (type == 4 || type == 5) {
        centerNotification.sound= [UNNotificationSound soundNamed:@"zz_callVideo.caf"];
        if (type == 4) {
            alertBody = @"你抢的任务已被选择, 请立即查看";
            [GetSoundToolsManager() starAlertSound];//抢了单，处于后台要震动
        } else {
            ZZUser *user = [ZZUser yy_modelWithJSON:[content objectForKey:@"user"]];// [[ZZUser alloc] initWithDictionary:[content objectForKey:@"user"] error:nil];
            alertBody = [NSString stringWithFormat:@"%@邀请您视频通话,视频结束后获得收益", user.nickname];
            [GetSoundToolsManager() starAlertSound];//后台震动
        }
    }
    else if (type == 201||type ==302){
        alertBody = content[@"content"];
        if ([alertBody isEqualToString:@""]||alertBody ==nil) {
            alertBody = @"您收到一条新的消息";
        }
    }else if(type == 21){
        alertBody = content[@"content"];
        if ([alertBody isEqualToString:@""]||alertBody ==nil) {
            alertBody = @"您收到一条新的消息";
        }
        centerNotification.userInfo = @{@"type":@"21",@"_id_":Event_click_notification_weiChat_pay};
    }else  {
        alertBody = content[@"content"];
        if ([alertBody isEqualToString:@""]||alertBody ==nil) {
            alertBody = @"您收到一条新的消息";
        }
    }
    // 通知内容
    centerNotification.body = alertBody;
    UNNotificationRequest *request ;
    if (type ==4 ||type == 5) {
        request = [UNNotificationRequest requestWithIdentifier:[self callIphoneKey] content:centerNotification trigger:trigger];
    }
    else if (type ==2) {
           request = [UNNotificationRequest requestWithIdentifier:[self sendOrders] content:centerNotification trigger:trigger];
    }
    else  {
      request  = [UNNotificationRequest requestWithIdentifier:[self defaultKey] content:centerNotification trigger:trigger];
    }
    
    // 将通知加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
        
    }];


}

/**
 取消通知 -- iOS 10以后
 @param key 被取消的标识符
 */
+ (void)cancelLocalNotificationWhenIOS10AfterWithKey:(NSString *)key {
    
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[key]];
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[key]];
}

/**
 取消全部通知  -- iOS  10 以后
 */
+ (void)cancelLocalAllNotificationWhenIOS10After {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}
#pragma mark - iOS 10 以下的推送
+ (void)sendNotificationWithContent:(NSDictionary *)content type:(NSInteger)type {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    //设置声音
    notification.soundName = UILocalNotificationDefaultSoundName;

    NSString *alertBody = @"";
    if (type == 2) {    // 收到派单
        ZZSnatchReceiveModel *model = [[ZZSnatchReceiveModel alloc] initWithDictionary:content error:nil];
        
        if (model.pd_receive.pd.type == 2) {
            // 收到线上单
            alertBody = @"您有一个新的可抢订单，请立即查看";
        } else {
            // 收到线下单
            alertBody = @"您有一个新的邀约可抢，请立即查看";
        }
        NSDictionary * inforDic = [NSDictionary dictionaryWithObject:[self sendOrders] forKey:[self sendOrders]];
        notification.userInfo =inforDic;
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_NewPublishOrder object:nil userInfo:nil];
     
        
    } else if (type == 3) { // 单被抢了
        NSDictionary *aDict = [content objectForKey:@"pd_graber"];
        ZZPublishModel *model = [[ZZPublishModel alloc] initWithDictionary:aDict error:nil];
        if (model.pd.type == 2) {
            // 收到线上单
            alertBody = @"您的闪租线上任务已被抢，请立即查看";
        } else {
            // 收到线下单
            alertBody = @"您的闪租线下任务已被抢，请立即查看";
        }
    } else if (type == 4 || type == 5) {
        notification.soundName=@"zz_callVideo.caf";
        NSDictionary * inforDic = [NSDictionary dictionaryWithObject:[self callIphoneKey] forKey:[self callIphoneKey]];
        notification.userInfo =inforDic;
        if (type == 4) {
            alertBody = @"你抢的任务已被选择, 请立即查看";
            [GetSoundToolsManager() starAlertSound];//抢了单，处于后台要震动
        } else {
            ZZUser *user = [ZZUser yy_modelWithJSON:[content objectForKey:@"user"]]; //[[ZZUser alloc] initWithDictionary:[content objectForKey:@"user"] error:nil];
            alertBody = [NSString stringWithFormat:@"%@邀请您视频通话,视频结束后获得收益", user.nickname];
            [GetSoundToolsManager() starAlertSound];//后台震动
        }
    }
    
    else if (type == 201||type ==302){
        alertBody = content[@"content"];
        if ([alertBody isEqualToString:@""]||alertBody ==nil) {
            alertBody = @"您收到一条新的消息";
        }
    }else if(type == 21){
        alertBody = content[@"content"];
        if ([alertBody isEqualToString:@""]||alertBody ==nil) {
            alertBody = @"您收到一条新的消息";
        }
        notification.userInfo = @{@"type":@"21",@"_id_":Event_click_notification_weiChat_pay};
    } else {
        alertBody = content[@"content"];
        if ([alertBody isEqualToString:@""]||alertBody ==nil) {
            alertBody = @"您收到一条新的消息";
        }
    }
    // 通知内容
    notification.alertBody = alertBody;
  
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];   // 立即发送
}
/**
 取消通知
 @param key 被取消的标识符
 */
+ (void)cancelLocalNotificationWhenIOS10FollowingWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray<UILocalNotification *> *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
    
}
/**
 取消全部通知
 */
+ (void)cancelLocalAllNotificationWhenIOS10Following {
    NSArray<UILocalNotification *> *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}
#pragma mark - 通知的相关key

/**
 连麦的key

 */
+ (NSString *)callIphoneKey {
    return @"callKey";
}

/**
 默认的通知的key

 @return
 */
+ (NSString *)defaultKey {
    return @"defaultKey";
}


/**
 派单
 */
+ (NSString *)sendOrders {
    return @"sendOrders";
}

@end
