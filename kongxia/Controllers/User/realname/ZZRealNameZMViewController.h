//
//  ZZRealNameZMViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZUser;
/**
 *  芝麻认证
 */
@interface ZZRealNameZMViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t successCallBack;

@property (nonatomic,assign) BOOL isTiXian;//是否提现.提现界面过来的
@end
