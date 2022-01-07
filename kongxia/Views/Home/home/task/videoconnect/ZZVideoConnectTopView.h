//
//  ZZVideoConnectTopView.h
//  zuwome
//
//  Created by YuTianLong on 2018/1/17.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZVideoConnectTopView : UIView

@property (nonatomic, copy) void (^gotoWaitingBlock)(void);//进入等待页面
@property (nonatomic, copy) void (^hangUpButtonBlock)(void);//挂断
@property (nonatomic, copy) void (^throughButtonBlock)(void);//接通
@property (nonatomic, strong) UIImageView *shadowView;//阴影层
@property (nonatomic, assign) NSInteger count;//倒计时变量(外部用于传递到等待页面 剩余时间/毫秒计算)

@property (nonatomic, strong) ZZUser *user;

- (void)dismiss;

@end
