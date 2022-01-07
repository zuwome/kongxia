//
//  ZZBindViewController.h
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZUser;
/**
 *  账号绑定
 */
@interface ZZBindViewController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t updateBind;
@property (nonatomic, copy) dispatch_block_t updateRedPoint;
@property (nonatomic, copy) dispatch_block_t bindWeiBoSuccessBlock;//绑定微博成功

@end
