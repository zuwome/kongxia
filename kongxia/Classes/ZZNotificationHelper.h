//
//  ZZNotificationHelper.h
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  推送相关
 */
@interface ZZNotificationHelper : NSObject

@property (nonatomic, assign) BOOL firstLoad;

- (void)managerNotification:(NSDictionary *)userInfo application:(UIApplication *)application window:(UIWindow *)window;

@end
