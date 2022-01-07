//
//  ZZNewTiXianViewController.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/**
新版的提现
 */
@interface ZZNewTiXianViewController : ZZViewController
@property (nonatomic, strong) NSNumber *amount;
@property (strong, nonatomic) ZZUser *user;
@property (nonatomic,assign) BOOL isTiXian;//是否是实名认证到的提现

/**
 提现成功
 */
@property (nonatomic,copy)  dispatch_block_t  tiXianBlock;
@end
