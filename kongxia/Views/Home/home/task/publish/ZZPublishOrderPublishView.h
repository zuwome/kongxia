//
//  ZZPublishOrderPublishView.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPublishOrderPublishView : UIView

@property (nonatomic, assign) BOOL isAnonymous;//匿名
@property (nonatomic, copy) dispatch_block_t touchPublish;
@property (nonatomic, copy) dispatch_block_t touchAnonymous;

- (void)endAnimation;

@end
