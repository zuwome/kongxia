//
//  ZZBillingRecordsViewController.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//账单记录

#import "ZZViewController.h"
typedef enum : NSUInteger{
    BillingRecordsStyle_Balance = 0,//余额
    BillingRecordsStyle_MeBi = 1, //么币
} BillingRecordsStyle;
@interface ZZBillingRecordsViewController : ZZViewController

@property(nonatomic,assign) BillingRecordsStyle recordStyle;
@end
