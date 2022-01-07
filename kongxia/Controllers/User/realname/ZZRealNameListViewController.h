//
//  ZZRealNameListViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZUser;
/**
 *  实名认证列表
 */
@interface ZZRealNameListViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, assign) BOOL isRentPerfectInfo;//是否是从申请达人完善身份证过来的

@property (nonatomic, assign) BOOL isOpenFastChat;//是否是从申请开通闪聊 完善身份证过来的

@property (nonatomic,assign) BOOL isTiXian;//是否提现.提现界面过来的

@property (nonatomic,copy) dispatch_block_t blackBlock;//返回按钮

@property (copy, nonatomic) dispatch_block_t successCallBack;
@end
