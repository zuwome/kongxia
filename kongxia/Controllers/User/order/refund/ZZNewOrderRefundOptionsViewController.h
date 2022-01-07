//
//  ZZNewOrderRefundOptionsViewController.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZOrder.h"


/**
 意向金 退款新界面 用户主动退款界面
 */
@interface ZZNewOrderRefundOptionsViewController : ZZViewController
@property (nonatomic, strong) ZZOrder *order;
@property (assign, nonatomic) BOOL isFromChat;//是否从聊天界面过来
@property (assign,nonatomic) BOOL  isModify;//是否是修改邀约的

@property (nonatomic, copy) void(^callBack)(NSString *status);

@end
