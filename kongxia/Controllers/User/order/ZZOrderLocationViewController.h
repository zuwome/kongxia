//
//  ZZOrderLocationViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 订单位置详情页
 */
@interface ZZOrderLocationViewController : ZZViewController

@property (nonatomic, copy) NSString *naviTitle;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *name;

@end
