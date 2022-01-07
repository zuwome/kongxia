//
//  ZZOrderDetailViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZOrder.h"
/**
 *  订单详情页界面
 */
@interface ZZOrderDetailViewController : ZZViewController

@property (strong, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL isFromChat;//是否从聊天界面过来
@property (copy, nonatomic) void(^callBack)(NSString *status);//状态返回改变头部状态
@property (copy, nonatomic) void(^orderChange)(ZZOrder *order);//修改订单
//@property (copy, nonatomic) void(^orderTextChange)();
@property (nonatomic, assign) BOOL firstPay;//意向金过来

@end
