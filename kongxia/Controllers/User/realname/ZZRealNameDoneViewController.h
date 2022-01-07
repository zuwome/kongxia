//
//  ZZRealNameDoneViewController.h
//  zuwome
//
//  Created by angBiu on 16/5/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZUser;

@interface ZZRealNameDoneViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) BOOL isAbroad;
@property (nonatomic,assign) BOOL isTiXian;//是否提现.提现界面过来的

@end
