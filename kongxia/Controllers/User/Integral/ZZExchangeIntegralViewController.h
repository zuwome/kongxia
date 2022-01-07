//
//  ZZExchangeIntegralViewController.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZIntegralModel.h"
/**
 积分兑换界面
 */
@interface ZZExchangeIntegralViewController : ZZViewController
@property (nonatomic,strong) ZZIntegralModel *model;

/**
 积分变动后更改  我的积分总额
 */
@property (nonatomic,copy)  void(^changeBlock)(ZZIntegralModel *model);
@end
