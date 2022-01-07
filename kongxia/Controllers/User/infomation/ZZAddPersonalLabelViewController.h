//
//  ZZAddPersonalLabelViewController.h
//  zuwome
//
//  Created by angBiu on 16/6/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZUser;
/**
 *  个人标签编辑
 */
@interface ZZAddPersonalLabelViewController : ZZViewController

@property (nonatomic, copy) dispatch_block_t updateLabel;
@property (nonatomic, strong) ZZUser *user;

@end
