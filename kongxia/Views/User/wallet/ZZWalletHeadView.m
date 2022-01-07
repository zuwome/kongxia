//
//  ZZWalletHeadView.m
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZWalletHeadView.h"

@implementation ZZWalletHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kYellowColor;
        
        UILabel *balanceTitleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:14 text:@"账户余额（元）："];
        [self addSubview:balanceTitleLabel];
        
        [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(15);
        }];
        
        _balanceLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:24 text:@"666.00"];
        [self addSubview:_balanceLabel];
        
        [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(balanceTitleLabel.mas_left);
            make.top.mas_equalTo(balanceTitleLabel.mas_bottom).offset(10);
        }];
        
        UILabel *lockTitleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:11 text:@"锁定余额为支付／提现时待审核的金额"];
        lockTitleLabel.alpha = 0.4;
        [self addSubview:lockTitleLabel];
        
        [lockTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(balanceTitleLabel.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
        }];
        
        _lockMoneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:14 text:@"锁定余额（元）：0.00"];
        [self addSubview:_lockMoneyLabel];
        
        [_lockMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lockTitleLabel.mas_left);
            make.bottom.mas_equalTo(lockTitleLabel.mas_top).offset(-4);
        }];
        
        _tixianBtn = [[UIButton alloc] init];
        [_tixianBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_tixianBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        _tixianBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_tixianBtn addTarget:self action:@selector(tixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _tixianBtn.layer.cornerRadius = 2;
        _tixianBtn.hidden = YES;
        _tixianBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tixianBtn];
        
        [_tixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(54, 28));
        }];
        
        _rechargeBtn = [[UIButton alloc] init];
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rechargeBtn.layer.cornerRadius = 2;
        _rechargeBtn.hidden = YES;
        _rechargeBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_rechargeBtn];
        
        [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(54, 28));
        }];
    }
    
    return self;
}

- (void)tixianBtnClick
{
    if (_touchTixian) {
        _touchTixian();
    }
}

- (void)rechargeBtnClick
{
    if (_touchRecharge) {
        _touchRecharge();
    }
}

@end
