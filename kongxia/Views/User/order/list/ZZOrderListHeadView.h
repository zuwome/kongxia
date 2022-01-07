//
//  ZZOrderListHeadView.h
//  zuwome
//
//  Created by angBiu on 16/8/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBadgeView.h"
/**
 *  订单列表 头部
 */
@interface ZZOrderListHeadView : UIView

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZZBadgeView *ingBadgeView;
@property (nonatomic, strong) UIView *commentRedPointView;
@property (nonatomic, strong) UIView *doneRedPointView;
@property (nonatomic, copy) void(^selectedIndex)(NSInteger index);

- (void)setSelectIndex:(NSInteger)index;

@end
