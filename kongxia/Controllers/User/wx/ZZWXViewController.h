//
//  ZZWXViewController.h
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 我的微信页
 */
@interface ZZWXViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t wxUpdate;
@property (nonatomic, assign) BOOL isComeFromChat;

@end
