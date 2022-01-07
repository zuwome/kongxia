//
//  ZZOfflineConfirmAlert.m
//  zuwome
//
//  Created by YuTianLong on 2017/11/10.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZOfflineConfirmAlert.h"

@interface ZZOfflineConfirmAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) UIImageView *ignoreImgView;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ZZOfflineConfirmAlert

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.39);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark - Getter & Setter

- (UIView *)bgView {
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 4;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(317*scale);
        }];
        
        self.titleLabel.text = @"线下邀约";
        self.centerImgView.image = [UIImage imageNamed:@"bgPopupDate"];
        self.ignoreBtn.hidden = NO;
        
        NSString *string = @"请确保该场所为公众场合\n是否能够准时到达指定地点";
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [hintString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        self.contentLabel.attributedText = hintString;
        
        self.cancelBtn.hidden = NO;
        self.sureBtn.hidden = NO;
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:closeBtn];
        
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
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(112, 88));
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
            make.top.mas_equalTo(_centerImgView.mas_bottom).offset(5);
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
        _contentLabel.textColor = HEXCOLOR(0x9B9B9B);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(18);
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.top.mas_equalTo(_ignoreBtn.mas_bottom).offset(10);
        }];
    }
    return _contentLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"我再想想" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        _cancelBtn.layer.cornerRadius = 3;
        [_cancelBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(18);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-5);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-14);
        }];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确认抢单" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.backgroundColor = kYellowColor;
        _sureBtn.layer.cornerRadius = 3;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.left.mas_equalTo(_bgView.mas_centerX).offset(5);
            make.top.bottom.mas_equalTo(_cancelBtn);
        }];
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
        [ZZKeyValueStore saveValue:@"firstOffLine" key:[ZZStoreKey sharedInstance].firstOffLine];
    }
}

@end
