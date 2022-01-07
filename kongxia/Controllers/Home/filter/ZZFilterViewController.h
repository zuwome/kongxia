//
//  ZZFilterViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  搜索界面
 */
@interface ZZFilterViewController : ZZViewController

@property (strong, nonatomic) void(^filterDone)(NSDictionary *params);
@property (strong, nonatomic) NSDictionary *filter;

@end
