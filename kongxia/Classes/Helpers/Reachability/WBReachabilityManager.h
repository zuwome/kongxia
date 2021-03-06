//
//  WBReachabilityManager.h
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/1.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBBaseManager.h"

#define GetReachabilityManager()        ([WBReachabilityManager sharedInstance])

@protocol WBReachabilityObserver <NSObject>

- (void)reachabilityNetworkStatusChanged;

@end

////////////////////////////////////////////////////////////////////////

@interface WBReachabilityManager : WBBaseManager

@property (nonatomic, readonly) BOOL isReachable;
@property (nonatomic, readonly) BOOL isReachableViaWiFi;	// 通过 WiFi 连接
@property (nonatomic, readonly) BOOL isReachableViaWWAN;	// 通过移动网络连接
@property (nonatomic,copy) void(^netWorkStatus)(AFNetworkReachabilityStatus status);

@property (nonatomic, readonly) NSString *networkTypeString;

// 判断是否是慢速网络，比如 2G
- (BOOL)isSlowlyNetworking;

@end
