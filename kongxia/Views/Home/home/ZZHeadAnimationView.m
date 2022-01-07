//
//  ZZHeadAnimationView.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZHeadAnimationView.h"
#import "ZZWhiteLaceHeadView.h"

@interface ZZHeadAnimationView ()

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) ZZWhiteLaceHeadView *top1;
@property (nonatomic, strong) ZZWhiteLaceHeadView *top2;
@property (nonatomic, strong) ZZWhiteLaceHeadView *top3;

@property (nonatomic, strong) NSArray<ZZWhiteLaceHeadView *> *topsUI;

@end

@implementation ZZHeadAnimationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZHeadAnimationView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZHeadAnimationView);
    }
    return self;
}

commonInitImplementationSafe(ZZHeadAnimationView) {

    self.backgroundColor = [UIColor whiteColor];
    
    self.top1 = [ZZWhiteLaceHeadView new];
    
    self.top2 = [ZZWhiteLaceHeadView new];
    
    self.top3 = [ZZWhiteLaceHeadView new];
    
    [self addSubview:self.top1];
    [self addSubview:self.top2];
    [self addSubview:self.top3];
    
    [self.top3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    [self.top2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.top3.mas_leading).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    [self.top1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.top2.mas_leading).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    // 做动画使用
    self.topsUI = @[self.top3, self.top2, self.top1];
    
    WEAK_SELF();
    NSTimeInterval period = 5.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        [weakSelf cycleAnimation];
    });
    dispatch_resume(_timer);

}

- (void)setUsers:(NSArray<ZZUser *> *)users {
    [users enumerateObjectsUsingBlock:^(ZZUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.top3.urlString = obj.avatar;
        } else if (idx == 1) {
            self.top2.urlString = obj.avatar;
        } else if (idx == 2) {
            self.top1.urlString = obj.avatar;
        }
    }];
}

#pragma mark - Private methods

// 每几秒执行一次
- (void)cycleAnimation {
    
    WEAK_SELF();
    //第一个头像动画
    [NSObject asyncWaitingWithTime:0.10 completeBlock:^{
        [weakSelf animateWithDuration:0.3 alpha:0.0 view:weakSelf.top3];
        [weakSelf starAnimationWithView:weakSelf.top3 time:0.3 scale:0.1];
    }];
    [NSObject asyncWaitingWithTime:0.4 completeBlock:^{
        [weakSelf animateWithDuration:0.2 alpha:0.8 view:weakSelf.top3];
        [weakSelf starAnimationWithView:weakSelf.top3 time:0.2 scale:0.8];
    }];

    //第二个头像动画
    [NSObject asyncWaitingWithTime:0.15 completeBlock:^{
        [weakSelf animateWithDuration:0.3 alpha:0.0 view:weakSelf.top2];
        [weakSelf starAnimationWithView:weakSelf.top2 time:0.3 scale:0.1];
    }];
    [NSObject asyncWaitingWithTime:0.45 completeBlock:^{
        [weakSelf animateWithDuration:0.2 alpha:0.8 view:weakSelf.top2];
        [weakSelf starAnimationWithView:weakSelf.top2 time:0.2 scale:0.8];
    }];

    //第三个头像动画
    [NSObject asyncWaitingWithTime:0.20 completeBlock:^{
        [weakSelf animateWithDuration:0.3 alpha:0.0 view:weakSelf.top1];
        [weakSelf starAnimationWithView:weakSelf.top1 time:0.3 scale:0.1];
    }];
    [NSObject asyncWaitingWithTime:0.50 completeBlock:^{
        [weakSelf animateWithDuration:0.2 alpha:0.8 view:weakSelf.top1];
        [weakSelf starAnimationWithView:weakSelf.top1 time:0.2 scale:0.8];
    }];
}

// 缩放动画
- (void)starAnimationWithView:(ZZWhiteLaceHeadView *)view time:(CGFloat)time scale:(CGFloat)scale {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = time;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //起始倍率
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    //结束时倍率
    animation.toValue = [NSNumber numberWithFloat:scale];
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation];
    groups.duration = time;
    groups.repeatCount = 1;
    groups.autoreverses = YES;
    
    [view.layer addAnimation:groups forKey:@"CombinationAnimation"];
}

- (void)animateWithDuration:(CGFloat)duration alpha:(CGFloat)alpha view:(ZZWhiteLaceHeadView *)view {
    [UIView animateWithDuration:duration animations:^{
        view.alpha = alpha;
    } completion:^(BOOL finished) {
        view.alpha = 1.0f;
    }];
}

@end
