//
//  ZZCacheOrder.h
//  zuwome
//
//  Created by angBiu on 16/9/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZCacheOrder : NSObject <NSCoding>

@property (assign, nonatomic) int hours;
@property (strong, nonatomic) NSDate *dated_at;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) CLLocation *loc;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSDate *currentDate;
@property (assign, nonatomic) BOOL isQuickTime;
@property (nonatomic, assign) BOOL checkWeChat;

// 是否查看微信（默认为YES）
@property (nonatomic, copy) NSString *wechat_service;

@end
