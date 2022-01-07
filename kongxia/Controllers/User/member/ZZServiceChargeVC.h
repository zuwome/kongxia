//
//  ZZServiceChargeVC.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/13.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

#define SAVE_RENTINFO_KEY       (@"SAVE_RENTINFO_KEY")

@interface ZZServiceChargeVC : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) BOOL isRenew;//是否是续费操作
@property (nonatomic, assign) BOOL isSaveUser;//不支付直接返回的话，是否需要保存操作的出租信息
@property (nonatomic, assign) BOOL isBackRoot;//返回时 是否返回根视图

@end
