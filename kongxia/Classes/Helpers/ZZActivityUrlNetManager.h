//
//  ZZActivityUrlNetManager.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
static dispatch_once_t ActivityUrlNetManagerOnce = 0;
__strong static id ActivityUrlNetManagerShareInstace = nil;
/**
 活动管理类
 */
@interface ZZActivityUrlNetManager : NSObject
@property (nonatomic, strong) ZZActivityUrlModel * h5_activity;

+ (ZZActivityUrlNetManager *)shareInstance;

/**
 请求服务器返回的活动
 */
+ (void)requestHtmlActivityUrlDetailInfo;


/**
 服务器开启的h5的活动

 @param viewController 视图控制器
 @param isHaveReceived  是否完成了
 */
+ (void)loadH5ActiveWithViewController:(UIViewController *)viewController isHaveReceived:(BOOL)isHaveReceived callBack:(void(^)(void))CallBack ;
@end
