//
//  ZZMemedaTypeView.h
//  zuwome
//
//  Created by angBiu on 16/8/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBadgeView.h"
/**
 *  我的么么答头部 --- 类别view
 */
@interface ZZMemedaTypeView : UIView

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *redPointView;
@property (nonatomic, strong) ZZBadgeView *badgeView;
@property (nonatomic, copy) void(^touchType)(NSInteger index);

- (void)setLineViewOffset:(CGFloat)offset;
- (void)setIndex:(NSInteger)index;

@end
