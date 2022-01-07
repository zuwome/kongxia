//
//  ZZOrderRefuseRefundViewController.h
//  zuwome
//
//  Created by angBiu on 2017/8/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZOrder.h"

/**
 拒绝退款理由
 */
@interface ZZOrderRefuseRefundViewController : ZZViewController

@property (nonatomic, strong) ZZOrder *order;
@property (copy, nonatomic) void(^callBack)(NSString *status);//状态返回改变头部状态

@end
