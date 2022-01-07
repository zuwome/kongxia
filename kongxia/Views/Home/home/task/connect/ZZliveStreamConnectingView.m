//
//  ZZliveSteamConnectingView.m
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//
/** 用于捕捉挂断的*/
#import "ZZDateHelper.h"
/** 用于捕捉挂断的*/
#import "ZZliveStreamConnectingView.h"
#import "ZZliveStreamHeadView.h"
#import "ZZLiveStreamConnectCancelAlert.h"

#import "ZZLiveStreamHelper.h"
#import "ZZChatManagerNetwork.h"
@interface ZZliveStreamConnectingView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) ZZliveStreamHeadView *headView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIImageView *animateImgView;
@property (nonatomic, strong) UIImageView *centerImgView;

@property (nonatomic, strong) ZZLiveStreamConnectCancelAlert *alert;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat yScale;

@end

@implementation ZZliveStreamConnectingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.9);
        
        self.bgView.hidden = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refuseNotification:) name:kMsg_RefuseConnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBusy:) name:kMsg_BusyConnect object:nil];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user
{
    _user = user;
    [self.headView.headImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar]];
    
    NSString *string = [NSString stringWithFormat:@"与%@视频连线中...", user.nickname];
    NSRange range = [string rangeOfString:user.nickname];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:range];
    _nameLabel.attributedText = attributedString;
}

- (void)setShowCancel:(BOOL)showCancel
{
    _showCancel = showCancel;
    if (showCancel) {
        self.cancelBtn.superview.hidden = NO;
    } else {
        self.cancelBtn.superview.hidden = YES;
    }
}

- (void)show
{
    if (CGRectIsNull(_sourceRect)) {
        CGFloat offset = (SCREEN_HEIGHT/667.0)*104;
        CGFloat width = _scale*295;
        UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:_sourceRect];
        [tempImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar]];
        [self addSubview:tempImgView];
        
        CGRect targetRect = CGRectMake((SCREEN_WIDTH - width)/2, offset, width, width);
        
        [UIView animateWithDuration:0.3 animations:^{
            tempImgView.frame = targetRect;
        } completion:^(BOOL finished) {
            self.bgView.hidden = NO;
            [tempImgView removeFromSuperview];
        }];
    } else {
        self.bgView.hidden = NO;
    }
}

- (void)remove
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timer invalidate];
        _timer = nil;
        [self removeFromSuperview];
    });
}

#pragma mark - 通知

- (void)refuseNotification:(NSNotification *)notification
{
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    if ([uid isEqualToString:_user.uid]) {
        WS(weakSelf);

        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_SAFE_CALLS(self.noPenaltyBlock, YES);
            weakSelf.statusLabel.text = @"对方拒接或不在线\n本次连接将不收取费用";
            [weakSelf userRefuse];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf cancelRequest:NO];
        });
    }
}
/*
 女方拒绝接受视屏男方发消息
 */
- (void)userRefuse {
    
    [ZZChatManagerNetwork sendVideoMessageWithDestinationUidString:self.user.uid withType:@"3" sendType:@"女方"  chatContent:@"hi，暂不方便接通你的闪聊视频通话"];
}

- (void)receiveBusy:(NSNotification *)notification
{
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    if ([uid isEqualToString:_user.uid]) {
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.statusLabel.text = @"对方已接任务或不在线\n下次选TA要快哦";
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf cancelRequest:NO];
            });
        });
    }
}

#pragma mark -

- (void)timerEvent
{
    _count++;
    
    if (_count == 100) {//当连接中为10秒的时候
        BLOCK_SAFE_CALLS(self.noPenaltyBlock, YES);
    }
    
    if (_count > 300) {
        _count = 300;
        if (_timeOut) {
            _timeOut();
        }
        [_timer invalidate];
        _timer = nil;
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.accept) {
                weakSelf.statusLabel.text = @"连线超时";
            } else {
                BLOCK_SAFE_CALLS(weakSelf.noPenaltyBlock, YES);
                weakSelf.statusLabel.text = @"对方拒接或不在线\n本次连接将不收取费用";
            }
        });
       dispatch_async(dispatch_get_main_queue(), ^{
            [ZZLiveStreamHelper sharedInstance].isBusy = NO;
            [ZZLiveStreamHelper sharedInstance].noSendFinish = YES;
           [ZZUserDefaultsHelper setObject:@"超时挂断" forDestKey:[ZZDateHelper getCurrentDate]];

            [[ZZLiveStreamHelper sharedInstance] disconnect];
            [weakSelf remove];
        });
    } else {
        self.headView.progress =  1 - _count/300.0;
    }
}

- (void)beginAnimation
{
    [self.animateImgView.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.5;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = @[animation,opacityAnimation];
    
    [self.animateImgView.layer addAnimation:group forKey:@"group"];
}

- (void)cancelBtnClick
{
    WeakSelf;
    _alert = [[ZZLiveStreamConnectCancelAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self addSubview:_alert];
    _alert.touchCancel = ^{
        [weakSelf cancelRequest:YES];
    };
}

- (void)cancelRequest:(BOOL)sendMessage
{
    [ZZLiveStreamHelper sharedInstance].noSendFinish = YES;
    [ZZUserDefaultsHelper setObject:@"后台校验一个取消挂断" forDestKey:[ZZDateHelper getCurrentDate]];
    [[ZZLiveStreamHelper sharedInstance] disconnect];
  
    [self remove];
    if (sendMessage) {
        [ZZUtils sendCommand:@"cancel" uid:self.user.uid param:@{@"type":@"100"}];
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
        self.statusLabel.text = @"视频中遇到没有正脸出镜的达人可以挂断举报";
        self.cancelBtn.superview.hidden = YES;
        
        [self beginAnimation];
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
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:16];
        _statusLabel.numberOfLines = 0;
        [_bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView.mas_bottom).offset(_yScale*36);
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
        }];
    }
    return _statusLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        UIView *bottomView = [[UIView alloc] init];
        [_bgView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(_statusLabel.mas_bottom);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        [_bgView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerX.centerY.mas_equalTo(bottomView);
        }];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_livestream_publish_bg2"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_cancelBtn];

        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(157, 50));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17*_scale];
        label.text = @"取消视频";
        label.hidden = YES;
        [bgView addSubview:label];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.mas_equalTo(bgView);
            make.top.mas_equalTo(_cancelBtn.mas_bottom).offset(12);
        }];
        
    }
    return _cancelBtn;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
