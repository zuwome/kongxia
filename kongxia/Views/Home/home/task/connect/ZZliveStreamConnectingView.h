//
//  ZZliveSteamConnectingView.h
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  1V1连接中等待页面
 */

@interface ZZliveStreamConnectingView : UIView

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, assign) BOOL showCancel;//是否是发起方
@property (nonatomic, assign) BOOL accept;

@property (nonatomic, copy) dispatch_block_t timeOut;
@property (nonatomic, copy) void (^noPenaltyBlock)(BOOL is);//因为对方10秒未接或挂断，不算发单人次数的回调

- (void)show;
- (void)remove;

@end
