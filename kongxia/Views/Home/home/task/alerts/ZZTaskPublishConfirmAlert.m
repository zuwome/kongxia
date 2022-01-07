//
//  ZZTaskPublishConfirmAlert.m
//  zuwome
//
//  Created by angBiu on 2017/8/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskPublishConfirmAlert.h"

@interface ZZTaskPublishConfirmAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) UIImageView *ignoreImgView;
@property (nonatomic, assign) BOOL selected;

@end

@implementation ZZTaskPublishConfirmAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.39);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
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
        [ZZKeyValueStore saveValue:@"firstTaskPublishAlert" key:[ZZStoreKey sharedInstance].firstTaskPublishAlert];
    }
}

- (void)ignoreBtnClick
{
    if (_selected) {
        _ignoreImgView.image = [UIImage imageNamed:@"btn_report_n"];
    } else {
        _ignoreImgView.image = [UIImage imageNamed:@"btn_report_p"];
    }
    _selected = !_selected;
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
            make.width.mas_equalTo(317*scale);
        }];
        
        self.topImgView.image = [UIImage imageNamed:@"icon_task_alert_top"];
        self.titleLabel.text = @"发布通知";
        self.contentLabel.attributedText = [ZZUtils setLineSpace:@"为了提高您发布的任务成功率，空虾闪租采用先付款后发单的模式（先付至少一位达人的任务金额），若您的任务没能成功，任务金额将全部原路退还。" space:5 fontSize:14 color:HEXCOLOR(0x9B9B9B)];
        self.ignoreBtn.hidden = NO;
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

- (UIImageView *)topImgView
{
    if (!_topImgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        _topImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_topImgView];
        
        [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_bgView);
            make.height.mas_equalTo(scale*62);
        }];
    }
    return _topImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_topImgView);
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x9B9B9B);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(18);
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.top.mas_equalTo(_topImgView.mas_bottom).offset(20);
        }];
    }
    return _contentLabel;
}

- (UIButton *)ignoreBtn
{
    if (!_ignoreBtn) {
        _ignoreBtn = [[UIButton alloc] init];
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_ignoreBtn];
        
        [_ignoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(12);
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

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        _cancelBtn.layer.cornerRadius = 3;
        [_cancelBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(18);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-5);
            make.top.mas_equalTo(_ignoreBtn.mas_bottom).offset(10);
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
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
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

@end
