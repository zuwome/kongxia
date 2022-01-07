//
//  ZZGeneralOpenSanChatGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 通用的闪聊引导页
 */
@interface ZZGeneralOpenSanChatGuide : UIView
@property (nonatomic, copy) dispatch_block_t open_SanChat;//开通闪聊
+ (ZZGeneralOpenSanChatGuide *)generalOpenSanChatGuideWithNav:(UINavigationController *)Nav ;
-  (void)addAnimotion;
@end
