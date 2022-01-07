//
//  ZZShanChatNotificationHelper.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZZShanChatNotificationHelper : NSObject
/**
 本地的推送
 

 */
+ (void)localPushNotificationMessageDic:(NSDictionary*)dic tabbarViewController:(UITabBarController *)tabbarVC;
@end
