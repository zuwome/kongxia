//
//  ZZChatStatusCountDownView.h
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrder.h"
/**
 *  聊天顶部倒计时view
 */
@interface ZZChatStatusCountDownView : UIView

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) dispatch_block_t touchPay;
@property (nonatomic, copy) dispatch_block_t timeOut;

- (void)setData:(ZZOrder *)order type:(OrderDetailType)type;

@end
