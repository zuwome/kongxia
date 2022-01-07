//
//  ZZLiveStreamAcceptController.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/6.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/**
 女方接受或者拒绝视频
 */
@interface ZZLiveStreamAcceptController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) dispatch_block_t touchAccept;
@property (nonatomic, copy) dispatch_block_t touchRefuse;

@property (nonatomic, copy) dispatch_block_t timeOut;

@property (nonatomic, assign) BOOL isValidation;//是否需要验证对方已经离开房间

- (void)remove;

@end
