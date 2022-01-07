//
//  ZZRealNameNotMainlandViewController.h
//  zuwome
//
//  Created by angBiu on 2017/2/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 非大陆用户实名认证
 */
@interface ZZRealNameNotMainlandViewController : ZZViewController

@property (strong, nonatomic) ZZUser *user;
@property (copy, nonatomic) dispatch_block_t successCallBack;
@property (nonatomic,assign) BOOL isTiXian;//是否提现.提现界面过来的
@end
