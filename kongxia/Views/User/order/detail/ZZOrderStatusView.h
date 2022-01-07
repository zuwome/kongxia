//
//  ZZOrderStatusView.h
//  zuwome
//
//  Created by angBiu on 16/7/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrder.h"
/**
 *  订单详情页 头部状态
 */
@interface ZZOrderStatusView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) dispatch_block_t touchDetail;

- (void)setOrder:(ZZOrder *)order type:(OrderDetailType)type;

@end
