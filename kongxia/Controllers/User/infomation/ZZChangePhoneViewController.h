//
//  ZZChangePhoneViewController.h
//  zuwome
//
//  Created by angBiu on 16/6/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@class ZZUser;
/**
 *  修改绑定的手机号
 */
@interface ZZChangePhoneViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t updateBlock;
@property (nonatomic, assign) ChangeMobileStep step;

- (instancetype)initWithStep:(ChangeMobileStep)step;
@end
