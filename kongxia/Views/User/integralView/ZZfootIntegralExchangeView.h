//
//  ZZfootIntegralExchangeView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/22.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 兑换积分 - 自定义数量
 */
@interface ZZfootIntegralExchangeView : UIView

/**
 自定义兑换积分的点击事件
 */
@property (nonatomic,copy) void(^exChangeBlock)(UIButton *sender);
@end
