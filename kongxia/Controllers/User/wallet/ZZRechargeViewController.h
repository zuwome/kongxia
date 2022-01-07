//
//  ZZRechargeViewController.h
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  充值
 */
@interface ZZRechargeViewController : ZZViewController

@property (strong, nonatomic) NSNumber *balance;
@property (strong, nonatomic) NSString *forzen;//锁定金额

@property (copy, nonatomic) dispatch_block_t rechargeCallBack;
@property (copy, nonatomic) dispatch_block_t leftCallBack;

@end
