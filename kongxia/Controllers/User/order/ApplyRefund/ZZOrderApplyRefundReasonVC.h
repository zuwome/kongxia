//
//  ZZOrderApplyRefundReasonVC.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZInvitationModel.h"
#import "ZZOrder.h"
/**
 选择原因并上传证据的界面
 */
@interface ZZOrderApplyRefundReasonVC : ZZViewController

/**
原因
 */
@property(nonatomic,strong) ZZInvitationModel *model;
@property (assign, nonatomic) BOOL isFromChat;//是否从聊天界面过来
@property (assign,nonatomic) BOOL  isModify;//是否是修改邀约的
/**
当前订单信息
 */
@property(nonatomic,strong) ZZOrder *order;
@property (nonatomic, copy) void(^callBack)(NSString *status);

@end
