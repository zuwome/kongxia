//
//  ZZRentDynamicViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentTypeBaseViewController.h"
/**
 *  他人页动态列表
 */
@interface ZZRentDynamicViewController : ZZRentTypeBaseViewController

@property (assign, nonatomic) BOOL fromLiveStream;  //只显示底部跟她视频
@property (nonatomic, assign) BOOL scrollLock;      //滑动锁

@property (nonatomic, copy) dispatch_block_t pushBarHide;
@property (nonatomic, copy) dispatch_block_t buyWxCallBack;
@property (nonatomic, copy) dispatch_block_t scrollToTop;   //列表滑动到顶部时回调

@end
