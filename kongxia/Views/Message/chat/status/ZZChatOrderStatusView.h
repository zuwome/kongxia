//
//  ZZChatOrderStatusView.h
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZChatStatusCountDownView.h"
#import "ZZChatStatusBtnView.h"

#import "ZZOrder.h"

/**
 *  聊天顶部订单状态view
 */
@interface ZZChatOrderStatusView : UIView

@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ZZChatStatusCountDownView *countDownView;
@property (nonatomic, strong) ZZChatStatusBtnView *btnView;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, assign) OrderDetailType detailType;

@property (nonatomic, copy) dispatch_block_t touchStatusView;
@property (nonatomic, copy) dispatch_block_t touchMoreBtn;
@property (nonatomic, copy) dispatch_block_t touchStatusBtn;

- (void)setData:(ZZOrder *)order;

@end
