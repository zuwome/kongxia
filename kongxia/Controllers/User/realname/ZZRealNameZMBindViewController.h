//
//  ZZRealNameZMBindViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZUser;
/**
 *  芝麻信用绑定界面
 */
@interface ZZRealNameZMBindViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t successCallBack;

@end
