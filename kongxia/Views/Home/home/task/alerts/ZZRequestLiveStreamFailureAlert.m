//
//  ZZRequestLiveStreamFailureAlert.m
//  zuwome
//
//  Created by angBiu on 2017/7/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRequestLiveStreamFailureAlert.h"

@interface ZZRequestLiveStreamFailureAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *rechargeBtn;

@end

@implementation ZZRequestLiveStreamFailureAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.39);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)rechargeBtnClick
{
    [self cancelBtnClick];
    if (_touchRecharge) {
        _touchRecharge();
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 4;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(310*scale);
        }];
        
        NSInteger totalMoney = [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_mcoin.integerValue;
        self.titleLabel.text = @"么币余额不足";
        self.centerImgView.image = [UIImage imageNamed:@"icon_livestream_lowmoney"];
        self.contentLabel.text = [NSString stringWithFormat:@"您当前余额不足%ld么币，请充值后再发布任务",totalMoney];;
        self.cancelBtn.hidden = NO;
        self.rechargeBtn.hidden = NO;
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(18);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)centerImgView
{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_centerImgView];
        
        [_centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(14);
            make.size.mas_equalTo(CGSizeMake(67.5, 84.5));
        }];
    }
    return _centerImgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = HEXCOLOR(0x9B9B9B);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.top.mas_equalTo(_centerImgView.mas_bottom).offset(8);
        }];
    }
    return _contentLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        _cancelBtn.layer.cornerRadius = 3;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-6);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(18);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-14);
        }];
    }
    return _cancelBtn;
}

- (UIButton *)rechargeBtn
{
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc] init];
        [_rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _rechargeBtn.backgroundColor = kYellowColor;
        _rechargeBtn.layer.cornerRadius = 3;
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_rechargeBtn];
        
        [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.left.mas_equalTo(_bgView.mas_centerX).offset(6);
            make.top.bottom.mas_equalTo(_cancelBtn);
        }];
    }
    return _rechargeBtn;
}

@end
