//
//  ZZSanChatGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//闪聊列表引导页,不管是不是登录只是弹出一次

#import <UIKit/UIKit.h>

@interface ZZSanChatGuide : UIView

/**
 显示闪聊引导页
 */
+ (void)ShowSanChatGuide;

//调用
/*
NSString *fistkey = [NSString stringWithFormat:@"%@%@",@"ZZSanChatGuideKey",[ZZUserHelper shareInstance].loginer.uid];
NSString *string = [ZZKeyValueStore getValueWithKey:fistkey];
if (!string) {
    [ZZSanChatGuide ShowSanChatGuide];
}
[ZZKeyValueStore saveValue:@"ZZSanChatGuideKey" key:fistkey];
 */
@end
