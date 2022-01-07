//
//  ZZAgeEditTableViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZBaseTableViewController.h"
@class ZZUser;

@interface ZZAgeEditTableViewController : ZZBaseTableViewController

@property (nonatomic, assign) BOOL isChuzu;
@property (strong, nonatomic) NSDate *defaultBirthday;
@property (strong, nonatomic) void(^dateChangeBlock)(NSDate *birthday);
@property (strong, nonatomic) ZZUser *user;

@end
