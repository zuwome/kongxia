//
//  ZZWalletHeadView.h
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  钱包  ---- headview
 */
@interface ZZWalletHeadView : UIView

@property (nonatomic, strong) UILabel *balanceLabel;//余额
@property (nonatomic, strong) UILabel *lockMoneyLabel;//锁定金额
@property (nonatomic, strong) UIButton *tixianBtn;
@property (nonatomic, strong) UIButton *rechargeBtn;

@property (nonatomic, copy) dispatch_block_t touchTixian;
@property (nonatomic, copy) dispatch_block_t touchRecharge;

@end
