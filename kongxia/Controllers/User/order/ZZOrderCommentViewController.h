//
//  ZZOrderCommentViewController.h
//  zuwome
//
//  Created by angBiu on 2017/3/31.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

#import "ZZOrder.h"

/**
 订单评论
 */
@interface ZZOrderCommentViewController : ZZViewController

@property (nonatomic, strong) ZZOrder *order;
@property (nonatomic, copy) dispatch_block_t successCallBack;

@end
