//
//  ZZNewOrderRefuseReasonViewController.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZOrder.h"

/**
 新的退款拒绝理由
 */
@interface ZZNewOrderRefuseReasonViewController : ZZViewController
@property (nonatomic, strong) ZZOrder *order;
@property (copy, nonatomic) void(^callBack)(NSString *status);//状态返回改变头部状态
@end
