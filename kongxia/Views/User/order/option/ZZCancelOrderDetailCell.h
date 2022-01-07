//
//  ZZCancelOrderDetailCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrder.h"
/**
 退意向金的订单详情的cell
 或退款的cell
 */
@interface ZZCancelOrderDetailCell : UITableViewCell

/**
 订单详情
 */
@property(nonatomic,strong) ZZOrder *order;


/**
 订单的详情的点击事件
 */
@property(nonatomic,copy) dispatch_block_t goToOrderInfo;

@end
