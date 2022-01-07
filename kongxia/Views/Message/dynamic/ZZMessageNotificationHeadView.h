//
//  ZZMessageDynamicHeadView.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZLineView.h"
/**
 *  消息动态headview
 */
@interface ZZMessageNotificationHeadView : UIView

@property (nonatomic, strong) ZZLineView *lineView;
@property (nonatomic, strong) UIView *leftRedPointView;
@property (nonatomic, strong) UIView *rightRedPointView;
@property (nonatomic, copy) void(^selectIndex)(NSInteger index);
@property (nonatomic, copy) dispatch_block_t touchLeft;

- (void)setLineViewOffset:(CGFloat)offset;
- (void)setLineIndex:(NSInteger)index;

@end
