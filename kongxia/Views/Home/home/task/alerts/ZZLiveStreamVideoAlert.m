//
//  ZZLiveStreamVideoAlert.m
//  zuwome
//
//  Created by angBiu on 2017/7/19.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamVideoAlert.h"

@implementation ZZLiveStreamVideoAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.64);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)leftBtnClick
{
    [self removeFromSuperview];
    if (_touchLeft) {
        _touchLeft();
    }
}

- (void)rightBtnClick
{
    [self removeFromSuperview];
    if (_touchRight) {
        _touchRight();
    }
}

- (IBAction)closeBtnClick:(id)sender {
    [self removeFromSuperview];
}

- (void)setType:(NSInteger)type {
    _type = type;
    _titleLabel.text = @"结束视频";
    NSInteger beginPrice = 5;
    NSInteger extraPrice = 2;
    
    ZZPriceConfigModel *priceConfig = [ZZUserHelper shareInstance].configModel.priceConfig;
    
    NSInteger billingInterval = priceConfig.settlement_unit.integerValue;

    if ([ZZUserHelper shareInstance].configModel.skill) {
        beginPrice = [ZZUserHelper shareInstance].configModel.skill.begin_price;
        extraPrice = [ZZUserHelper shareInstance].configModel.skill.extra_price;
    }
    switch (_type) {
        case 1: {
            _leftBtn.backgroundColor = kYellowColor;
            _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            _titleLabel.text = @"拒绝视频";
            [_leftBtn setTitle:@"接通" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"拒接" forState:UIControlStateNormal];
            _contentLabel.text = [NSString stringWithFormat:@"接通视频满%ld分钟即可获得%ld元收益，后每增加1分钟增加%ld元，确定放弃收益吗？", billingInterval, beginPrice, extraPrice];
            break;
        }
        case 2: {
            _leftBtn.backgroundColor = kYellowColor;
            _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            [_leftBtn setTitle:@"继续视频" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确认放弃" forState:UIControlStateNormal];
            _contentLabel.text = [NSString stringWithFormat:@"确定取消视频吗？不满%ld分钟将无法获得%ld元收益哦", billingInterval, beginPrice];
            break;
        }
        case 3: {
            _leftBtn.backgroundColor = kYellowColor;
            _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            [_leftBtn setTitle:@"继续视频" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确认挂断" forState:UIControlStateNormal];
            NSInteger minute = _during/60;
            NSInteger second = _during%60;
            _contentLabel.text = [NSString stringWithFormat:@"确定结束视频吗？目前通话时长%ld分%ld秒可获得收益%@元",minute,second,[ZZUtils dealAccuracyDouble:_money]];
             break;
        }
        case 6: {
            _leftBtn.backgroundColor = kYellowColor;
            _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
            _contentLabel.text = priceConfig.text[@"end_of_admin"];
            break;
        }
        case 7: {
            _rightBtn.backgroundColor = kYellowColor;
            _leftBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            [_leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"结束视频" forState:UIControlStateNormal];
            _contentLabel.text = priceConfig.text[@"user_longtime_no_face_tip"];
            break;
        }
        case 8: {
            _leftBtn.backgroundColor = kYellowColor;
            _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            _titleLabel.text = @"拒绝视频";
            [_leftBtn setTitle:@"接通" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"拒接" forState:UIControlStateNormal];
            _contentLabel.text = [NSString stringWithFormat:@"接通视频后，每2分钟可获得收益，确定放弃收益吗?"];
            break;
        }
        case 9: {
            _leftBtn.backgroundColor = kYellowColor;
            _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            [_leftBtn setTitle:@"继续视频" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确认挂断" forState:UIControlStateNormal];
            _contentLabel.text = priceConfig.text[@"end_of_user"];
            break;
        }
        default:
            break;
    }
}

- (void)setDuring:(NSInteger)during
{
    _during = during;
    switch (_type) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if (during >= 120) {
                self.type = 3;
            }
        }
            break;
        case 3:
        {
            NSInteger minute = _during/60;
            NSInteger second = _during%60;
            _contentLabel.text = [NSString stringWithFormat:@"确定结束视频吗？目前通话时长%ld分%ld秒可获得收益%@元",minute,second,[ZZUtils dealAccuracyDouble:_money]];
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
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
        
        self.titleLabel.text = @"结束视频";
        self.closeBtn.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"icon_livestream_finish"];
        self.contentLabel.text = @"您当前么币不足，请充值后再发布任务";
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
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

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icEvaluateClose"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bgView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.mas_centerY);
            make.trailing.equalTo(@(-15));
            make.width.height.equalTo(@18);
        }];
    }
    return _closeBtn;
}

- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
//            make.size.mas_equalTo(CGSizeMake(106.5, 69.5));
        }];
    }
    return _imgView;
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
            make.top.mas_equalTo(_imgView.mas_bottom).offset(10);
        }];
    }
    return _contentLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftBtn.backgroundColor = kYellowColor;
        _leftBtn.layer.cornerRadius = 3;
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_leftBtn];
        
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-6);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
      
        _rightBtn.layer.cornerRadius = 3;
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_rightBtn];
        
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.left.mas_equalTo(_bgView.mas_centerX).offset(6);
            make.top.bottom.mas_equalTo(_leftBtn);
        }];
    }
    return _rightBtn;
}

@end
