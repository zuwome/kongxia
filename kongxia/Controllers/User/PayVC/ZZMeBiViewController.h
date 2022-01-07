//
//  ZZMeBiViewController.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//么币界面

#import "ZZViewController.h"
@class ZZUser;
@interface ZZMeBiViewController : ZZViewController
@property(nonatomic,strong)ZZUser *user;
@property (nonatomic,copy) void(^paySuccess)(ZZUser *paySuccesUser);
@property (nonatomic,copy) void(^callBlack)(void);

@end
