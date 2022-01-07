//
//  ZZChatPacketAlertView.m
//  zuwome
//
//  Created by angBiu on 16/9/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatPacketAlertView.h"

@interface ZZChatPacketAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIImageView *downImgView;
@property (nonatomic, strong) UIView *priceBgView;
@property (nonatomic, strong) UILabel *packetPriceLabel;
@property (nonatomic, strong) UILabel *servicePriceLabel;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation ZZChatPacketAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *bgBtn = [[UIButton alloc] init];
        bgBtn.backgroundColor = kBlackTextColor;
        bgBtn.alpha = 0.8;
        [self addSubview:bgBtn];
        
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self createViews];
    }
    
    return self;
}

- (void)createViews
{
    self.bgView.layer.cornerRadius = 3;
    self.topImgView.image = [UIImage imageNamed:@"icon_packet_info_top"];
    self.headImgView.hidden = NO;
    self.nameLabel.text = @"收到潇洒电线杆的红包";
    self.moneyLabel.text = @"¥6.00";
    [self.downBtn addTarget:self action:@selector(showPriceInfoView) forControlEvents:UIControlEventTouchUpInside];
    self.priceBgView.hidden = YES;
    [self.shareBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (![ZZUserHelper shareInstance].configModel.yj) {
        self.downBtn.userInteractionEnabled = NO;
    }
}

- (void)setData:(ZZUser *)user
{
    [_headImgView setUser:user width:64 vWidth:12];
    _nameLabel.text = [NSString stringWithFormat:@"%@打赏了",user.nickname];
}

- (void)setPrice:(double)price
{
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",price];
    _packetPriceLabel.text = [NSString stringWithFormat:@"%.2f",price - _yj_price];
    _servicePriceLabel.text = [NSString stringWithFormat:@"%.2f",_yj_price];
}

#pragma mark - UIButtonMethod

- (void)showPriceInfoView
{
    [self endEditing:YES];
    if (self.priceBgView.hidden) {
        _downImgView.transform = CGAffineTransformMakeRotation(M_PI);
        self.priceBgView.hidden = NO;
        CGFloat height = [self.priceBgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [_shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_downBtn.mas_bottom).offset(height+30 );
        }];
    } else {
        _downImgView.transform = CGAffineTransformMakeRotation(2* M_PI);
        self.priceBgView.hidden = YES;
        [_shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_downBtn.mas_bottom).offset(20);
        }];
    }
}

- (void)typeBtnClick:(UIButton *)btn
{
    if (_tempBtn == btn) {
        return;
    }
    
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
    if (_cancelCallBack) {
        _cancelCallBack();
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(20);
            make.right.mas_equalTo(self.mas_right).offset(-20);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _bgView;
}

- (UIImageView *)topImgView
{
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_topImgView];
        
        [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_bgView);
            make.height.mas_equalTo(@80);
        }];
    }
    return _topImgView;
}

- (ZZHeadImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [_bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.centerY.mas_equalTo(_topImgView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(8);
        }];
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = kBlackTextColor;
        _moneyLabel.font = [UIFont systemFontOfSize:28];
        [_bgView addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
        }];
    }
    return _moneyLabel;
}

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] init];
        [_bgView addSubview:_downBtn];
        
        [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_moneyLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(80, 15));
        }];
        
        _downImgView = [[UIImageView alloc] init];
        _downImgView.image = [UIImage imageNamed:@"icon_amountdetail_down"];
        _downImgView.userInteractionEnabled = NO;
        [_downBtn addSubview:_downImgView];
        
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_downBtn.mas_top);
            make.centerX.mas_equalTo(_downBtn.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(15.5, 8));
        }];
    }
    return _downBtn;
}

- (UIView *)priceBgView
{
    if (!_priceBgView) {
        _priceBgView = [[UIView alloc] init];
        [_bgView addSubview:_priceBgView];
        
        [_priceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bgView);
            make.top.mas_equalTo(_downBtn.mas_bottom);
        }];
        
        UILabel *packetTitleLabel = [[UILabel alloc] init];
        packetTitleLabel.textColor = kGrayTextColor;
        packetTitleLabel.font = [UIFont systemFontOfSize:12];
        packetTitleLabel.text = @"打赏金额";
        [_priceBgView addSubview:packetTitleLabel];
        
        [packetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_priceBgView.mas_left).offset((SCREEN_WIDTH - 60)/4.0);
            make.top.mas_equalTo(_priceBgView.mas_top);
        }];
        
        _packetPriceLabel = [[UILabel alloc] init];
        _packetPriceLabel.textAlignment = NSTextAlignmentCenter;
        _packetPriceLabel.textColor = kGrayTextColor;
        _packetPriceLabel.font = [UIFont systemFontOfSize:12];
        _packetPriceLabel.text = @"￥10";
        [_priceBgView addSubview:_packetPriceLabel];
        
        [_packetPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_priceBgView.mas_right).offset(-(SCREEN_WIDTH - 60)/4.0);
            make.centerY.mas_equalTo(packetTitleLabel.mas_centerY);
        }];
        
        UILabel *serviceTitleLabel = [[UILabel alloc] init];
        serviceTitleLabel.textColor = kGrayTextColor;
        serviceTitleLabel.font = [UIFont systemFontOfSize:12];
        serviceTitleLabel.text = @"平台服务费";
        [_priceBgView addSubview:serviceTitleLabel];
        
        [serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(packetTitleLabel.mas_left);
            make.top.mas_equalTo(packetTitleLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_priceBgView.mas_bottom);
        }];
        
        _servicePriceLabel = [[UILabel alloc] init];
        _servicePriceLabel.textAlignment = NSTextAlignmentCenter;
        _servicePriceLabel.textColor = kGrayTextColor;
        _servicePriceLabel.font = [UIFont systemFontOfSize:12];
        _servicePriceLabel.text = @"￥10";
        [_priceBgView addSubview:_servicePriceLabel];
        
        [_servicePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_packetPriceLabel.mas_left);
            make.centerY.mas_equalTo(serviceTitleLabel.mas_centerY);
        }];
    }
    return _priceBgView;
}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        [_shareBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_packet_info_btnbg"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _shareBtn.layer.cornerRadius = 3;
        [_bgView addSubview:_shareBtn];
        
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_downBtn.mas_bottom).offset(20);
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-15);
        }];
    }
    return _shareBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = NO;
        imgView.image = [UIImage imageNamed:@"icon_read_cancel"];
        [_cancelBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_cancelBtn.mas_right).offset(-8);
            make.top.mas_equalTo(_cancelBtn.mas_top).offset(8);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
    return _cancelBtn;
}

@end
