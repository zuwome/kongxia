//
//  ZZFillBankView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 填写银行卡确认提现按钮
 */
@interface ZZFillBankView : UIView
@property (nonatomic,strong) UIButton *tiXianButton;
/**
 当前提现按钮是否可以点击
 
 @param isEnable 是否可以点击
 */
- (void)changeTiXianButtonStateIsEnable:(BOOL) isEnable;
/**
 去提现
 */
@property(nonatomic,copy) void (^goToTixian)(UIButton *sender) ;
@end
