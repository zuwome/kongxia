//
//  ZZLiveStreamAcceptView.h
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 女方接受或者拒绝视频
 */
@interface ZZLiveStreamAcceptView : UIView

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t touchAccept;
@property (nonatomic, copy) dispatch_block_t touchRefuse;

@property (nonatomic, copy) dispatch_block_t timeOut;

- (void)remove;

@end
