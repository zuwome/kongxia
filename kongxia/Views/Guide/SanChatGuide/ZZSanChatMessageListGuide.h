//
//  ZZSanChatMessageListGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 会话列表女性开通闪聊的引导
 */
@interface ZZSanChatMessageListGuide : UIView


/**
 会话列表女性开通闪聊的引导
注* 每次启动的时候如果服务器允许的情况下就展示,即使用户已经关闭

 @param CloseClick 关闭开启状态
 */
+ (ZZSanChatMessageListGuide*)showOpenMessageListGuideCloseClick:(void(^)(void))closeClick nav:(UINavigationController *)nav;
@end
