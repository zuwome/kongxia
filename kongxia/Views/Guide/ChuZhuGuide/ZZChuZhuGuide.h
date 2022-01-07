//
//  ZZChuZhuGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//出租的引导页

#import <UIKit/UIKit.h>

@interface ZZChuZhuGuide : UIView

/**
 显示闪聊引导页

 @param view 去申请的view覆盖的cell
 */
+ (void)ShowChuZhuGuideWithShowView:(UIView *)view goToApply:(void(^)(void))goToApplyCallBlack;

@end
