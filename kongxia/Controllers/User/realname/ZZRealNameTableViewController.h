//
//  ZZRealNameTableViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUser.h"

@interface ZZRealNameTableViewController : UITableViewController

@property (strong, nonatomic) ZZUser *user;
@property (copy, nonatomic) dispatch_block_t successCallBack;
@property (copy, nonatomic) dispatch_block_t logAuthBlock;

@property (nonatomic, assign) BOOL isRentPerfectInfo;//是否是从申请达人完善身份证过来的

@property (nonatomic, assign) BOOL isOpenFastChat;//是否是从申请开通闪聊 完善身份证过来的
@property (nonatomic,assign) BOOL isTiXian;//是否提现.提现界面过来的

@end
