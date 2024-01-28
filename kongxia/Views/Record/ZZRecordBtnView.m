//
//  ZZRecordBtnView.m
//  zuwome
//
//  Created by angBiu on 2016/12/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordBtnView.h"

#import "ZZRecordInfoView.h"

@interface ZZRecordBtnView ()
{
    dispatch_source_t _sourceTimer;
}

@property (nonatomic, strong) ZZRecordInfoView *infoView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIImageView *pauseImgView;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, assign) CGFloat infoCount;

@end

@implementation ZZRecordBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.infoView.hidden = NO;
        [self addSubview:self.grayView];
        [self addSubview:self.yellowView];
        self.grayView.center = CGPointMake(self.width/2, 80);
        self.yellowView.center = CGPointMake(self.width/2, 80);
        self.pauseImgView.center = _grayView.center;
        
        [self addSubview:self.coverBtn];
        [self showInfoText:@"点击录制"];
        [self hideInfoViewWithInterval:3];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

#pragma mark -

- (void)hideInfoViewWithInterval:(NSInteger)interval
{
    _infoCount = 3 - interval;
    if (_sourceTimer) {
        dispatch_source_cancel(_sourceTimer);
    }
    
    _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_sourceTimer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_sourceTimer, ^{
        if (_infoCount == 3) {
            self.infoView.hidden = YES;
            dispatch_source_cancel(_sourceTimer);
        }
        _infoCount++;
    });
    dispatch_resume(_sourceTimer);
}

- (void)showInfoText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoView.hidden = NO;
        self.infoView.titleLabel.text = @"";
        self.infoView.titleLabel.text = text;
    });
    [self hideInfoViewWithInterval:3];
}

- (void)stopRecord
{
    if (_isDelay) {
        return;
    }
    [self finishRecord:YES];
}

- (void)recordClick
{
    [MobClick event:Event_click_record_record];
    if (_haveStartRecord) {
        [self finishRecord:YES];
    } else {
        if (_isDelay) {
            self.infoView.hidden = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(recordViewBeginDelayReocrd)]) {
                [_delegate recordViewBeginDelayReocrd];
            }
            return;
        }
        [self beginRecord];
    }
}

- (void)beginRecord
{
    _haveStartRecord = YES;

    [self viewTransfrom];
}

- (void)viewTransfrom
{
    [self recordingStatus];
    
    if (_delegate && [_delegate respondsToSelector:@selector(recordViewStatrRecord)]) {
        [_delegate recordViewStatrRecord];
    }
}

- (void)finishRecord:(BOOL)limit
{
    if (_count < _minDuring*100 && _isDelay && limit) {
        [self showInfoText:@"录制时间过短"];
        return;
    }
    [self.coverBtn removeFromSuperview];
    [self stopTimer];
    
    _haveStartRecord = NO;
    [self normalStatus];
    if (_count<_minDuring*100 && limit) {
        self.infoView.hidden = NO;
        [self showInfoText:@"录制时间过短"];
        if (_delegate && [_delegate respondsToSelector:@selector(recordViewTooShort)]) {
            [_delegate recordViewTooShort];
        }
    } else {
        [self hideInfoViewWithInterval:0];
        if (_delegate && [_delegate respondsToSelector:@selector(recordViewEndRecord)]) {
            [_delegate recordViewEndRecord];
        }
    }
    [self addSubview:self.coverBtn];
}

- (void)stopTimer
{
    [_countTimer invalidate];
    _countTimer = nil;
}

- (void)startTimer
{
    _count = 0;
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(countVideoTime) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
}

- (void)countVideoTime
{
    _count++;
    if (_count == _minDuring*100) {
        [self showInfoText:@"轻触按钮结束录制"];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(recordViewProgressing)]) {
        [_delegate recordViewProgressing];
    }
}

- (void)normalStatus
{
    self.pauseImgView.hidden = YES;
    self.grayView.alpha = 1.0;
    self.yellowView.hidden = NO;
    [self.grayView.layer removeAllAnimations];
}

- (void)recordingStatus
{
    self.pauseImgView.hidden = NO;
    self.yellowView.hidden = YES;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.4];
    animation.duration = 1.5;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    [self.grayView.layer addAnimation:animation forKey:@"opacityAnimation"];
}

#pragma mark - Notification

- (void)appEnterBackground
{
    if (_haveStartRecord) {
        [self.coverBtn removeFromSuperview];
        [self stopTimer];
        
        _haveStartRecord = NO;
        [self normalStatus];
        if (_delegate && [_delegate respondsToSelector:@selector(recordViewTooShort)]) {
            [_delegate recordViewTooShort];
        }
        [self addSubview:self.coverBtn];
    }
}

#pragma mark - lazyload

- (ZZRecordInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[ZZRecordInfoView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        [self addSubview:_infoView];
        
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top);
            make.height.mas_equalTo(@25);
        }];
    }
    return _infoView;
}

- (UIView *)yellowView
{
    if (!_yellowView) {
        _yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _yellowView.backgroundColor = kYellowColor;
        _yellowView.layer.cornerRadius = 30;
    }
    return _yellowView;
}

- (UIView *)grayView
{
    if (!_grayView) {
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
        _grayView.layer.cornerRadius = 39;
        _grayView.clipsToBounds = YES;
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = _grayView.frame;
        [_grayView addSubview:effectview];
    }
    
    return _grayView;
}

- (UIImageView *)pauseImgView
{
    if (!_pauseImgView) {
        _pauseImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 24)];
        _pauseImgView.image = [UIImage imageNamed:@"icon_record_pause"];
        _pauseImgView.hidden = YES;
        [self addSubview:_pauseImgView];
    }
    return _pauseImgView;
}

- (UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = CGRectMake(0, 0, self.width, self.height);
        [_coverBtn removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
        [_coverBtn addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    }
    return _coverBtn;
}

- (void)dealloc
{
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
