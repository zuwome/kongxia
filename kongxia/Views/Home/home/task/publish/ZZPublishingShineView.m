//
//  ZZPublishingShineView.m
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishingShineView.h"

#import "ZZDateHelper.h"
#import "ZZFastRentManager.h"

@interface ZZPublishingShineView ()

@property (nonatomic, strong) UIView *animateBgView;
@property (nonatomic, strong) UIImageView *centenImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZZPublishingShineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.8);
        
        [self addSubview:self.animateBgView];
        [self addSubview:self.centenImgView];
        [self addSubview:self.titleLabel];
        self.countLabel.text = @"已通知111人";
    }
    
    return self;
}

- (void)removeAnimations
{   
    [self clearTimer];
    self.hidden = YES;
    _index = 5;
    self.animateBgView.hidden = YES;
    [self.viewsArray removeAllObjects];
    [self.animateBgView removeAllSubviews];
}

- (void)animate
{
    self.hidden = NO;
    self.animateBgView.hidden = NO;
    _index = 0;
    for (int i=0; i<5; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:_centenImgView.frame];
        view.image = [UIImage imageNamed:@"icon_livestream_publish_bg"];
        [self.animateBgView addSubview:view];
        [self.viewsArray addObject:view];
    }
    
    [self addViewAnimations];
    
    _maxCount = (arc4random() % 50 + 150);
    _currentCount = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animateCount) userInfo:nil repeats:YES];
    [self animateCount];
}

- (void)animateCount
{
//    NSInteger plus = arc4random()%10;
    _currentCount = _currentCount + 1;
//    if (_during > 150 && _during < 180) {  // 倒计时180s，前30秒随机加1-5，后160秒随机加0-2
//        _currentCount = _currentCount + arc4random() % 5 + 1;
//    } else if (_during <= 150) {
//        _currentCount = _currentCount + arc4random() % 3;
//    }
    if (_currentCount > _maxCount) {
        [self clearTimer];
    }
    [self showText:_currentCount];
}

- (void)showText:(NSInteger)count
{
    NSString *countString = [NSString stringWithFormat:@"%ld",count];
    NSString *string = [NSString stringWithFormat:@"已通知%@位达人",countString];
    NSRange range = [string rangeOfString:countString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(254, 95, 84) range:range];
    _countLabel.attributedText = attributedString;
}

- (void)clearTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setDuring:(NSInteger)during
{
    _during = during;
    self.titleLabel.text = [ZZDateHelper getCountdownTimeString:during];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    if (type == 2) {
        self.centenImgView.image = [UIImage imageNamed:@"icon_livestream_video"];
    } else {
        self.centenImgView.image = [UIImage imageNamed:@"icon_task_down"];
    }
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    if ([ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstTaskCancelConfirmAlert]) {
        [self cancelRequest];
    } else {
        WeakSelf;
        _cancelAlert = [[ZZTaskCancelConfirmAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.window addSubview:_cancelAlert];
        _cancelAlert.touchCancel = ^{
            [weakSelf cancelRequest];
        };
    }
}

- (void)cancelRequest
{
    [GetFastRentManager() syncUpdateMissionStatus:NO];
    _cancelBtn.userInteractionEnabled = NO;
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd/%@/cancel",_pId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _cancelBtn.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"任务已取消"];
            [self remove];
        }
    }];
}

#pragma mark -

- (void)addViewAnimations
{
    if (_index == 5) {
        return;
    }
    UIImageView *imgView = self.viewsArray[_index];
    [imgView.layer removeAllAnimations];
    [self beginAnimation:imgView];
    _index++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addViewAnimations];
    });
}

- (void)beginAnimation:(UIView *)view
{
    CGFloat scale = SCREEN_WIDTH / _centenImgView.width;
    if (ISiPhone4) {
        scale = (SCREEN_WIDTH - 40) /_centenImgView.width;
    }
    scale = scale * 1.5;//雷达效果放大1.5倍
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:scale]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 2.5;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = @[animation,opacityAnimation];
    
    [view.layer addAnimation:group forKey:@"group"];
}

- (void)remove
{
    [self removeAnimations];
    [self removeFromSuperview];
}

#pragma mark - lazyload

- (UIView *)animateBgView
{
    if (!_animateBgView) {
        _animateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    }
    return _animateBgView;
}

- (UIImageView *)centenImgView
{
    if (!_centenImgView) {
        _centenImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
        _centenImgView.image = [UIImage imageNamed:@"icon_livestream_video"];
        if (ISiPhone4) {
            _centenImgView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0);
        } else if (ISiPhone5) {
            _centenImgView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0+20);
        } else {
            _centenImgView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0+50);
        }
    }
    return _centenImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        CGFloat topOffset;
        if (ISiPhone4) {
            topOffset = SCREEN_WIDTH - 20;
        }
        else if (ISiPhone5) {
            topOffset = SCREEN_WIDTH + 20;
        }
        else {
            topOffset = SCREEN_WIDTH + 40;
        }
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top).offset(topOffset);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:21];
        [self addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view);
            make.top.mas_equalTo(65);
        }];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_livestream_publish_bg3"] forState:UIControlStateNormal];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_countLabel.mas_bottom).offset(12);
            make.top.mas_equalTo(40);
            make.centerX.mas_equalTo(view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(157, 50));
        }];
    }
    return _countLabel;
}

- (NSMutableArray *)viewsArray
{
    if (!_viewsArray) {
        _viewsArray = [NSMutableArray array];
    }
    return _viewsArray;
}

@end
