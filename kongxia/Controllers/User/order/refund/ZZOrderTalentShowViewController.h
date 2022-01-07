//
//  ZZOrderTalentShowViewController.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZOrder.h"
/**
 意向金达人取消预约
 */
@interface ZZOrderTalentShowViewController : ZZViewController
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) ZZOrder *order;
@property (nonatomic,assign) BOOL isFrom;//是否是订单的发起方
@property (nonatomic,assign) BOOL isRefusedInvitation;//拒绝邀约
@property (nonatomic, copy) void(^callBack)(NSString *status);

@end
