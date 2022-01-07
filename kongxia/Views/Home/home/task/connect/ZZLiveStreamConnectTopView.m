//
//  ZZLiveStreamConnectTopView.m
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamConnectTopView.h"

@interface ZZLiveStreamConnectTopView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UIImageView *localImgView;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) UIButton *reportBtn;
@property (nonatomic, strong) UIImageView *userHeaderImageView; // 用户头像
@property (nonatomic, strong) UIImageView *maskImageView;//头像背景遮罩imageView

@end

@implementation ZZLiveStreamConnectTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        
        self.maskImageView.hidden = NO;
        self.userHeaderImageView.hidden = NO;
        self.vImgView.hidden = YES;
        self.nameLabel.text = @"1111";
        [self.levelImgView setLevel:1];
        self.localLabel.text = @"111";
        self.attentBtn.hidden = NO;
        self.reportBtn.hidden = NO;
    }
    return self;
}

- (void)setUser:(ZZUser *)user
{
    _user = user;
    [_userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:defaultBackgroundImage_SelectTalent options:SDWebImageRetryFailed];
    self.nameLabel.text = user.nickname;
    [self.levelImgView setLevel:user.level];
    self.localLabel.text = user.distance;
    if (user.weibo.verified) {
        _vImgView.hidden = NO;

    } else {

        _vImgView.hidden = YES;
        [self.reportBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_localImgView.mas_bottom).offset(10);
        }];
    }
}

- (void)setIsConnectHeader:(BOOL)isConnectHeader {
    _isConnectHeader = isConnectHeader;
    
    _localImgView.hidden = YES;
    self.attentBtn.hidden = YES;
    self.reportBtn.hidden = YES;
    [_localImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];

    [_localLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
//        make.centerY.mas_equalTo(_localImgView.mas_centerY);
        make.bottom.equalTo(_userHeaderImageView.mas_bottom);
    }];
}

- (void)setAccept:(BOOL)accept {
    _accept = accept;
    if (accept) {
        self.localLabel.text = @"正在邀请您视频通话...";
    } else {

        self.localLabel.text = @"正在邀请对方视频通话...";
    }
}


- (void)setFollow_status:(NSInteger)follow_status
{
    _follow_status = follow_status;
    switch (follow_status) {
        case 0:
        {
            _attentBtn.hidden = NO;
            [_attentBtn setTitle:@"+关注" forState:UIControlStateNormal];
            [_attentBtn setTitleColor:RGBCOLOR(71, 64, 56) forState:UIControlStateNormal];
            _attentBtn.backgroundColor = kYellowColor;
            _attentBtn.layer.borderWidth = 0;
            [_attentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(@62);
            }];
        }
            break;
        case 1:
        {
            _attentBtn.hidden = NO;
            [_attentBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _attentBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            _attentBtn.layer.borderWidth = 1.5;
            [_attentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(@68);
            }];
        }
            break;
        case 2:
        {
            _attentBtn.hidden = NO;
            [_attentBtn setTitle:@"互相关注" forState:UIControlStateNormal];
            [_attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _attentBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            _attentBtn.layer.borderWidth = 1.5;
            [_attentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(@76);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)attentBtnClick
{
    if (_touchAttent) {
        _touchAttent();
    }
}

- (void)reportBtnClick
{
    if (_touchReport) {
        [MobClick event:Event_click_Video_Report];
        _touchReport();
    }
}

// 查看用户详情
- (void)userDetailClick {
    BLOCK_SAFE_CALLS(self.userDetailBlock, self.user);
}

#pragma mark -

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLabel];
        
        [_nameLabel setContentHuggingPriority:(UILayoutPriorityDefaultHigh + 1) forAxis:(UILayoutConstraintAxisHorizontal)];
        [_nameLabel setContentCompressionResistancePriority:(UILayoutPriorityDefaultHigh + 1) forAxis:(UILayoutConstraintAxisHorizontal)];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_userHeaderImageView.mas_trailing).offset(15);
            make.top.equalTo(_userHeaderImageView.mas_top);
            make.height.equalTo(@20);
        }];
    }
    return _nameLabel;
}

- (ZZLevelImgView *)levelImgView
{
    if (!_levelImgView) {
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(_nameLabel.mas_trailing).offset(5);
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.width.equalTo(@28);
            make.height.equalTo(@14);
        }];
    }
    return _levelImgView;
}

- (UILabel *)localLabel
{
    if (!_localLabel) {
        _localImgView = [[UIImageView alloc] init];
        _localImgView.image = [UIImage imageNamed:@"icon_rent_location"];
        [self addSubview:_localImgView];
        
        [_localImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(6);
            make.size.mas_equalTo(CGSizeMake(9, 12));
        }];
        
        
        _localLabel = [[UILabel alloc] init];
        _localLabel.textColor = HEXACOLOR(0xffffff, 0.8);
        _localLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_localLabel];
        
        [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left).offset(9+5);
//            make.right.mas_equalTo(_levelImgView.mas_right);
            make.centerY.mas_equalTo(_localImgView.mas_centerY);
        }];
    }
    return _localLabel;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        UIImage *image = stretchImgFromMiddle([UIImage imageNamed:@"bgVedioProtect"]);
        _maskImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_maskImageView];
        [_maskImageView sizeToFit];
        [_maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(7);
            make.width.mas_equalTo(230);
            make.height.mas_equalTo(50);
        }];
    }
    return _maskImageView;
}

- (UIImageView *)userHeaderImageView {
    if (!_userHeaderImageView) {
        _userHeaderImageView = [UIImageView new];
        _userHeaderImageView.layer.masksToBounds = YES;
        _userHeaderImageView.layer.cornerRadius = 20.0f;
        _userHeaderImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDetailClick)];
        [_userHeaderImageView addGestureRecognizer:tapGestureRecognizer];

        [self addSubview:_userHeaderImageView];
        [_userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(20);
            make.top.mas_equalTo(self.mas_top).offset(12);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _userHeaderImageView;
}

- (UIImageView *)vImgView
{
    if (!_vImgView) {
        _vImgView = [[UIImageView alloc] init];
        _vImgView.image = [UIImage imageNamed:@"v"];
        [self addSubview:_vImgView];
        
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_userHeaderImageView.mas_bottom).offset(-2);
            make.leading.equalTo(_userHeaderImageView.mas_centerX).offset(10);
            make.height.width.equalTo(@12);
        }];
    }
    return _vImgView;
}

- (UIButton *)reportBtn
{
    if (!_reportBtn) {
        _reportBtn = [[UIButton alloc] init];

        [_reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_reportBtn setBackgroundImage:[UIImage imageNamed:@"icVideoReport"] forState:UIControlStateNormal];
        [self addSubview:_reportBtn];
        
        [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_attentBtn.mas_top);
            make.left.mas_equalTo(_attentBtn.mas_right).offset(12);
            make.centerY.mas_equalTo(_attentBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(62, 28));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return _reportBtn;
}

- (UIButton *)attentBtn
{
    if (!_attentBtn) {
        _attentBtn = [[UIButton alloc] init];
        [_attentBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_attentBtn addTarget:self action:@selector(attentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _attentBtn.layer.cornerRadius = 14;
        _attentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _attentBtn.layer.borderWidth = 1;
        [self addSubview:_attentBtn];
        
        [_attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(62);
            make.size.mas_equalTo(CGSizeMake(62, 28));
        }];
    }
    return _attentBtn;
}

@end
