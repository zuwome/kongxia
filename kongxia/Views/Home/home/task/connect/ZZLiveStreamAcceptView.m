//
//  ZZLiveStreamAcceptView.m
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamAcceptView.h"
#import "ZZliveStreamHeadView.h"

#import "ZZLiveStreamVideoAlert.h"
#import "ZZLiveStreamHelper.h"

#import <RongIMLib/RongIMLib.h>

@interface ZZLiveStreamAcceptView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) ZZliveStreamHeadView *headView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, strong) UIButton *acceptBtn;

@property (nonatomic, strong) ZZLiveStreamVideoAlert *cancelAlert;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat yScale;

@property (nonatomic, assign) BOOL isAccept;    //点击过一次接通

@end

@implementation ZZLiveStreamAcceptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.9);
        
        self.bgView.hidden = NO;
        self.isAccept = NO;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelMessage:) name:kMsg_CancelConnect object:nil];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user
{
    _user = user;
    [self.headView.headImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar]];
//    _nameLabel.text = user.nickname;
    NSString *string = [NSString stringWithFormat:@"%@申请与您视频通话", user.nickname];
    NSRange range = [string rangeOfString:user.nickname];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:range];
    _nameLabel.attributedText = attributedString;
}

- (void)remove
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timer invalidate];
        _timer = nil;
        [_cancelAlert removeFromSuperview];
        [self removeFromSuperview];
    });
}

- (void)acceptBtnClick
{
    if (self.isAccept) {
        return;
    }
    if (_touchAccept) {
        self.isAccept = YES;
        self.acceptBtn.enabled = NO;
        self.refuseBtn.enabled = NO;
        _touchAccept();
    }
}

- (void)refuseBtnClick
{
    [self addSubview:self.cancelAlert];
}

- (void)sendRefuseMessage
{
    [ZZUtils sendCommand:@"refuse" uid:self.user.uid param:@{@"type":@"101"}];
    [ZZLiveStreamHelper sharedInstance].isBusy = NO;
}

- (void)receiveCancelMessage:(NSNotification *)notification
{
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    if ([uid isEqualToString:_user.uid]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZZLiveStreamHelper sharedInstance].isBusy = NO;
            [self showErrorInfo:@"对方已取消视频"];
        });
    }
}

- (void)showErrorInfo:(NSString *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = error;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self remove];
        });
    });
}

#pragma mark -

- (void)timerEvent
{
    _count++;
    if (_count>300) {
        _count = 300;
        if (_timeOut) {
            _timeOut();
        }
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
        [self remove];
    } else {
        self.headView.progress =  1 - _count/300.0;
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:_bgView];
        
        _scale = SCREEN_WIDTH/375.0;
        if (_scale > 1) {
            _scale = 1;
        }
        _yScale = SCREEN_HEIGHT/667.0;
        if (_yScale > 1) {
            _yScale = 1;
        }
        
        self.headView.hidden = NO;
        self.nameLabel.text = @"11111";
        self.statusLabel.text = @"视频过程中 请确保本人正面出镜";
        self.refuseBtn.hidden = NO;
        self.acceptBtn.hidden = NO;
    }
    return _bgView;
}

- (ZZliveStreamHeadView *)headView
{
    if (!_headView) {
        CGFloat offset = (SCREEN_HEIGHT/667.0)*104;
        CGFloat width = _scale*295;
        
        _headView = [[ZZliveStreamHeadView alloc] init];
        [_bgView addSubview:_headView];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(offset);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
    return _headView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:24*_scale];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headView.mas_top).offset(-_yScale*20);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
    }
    return _nameLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:18];
        [_bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView.mas_bottom).offset(_yScale*36);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
        
        _bottomView = [[UIView alloc] init];
        [_bgView addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgView);
            make.top.mas_equalTo(_statusLabel.mas_bottom);
        }];
    }
    return _statusLabel;
}

- (UIButton *)refuseBtn
{
    if (!_refuseBtn) {
        _refuseBtn = [[UIButton alloc] init];
        [_refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_refuseBtn];
        
        [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_left).offset(SCREEN_WIDTH/4);
            make.centerY.mas_equalTo(_bottomView.mas_centerY);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_refuse"];
        imgView.userInteractionEnabled = NO;
        [_refuseBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_refuseBtn);
            make.size.mas_equalTo(CGSizeMake(64*_scale, 64*_scale));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"拒接";
        label.userInteractionEnabled = NO;
        [_refuseBtn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_refuseBtn.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(11);
            make.bottom.mas_equalTo(_refuseBtn.mas_bottom);
        }];
    }
    return _refuseBtn;
}

- (UIButton *)acceptBtn
{
    if (!_acceptBtn) {
        _acceptBtn = [[UIButton alloc] init];
        [_acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_acceptBtn];
        
        [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_right).offset(-SCREEN_WIDTH/4);
            make.centerY.mas_equalTo(_bottomView.mas_centerY).with.offset(-SafeAreaBottomHeight);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_accept"];
        imgView.userInteractionEnabled = NO;
        [_acceptBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_acceptBtn);
            make.size.mas_equalTo(CGSizeMake(64*_scale, 64*_scale));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"接通";
        label.userInteractionEnabled = NO;
        [_acceptBtn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_acceptBtn.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(11);
            make.bottom.mas_equalTo(_acceptBtn.mas_bottom);
        }];
    }
    return _acceptBtn;
}

- (ZZLiveStreamVideoAlert *)cancelAlert
{
    WeakSelf;
    if (!_cancelAlert) {
        _cancelAlert = [[ZZLiveStreamVideoAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelAlert.type = 1;
        _cancelAlert.touchRight = ^{
            [weakSelf remove];
            if (weakSelf.touchRefuse) {
                weakSelf.touchRefuse();
            }
            [weakSelf sendRefuseMessage];
        };
        _cancelAlert.touchLeft = ^{
            [weakSelf acceptBtnClick];
        };
    }
    return _cancelAlert;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
