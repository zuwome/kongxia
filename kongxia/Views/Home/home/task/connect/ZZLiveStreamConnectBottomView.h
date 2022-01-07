//
//  ZZLiveStreamConnectBottomView.h
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLiveStreamConnectBottomView : UIView

@property (nonatomic, strong) UIView *alertBgView;
@property (nonatomic, strong) UIView *itemView;//镜头选项
@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, assign) BOOL acceped;
@property (nonatomic, assign) BOOL isEnableVideo;//是否开启摄像头

@property (nonatomic, copy) dispatch_block_t touchRecharge; // 充值
@property (nonatomic, copy) dispatch_block_t touchCancel;   // 挂断
@property (nonatomic, copy) void (^touchCameraBlock)(void);// 翻转摄像头
@property (nonatomic, copy) void (^touchDisableVideo)(void);//关闭摄像头
@property (nonatomic, copy) void (^touchEnableVideo)(void);//开启摄像头
@property (nonatomic, copy) void (^showFilter)(void);//滤镜
- (void)hideAllView;

@end
