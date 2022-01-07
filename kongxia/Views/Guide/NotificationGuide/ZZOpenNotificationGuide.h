//
//  ZZOpenSanChatGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBaseEvaluation.h"

/**
 引导用户开通系统通知
 */
@interface ZZOpenNotificationGuide : ZZWeiChatBaseEvaluation




 /**
 通知用户开启系统通知  - 闪聊设置
 @param showViewController 要展示的弹窗的根视图 ,nil 默认为根
 @param heightProportion 当前背景的高度
 @param showMessageTitle 要展示的标题
 @param showImageName 要展示的图片
  注* 内部做了用户是否已经开启通知的判断了
 */
+ (void)showShanChatPromptWhenUserOpenSanChatSwitch:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName;

/**
 通知用户开启系统通知  - 聊天室界面
 注*只是弹出一次

 */
+ (void)showShanChatPromptWhenUserFirstIntoViewController:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName;

/**
 开启通知出租界面

 */
+ (void)openNotificationWhenOpenRentSuccess:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName  showTitleColor:(UIColor *)titleColor;
@end
