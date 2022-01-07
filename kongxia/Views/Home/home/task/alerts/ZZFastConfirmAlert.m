//
//  ZZFastConfirmAlert.m
//  zuwome
//
//  Created by YuTianLong on 2018/1/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFastConfirmAlert.h"

@interface ZZFastConfirmAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) UIImageView *ignoreImgView;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UILabel *showDetailLab;
@end

@implementation ZZFastConfirmAlert

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.39);
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self configData];
    }
    
    return self;
}

- (void)configData {
    ZZPriceConfigModel *priceConfig = [ZZUserHelper shareInstance].configModel.priceConfig;
    _contentLabel.text = priceConfig.text[@"cost_card"];
    _showDetailLab.text = priceConfig.text[@"exchange"];
}

#pragma mark - Getter & Setter
- (UIView *)bgView {
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 4;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.equalTo(self).offset(-(NAVIGATIONBAR_HEIGHT* 0.5));
            make.width.mas_equalTo(317*scale);
            make.height.equalTo(_bgView.mas_width).multipliedBy(289/317.0f);
        }];
        
        self.centerImgView.image = [UIImage imageNamed:@"icon_fastCenterPopImage"];
        self.titleLabel.text = @"1V1视频咨询";
        self.titleLabel.hidden = YES;
        self.contentLabel.text = @"每2分钟需赠送4张咨询卡";
        self.ignoreBtn.hidden = NO;

        self.sureBtn.hidden = NO;
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:closeBtn];
        [_bgView addSubview:self.showDetailLab];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = NO;
        imgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
        [closeBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(closeBtn.mas_top).offset(15);
            make.right.mas_equalTo(closeBtn.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
    
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-24);
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.bottom.equalTo(self.showDetailLab.mas_top).offset(-10);
            make.height.equalTo(_bgView.mas_height).multipliedBy(49/289.0f);
        }];
        [self.showDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.right.offset(-5);
            make.bottom.equalTo(@(-8));
            make.height.equalTo(@16);
        }];
    }
    
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x9B9B9B);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_centerImgView.mas_bottom).offset(0.5);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)centerImgView
{
    if (!_centerImgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;

        CGFloat imageScale = 317.0 / 101;
        _centerImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_centerImgView];
        
        [_centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.equalTo(@0);
            make.width.mas_equalTo(317*scale);
            make.height.mas_equalTo(317*scale / imageScale);
        }];
    }
    return _centerImgView;
}

- (UIButton *)ignoreBtn
{
    if (!_ignoreBtn) {
        _ignoreBtn = [[UIButton alloc] init];
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_ignoreBtn];
        
        [_ignoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(@29);
        }];
        
        _ignoreImgView = [[UIImageView alloc] init];
        _ignoreImgView.userInteractionEnabled = NO;
        _ignoreImgView.image = [UIImage imageNamed:@"btn_report_n"];
        [_ignoreBtn addSubview:_ignoreImgView];
        
        [_ignoreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(_ignoreBtn);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"不再提醒";
        titleLabel.userInteractionEnabled = NO;
        [_ignoreBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_ignoreImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_ignoreBtn.mas_centerY);
            make.right.mas_equalTo(_ignoreBtn.mas_right);
        }];
    }
    return _ignoreBtn;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = kBlackColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(18);
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.centerY.equalTo(_bgView.mas_centerY).with.offset(-15);
        }];
    }
    return _contentLabel;
}
- (UILabel *)showDetailLab {
    if (!_showDetailLab) {
        _showDetailLab = [[UILabel alloc]init];
        _showDetailLab.textAlignment = NSTextAlignmentCenter;
        _showDetailLab.textColor = RGBCOLOR(122, 122, 122);
        _showDetailLab.font = CustomFont(12);
        _showDetailLab.text = @"1张咨询卡需支付10么币";
    }
    return _showDetailLab;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"立即视频" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.backgroundColor = kYellowColor;
        _sureBtn.layer.cornerRadius =  AdaptedWidth(317)*24.5/317.0f;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
        
    
    }
    return _sureBtn;
}

#pragma mark - Private

- (void)ignoreBtnClick
{
    if (_selected) {
        _ignoreImgView.image = [UIImage imageNamed:@"btn_report_n"];
    } else {
        _ignoreImgView.image = [UIImage imageNamed:@"btn_report_p"];
    }
    _selected = !_selected;
}

- (void)closeBtnClick
{
    [self removeFromSuperview];
    if (_touchCancel) {
        _touchCancel();
    }
}

- (void)sureBtnClick
{
    [self removeFromSuperview];
    if (_touchSure) {
        _touchSure();
    }
    if (_selected) {
        [ZZKeyValueStore saveValue:@"firstFastVideo" key:[ZZStoreKey sharedInstance].firstFastVideo];
    }
}

@end
