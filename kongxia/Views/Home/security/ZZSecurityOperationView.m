//
//  ZZSecurityOperationView.m
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityOperationView.h"

@interface ZZSecurityOperationView ()

@end

@implementation ZZSecurityOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel.text = @"空虾已经成功接到您的求助";
        self.recordImgView.image = [UIImage imageNamed:@"btn_report_p"];
        self.recordLabel.text = @"正在录音 00:00";
        self.recordDetailLabel.text = @"实时监听中";
        self.waveView.hidden = YES;
        if ([ZZUserHelper shareInstance].location) {
            self.locationImgView.image = [UIImage imageNamed:@"btn_report_p"];
            self.locationLabel.text = @"已上传实时位置";
        } else {
            self.locationImgView.image = [UIImage imageNamed:@"btn_report_n"];
            self.locationLabel.text = @"无法上传实时位置";
        }
        self.contactImgView.image = [UIImage imageNamed:@"btn_report_n"];
        [self managerContactStatus];
        self.cancelBtn.hidden = NO;
        
        WeakSelf;
        self.waveView.waverLevelCallback = ^(ZZSecurityAudioWaveView *waver) {
            waver.level = weakSelf.audioLevel;
        };
    }
    
    return self;
}

- (void)managerContactStatus
{
    if ([ZZUserHelper shareInstance].loginer.emergency_contacts.count) {
        self.contactLabel.text = @"正在发送短信中";
        self.contactDetailLabel.text = @" ";
        self.contactDetailLabel.textColor = HEXCOLOR(0xbbbbbb);
        self.contactDetailLabel.userInteractionEnabled = NO;
    } else {
        self.contactLabel.text = @"未填写紧急联系人，无法发送短信";
        self.contactDetailLabel.text = @"前往设置";
        self.contactDetailLabel.textColor = HEXCOLOR(0x4990e2);
        self.contactDetailLabel.userInteractionEnabled = YES;
    }
}

- (void)setAudioLevel:(CGFloat)audioLevel
{
    _audioLevel = audioLevel;
    self.waveView.hidden = NO;
}

- (void)setNotified:(BOOL)notified
{
    _notified = notified;
    if (notified) {
        self.contactLabel.text = @"已成功发送短信给所有紧急联系人";
        self.contactImgView.image = [UIImage imageNamed:@"btn_report_p"];
        if ([ZZUserHelper shareInstance].loginer.emergency_contacts.count) {
            __block NSString *names = @"";
            [[ZZUserHelper shareInstance].loginer.emergency_contacts enumerateObjectsUsingBlock:^(ZZEmergencyContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                names = [NSString stringWithFormat:@"%@%@ ",names,obj.name];
            }];
            names = [NSString stringWithFormat:@"%@将收到您的求助信息",names];
            self.contactDetailLabel.text = names;
        }
    }
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    if (_touchCancel) {
        _touchCancel();
    }
}

- (void)contactSettingClick
{
    if (_touchContactSetting) {
        _touchContactSetting();
    }
}

#pragma mark - lazyload

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(25);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)recordImgView
{
    if (!_recordImgView) {
        _recordBgView = [[UIView alloc] init];
        [self addSubview:_recordBgView];
        
        [_recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        }];
        
        _recordImgView = [[UIImageView alloc] init];
        [_recordBgView addSubview:_recordImgView];
        
        [_recordImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_recordBgView.mas_left).offset(35);
            make.top.mas_equalTo(_recordBgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _recordImgView;
}

- (UILabel *)recordLabel
{
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc] init];
        _recordLabel.textColor = HEXCOLOR(0x7a7a7a);
        _recordLabel.font = [UIFont systemFontOfSize:15];
        [_recordBgView addSubview:_recordLabel];
        
        [_recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_recordImgView.mas_right).offset(8);
            make.centerY.mas_equalTo(_recordImgView.mas_centerY);
        }];
    }
    return _recordLabel;
}

- (UILabel *)recordDetailLabel
{
    if (!_recordDetailLabel) {
        _recordDetailLabel = [[UILabel alloc] init];
        _recordDetailLabel.textColor = HEXCOLOR(0x7a7a7a);
        _recordDetailLabel.font = [UIFont systemFontOfSize:15];
        [_recordBgView addSubview:_recordDetailLabel];
        
        [_recordDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_recordLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(_recordLabel.mas_left);
        }];
    }
    return _recordDetailLabel;
}

- (ZZSecurityAudioWaveView *)waveView
{
    if (!_waveView) {
        _waveView = [[ZZSecurityAudioWaveView alloc] init];
        _waveView.waveColor = kYellowColor;
        [_recordBgView addSubview:_waveView];
        
        [_waveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_recordLabel.mas_left);
            make.right.mas_equalTo(_recordBgView.mas_right).offset(-30);
            make.top.mas_equalTo(_recordDetailLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(@40);
            make.bottom.mas_equalTo(_recordBgView.mas_bottom).offset(-5);
        }];
    }
    return _waveView;
}

- (UIImageView *)contactImgView
{
    if (!_contactImgView) {
        _contactBgView = [[UIView alloc] init];
        [self addSubview:_contactBgView];
        
        [_contactBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_locationBgView.mas_bottom).offset(5);
        }];
        
        _contactImgView = [[UIImageView alloc] init];
        [_contactBgView addSubview:_contactImgView];
        
        [_contactImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contactBgView.mas_left).offset(35);
            make.top.mas_equalTo(_contactBgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _contactImgView;
}

- (UILabel *)contactLabel
{
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc] init];
        _contactLabel.textColor = HEXCOLOR(0x7a7a7a);
        _contactLabel.font = [UIFont systemFontOfSize:15];
        [_contactBgView addSubview:_contactLabel];
        
        [_contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contactImgView.mas_right).offset(8);
            make.centerY.mas_equalTo(_contactImgView.mas_centerY);
        }];
    }
    return _contactLabel;
}

- (UILabel *)contactDetailLabel
{
    if (!_contactDetailLabel) {
        _contactDetailLabel = [[UILabel alloc] init];
        _contactDetailLabel.font = [UIFont systemFontOfSize:15];
        _contactDetailLabel.userInteractionEnabled = YES;
        _contactDetailLabel.numberOfLines = 0;
        [_contactBgView addSubview:_contactDetailLabel];
        
        [_contactDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contactLabel.mas_left);
            make.right.mas_equalTo(_contactBgView.mas_right).offset(-30);
            make.top.mas_equalTo(_contactLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_contactBgView.mas_bottom).offset(-5);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactSettingClick)];
        [_contactDetailLabel addGestureRecognizer:recognizer];
    }
    return _contactDetailLabel;
}

- (UIImageView *)locationImgView
{
    if (!_locationImgView) {
        _locationBgView = [[UIView alloc] init];
        [self addSubview:_locationBgView];
        
        [_locationBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_recordBgView.mas_bottom).offset(10);
        }];
        
        _locationImgView = [[UIImageView alloc] init];
        [_locationBgView addSubview:_locationImgView];
        
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationBgView.mas_left).offset(35);
            make.top.mas_equalTo(_locationBgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.bottom.mas_equalTo(_locationBgView.mas_bottom).offset(-5);
        }];
    }
    return _locationImgView;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = HEXCOLOR(0x7a7a7a);
        _locationLabel.font = [UIFont systemFontOfSize:15];
        [_locationBgView addSubview:_locationLabel];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationImgView.mas_right).offset(8);
            make.centerY.mas_equalTo(_locationImgView.mas_centerY);
        }];
    }
    return _locationLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setImage:[UIImage imageNamed:@"icon_security_cancel"] forState:UIControlStateNormal];
        [self addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-40);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(94, 94));
        }];
    }
    return _cancelBtn;
}

@end
