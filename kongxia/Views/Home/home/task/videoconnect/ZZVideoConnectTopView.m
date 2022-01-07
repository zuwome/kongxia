//
//  ZZVideoConnectTopView.m
//  zuwome
//
//  Created by YuTianLong on 2018/1/17.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZVideoConnectTopView.h"
#import "ZZLiveStreamHelper.h"
#import "WBReachabilityManager.h"
#import "ZZCallIphoneVideoManager.h"
#import "ZZLocalPushManager.h"
@interface ZZTokenButtonView : UIView

@property (nonatomic, strong) UIImageView *animateImgView;//雷达动画背景
@property (nonatomic, strong) UIImageView *iconImageView;//设置icon
@property (nonatomic, strong) UILabel *titleLabel;//设置title
@property (nonatomic, assign) BOOL isAnimation;//是否需要雷达动画

@property (nonatomic, strong) UIButton *clickBtn;//不需要设置
@property (nonatomic, copy) void (^clickBlock)(void);//点击回调

- (void)endAnimation;//移除动画

@end

@implementation ZZTokenButtonView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZTokenButtonView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZTokenButtonView);
    }
    return self;
}

commonInitImplementationSafe(ZZTokenButtonView) {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.animateImgView = [[UIImageView alloc] init];
    self.animateImgView.alpha = 1;
    self.animateImgView.layer.cornerRadius = 20;
    self.animateImgView.clipsToBounds = YES;
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
 
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickBtn.backgroundColor = [UIColor clearColor];
    [self.clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.animateImgView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.clickBtn];
    
    [self.animateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(@0);
        make.width.height.equalTo(@40);
    }];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(@0);
        make.width.height.equalTo(@40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(@0);
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
}

- (IBAction)clickBtnClick:(UIButton *)sender {
    BLOCK_SAFE_CALLS(self.clickBlock);
}

- (void)setIsAnimation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
    
    if (isAnimation) {
        [self beginAnimation];
    }
}

- (void)beginAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.5]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = @[animation,opacityAnimation];
    
    [self.animateImgView.layer addAnimation:group forKey:@"group"];
}

- (void)endAnimation {
    if (_isAnimation) {
        [self.animateImgView.layer removeAllAnimations];
    }
}

@end

@interface ZZVideoConnectTopView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;//毛玻璃

@property (nonatomic, strong) UIImageView *headImageView;//头像
@property (nonatomic, strong) UILabel *nickName;//昵称
@property (nonatomic, strong) UILabel *tips;//文案
@property (nonatomic, strong) UIImageView *rightImageView;//箭头
@property (nonatomic, strong) UIButton *maskBtn;//遮罩btn, 用于点击局部

@property (nonatomic, strong) ZZTokenButtonView *hangUpButton;//挂断
@property (nonatomic, strong) ZZTokenButtonView *throughButton;//接通

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZZVideoConnectTopView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZVideoConnectTopView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZVideoConnectTopView);
    }
    return self;
}

commonInitImplementationSafe(ZZVideoConnectTopView) {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelMessage:) name:kMsg_CancelConnect object:nil];
    
    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
    [[ZZCallIphoneVideoManager shared] beginRing];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    WEAK_SELF();
    self.backgroundColor = [UIColor clearColor];

    // 阴影层 //icon_shadowBg
    self.shadowView = [UIImageView new];
    self.shadowView.frame = CGRectMake(5, 20, SCREEN_WIDTH - 10, 160);
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
    self.shadowView.layer.shadowRadius = 2.0f;
    self.shadowView.layer.cornerRadius = 4.0f;
    self.shadowView.userInteractionEnabled = YES;
    
    if (IOS11_OR_LATER) {
        self.shadowView.layer.shadowOpacity = 0.4;//不透明度
    } else {//ios 11以下 阴影圆角 和 毛玻璃同时使用，阴影会有问题，先用图片为阴影
        self.shadowView.height = 162;
        self.shadowView.layer.masksToBounds = YES;
        self.shadowView.layer.cornerRadius = 7.0f;
        self.shadowView.image = stretchImgFromMiddle([UIImage imageNamed:@"icon_shadowBg"]);
    }
    
    // 毛玻璃层
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 10, 160);
    self.effectView.layer.masksToBounds = YES;
    self.effectView.layer.cornerRadius = 4.0f;
    self.effectView.alpha = 1.0;
    
    self.headImageView = [UIImageView new];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 4.0f;
    
    self.nickName = [UILabel new];
    self.nickName.textColor = [UIColor blackColor];
    self.nickName.font = [UIFont systemFontOfSize:17];
    
    self.tips = [UILabel new];
    self.tips.textColor = RGBCOLOR(85, 85, 85);
    self.tips.font = [UIFont systemFontOfSize:15];
    
    self.rightImageView = [UIImageView new];
    self.rightImageView.image = [UIImage imageNamed:@"icon_rightBtn"];
    
    self.maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maskBtn.backgroundColor = [UIColor clearColor];
    [self.maskBtn addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kGrayLineColor;
    
    // icon_livestream_refuse1
    self.hangUpButton = [ZZTokenButtonView new];
    self.hangUpButton.titleLabel.text = @"挂断";
    self.hangUpButton.iconImageView.image = [UIImage imageNamed:@"icon_livestream_refuse1"];
    [self.hangUpButton setClickBlock:^{
        if (!GetReachabilityManager().isReachable) {//没有网络
            [ZZHUD showErrorWithStatus:@"网络异常，请检查"];
            return ;
        }
        weakSelf.userInteractionEnabled = NO;
        BLOCK_SAFE_CALLS(weakSelf.hangUpButtonBlock);
    }];
    
    // icon_livestream_accept1
    self.throughButton = [ZZTokenButtonView new];
    self.throughButton.titleLabel.text = @"接通";
    self.throughButton.iconImageView.image = [UIImage imageNamed:@"icon_livestream_accept1"];
    self.throughButton.animateImgView.image = [UIImage imageNamed:@"icon_animation_bg"];
    self.throughButton.isAnimation = YES;
    [self.throughButton setClickBlock:^{
        if (!GetReachabilityManager().isReachable) {//没有网络
            [ZZHUD showErrorWithStatus:@"网络异常，请检查"];
            return ;
        }
        weakSelf.userInteractionEnabled = NO;
        BLOCK_SAFE_CALLS(weakSelf.throughButtonBlock);
    }];
    
    [self addSubview:self.shadowView];
    [self.shadowView addSubview:self.effectView];
    
    [self.effectView.contentView addSubview:self.headImageView];
    [self.effectView.contentView addSubview:self.nickName];
    [self.effectView.contentView addSubview:self.tips];
    [self.effectView.contentView addSubview:self.rightImageView];
    [self.effectView.contentView addSubview:self.maskBtn];
    [self.effectView.contentView addSubview:lineView];
    [self.effectView.contentView addSubview:self.hangUpButton];
    [self.effectView.contentView addSubview:self.throughButton];
        
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@12);
        make.top.equalTo(@14);
        make.width.height.equalTo(@64);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.trailing.equalTo(@(-20));
        make.width.equalTo(@11.5);
        make.height.equalTo(@20);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top).offset(10);
        make.leading.equalTo(self.headImageView.mas_trailing).offset(13);
        make.trailing.equalTo(self.rightImageView.mas_leading).offset(-10);
    }];
    
    [self.tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(-10);
        make.leading.equalTo(self.nickName.mas_leading);
        make.trailing.equalTo(self.nickName.mas_trailing);
    }];
    
    [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@86);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.trailing.equalTo(@(-10));
        make.height.equalTo(@1);
    }];
    
    [self.hangUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-14));
        make.leading.equalTo(@20);
        make.height.equalTo(@40);
        make.width.equalTo(@95);
    }];
    
    [self.throughButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-14));
        make.trailing.equalTo(@(-20));
        make.height.equalTo(@40);
        make.width.equalTo(@95);
    }];
    
    [NSObject asyncWaitingWithTime:1.0f completeBlock:^{
        [weakSelf jiaoYan];
    }];
}

#pragma mark - Getter
- (void)setUser:(ZZUser *)user {
    _user = user;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:nil options:(SDWebImageRetryFailed)];
    self.nickName.text = user.nickname;
    self.tips.text = @"视频结束后可获得收益";
}

#pragma mark - Private methods

- (void)jiaoYan {
    WEAK_SELF();
    self.userInteractionEnabled = NO;
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/room/%@/status", [ZZLiveStreamHelper sharedInstance].room_id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (data) {
            NSNumber *string = [data objectForKey:@"status"];
            if ([string intValue] == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.userInteractionEnabled = NO;
                    [weakSelf recyclingAnimateCompleted:^{
                        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
                        [weakSelf dismiss];
                    }];
                });
            } else {
                weakSelf.userInteractionEnabled = YES;
            }
        }
    }];
}

- (void)timerEvent {
    _count++;
    // 600 = 60秒 = 1分钟 等待超时时间
    WEAK_SELF();
    NSLog(@"%ld", _count);
    if (_count > 600) {
        _count = 600;
        if ([ZZLocalPushManager runningInBackground]) { //如果处于后台，存储本地一个标志，告知对方已经取消
            [ZZLocalPushManager cancelLocalNotificationWithKey:[ZZLocalPushManager callIphoneKey]];
        }
        // 等待时间超时 相当于挂断
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userInteractionEnabled = NO;
            [weakSelf recyclingAnimateCompleted:^{
                [ZZLiveStreamHelper sharedInstance].isBusy = NO;
                [weakSelf dismiss];
                
            }];
        });
    }
}

- (void)receiveCancelMessage:(NSNotification *)notification {
    WEAK_SELF();
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    NSString *rId = [notification.userInfo objectForKey:@"rid"];
    if ([uid isEqualToString:_user.uid] && [[ZZLiveStreamHelper sharedInstance].room_id isEqualToString:rId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userInteractionEnabled = NO;
            [weakSelf recyclingAnimateCompleted:^{
                [ZZLiveStreamHelper sharedInstance].isBusy = NO;
                [weakSelf dismiss];
            }];
        });
    }
}

// 进入等待
- (IBAction)maskBtnClick:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    WEAK_SELF();
    BLOCK_SAFE_CALLS(weakSelf.gotoWaitingBlock);
}

// 内部统一收回动画
- (void)recyclingAnimateCompleted:(void (^)(void))completed {
    self.shadowView.image = nil;
    [UIView animateWithDuration:0.4 animations:^{
        self.mj_y = -180;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        BLOCK_SAFE_CALLS(completed);
    }];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.throughButton endAnimation];
    [self.timer invalidate];
    self.timer = nil;
    _count = 0;
    [[ZZCallIphoneVideoManager shared] stopRing];
    [self removeFromSuperview];
}

@end
