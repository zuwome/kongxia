//
//  ZZSelfOrderButton.h
//  zuwome
//
//  Created by angBiu on 16/5/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBadgeView.h"
/**
 *  我 -- 订单类别入口按钮
 */
@interface ZZSelfOrderButton : UIButton

@property (nonatomic, strong) UIImageView *imgView;//图标
@property (nonatomic, strong) UILabel *typeLabel;//类别
@property (nonatomic, strong) UILabel *badgeLabel;//红点角标
@property (nonatomic, strong) ZZBadgeView *badgeView;
@property (nonatomic, copy) dispatch_block_t touchBlock;//点击回调

@end
