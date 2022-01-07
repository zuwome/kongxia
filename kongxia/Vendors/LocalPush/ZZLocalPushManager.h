//
//  ZZLocalPushManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/9/30.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"
#import "ZZSoundToolsManager.h"

#define GetLocalPushManager()   ([ZZLocalPushManager sharedInstance])

@interface ZZLocalPushManager : WBBaseManager

// 发送本地推送
- (void)localPushWithContent:(NSDictionary *)content;

// 取消所有本地推送
+ (void)cancelLocalAllNotification;

// App 是否处于前台
+ (BOOL)runningInForeground;

// App 是否处于后台
+ (BOOL)runningInBackground;
// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key;
/**
 连麦的key
 
 */
+ (NSString *)callIphoneKey;
/**
 派单的key
 */
+ (NSString *)sendOrders;
@end
