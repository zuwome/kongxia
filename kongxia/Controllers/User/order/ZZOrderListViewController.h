//
//  ZZOrdeListViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/31.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSInteger,OrderListType) {
    OrderListTypeAll = 0,               //全部
    OrderListTypeIng,                   //进行中
    OrderListTypeComment,               //待评价
    OrderListTypeDone                   //已结束
};

#import "ZZViewController.h"
/**
 *  我的订单列表
 */
@interface ZZOrderListViewController : ZZViewController

@property (nonatomic, assign) OrderListType type;

@end
