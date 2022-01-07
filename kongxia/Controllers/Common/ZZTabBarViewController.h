//
//  ZZTabBarViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZNewHomeViewController;
@interface ZZTabBarViewController : UITabBarController

@property (nonatomic, strong) ZZNewHomeViewController *neoHomeCtl;

// 单例
+ (instancetype)sharedInstance;

- (void)manageUnreadCountWithCount:(int)redCount;
- (void)manageRedPoint;
- (void)setSelectIndex:(NSInteger)index;
- (void)showGuideView;//显示引导页
- (void)showAuthorityView;////权限弹窗
- (void)getUnread;//获取未读数
- (void)managerAppBadge;//管理角标
- (void)hideBubbleView;//隐藏浮窗（视频录制推荐）
- (void)hideRentBubble;//隐藏闪租浮窗
- (void)showBubbleView:(NSInteger)type;//1、注册后的推荐 2、城市变化的推荐
- (void)dismissRecordViewCntrollerWhenBackgroundInto;//当从后台进入的时候如果跳转到聊天界面的前一个界面是录制界面就让录制界面消失

- (void)resetMenuBtn;

@end
