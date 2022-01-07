//
//  ZZPublishOrderPublishView.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishOrderPublishView.h"

@interface ZZPublishOrderPublishView ()

@property (nonatomic, strong) UIImageView *animateImgView;
@property (nonatomic, strong) UIImageView *anonymousImgView;

@end

@implementation ZZPublishOrderPublishView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.animateImgView = [[UIImageView alloc] init];
        self.animateImgView.image = [UIImage imageNamed:@"icon_livestream_publish_bg"];
        self.animateImgView.alpha = 1;
        self.animateImgView.layer.cornerRadius = 35;
        self.animateImgView.clipsToBounds = YES;
        [self addSubview:self.animateImgView];
        
        [self.animateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        UIButton *publishBtn = [[UIButton alloc] init];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"icon_livestream_publish_bg"] forState:UIControlStateNormal];
        [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [publishBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        publishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        publishBtn.layer.cornerRadius = 35;
        publishBtn.clipsToBounds = YES;
        [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        
        [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        UIButton *anonymousBtn = [[UIButton alloc] init];
        [anonymousBtn addTarget:self action:@selector(anonymousBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:anonymousBtn];
        
        [anonymousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
        
        _anonymousImgView = [[UIImageView alloc] init];
        _anonymousImgView.userInteractionEnabled = NO;
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_n"];
        [anonymousBtn addSubview:_anonymousImgView];
        
        [_anonymousImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(anonymousBtn.mas_right).offset(-5);
            make.centerY.mas_equalTo(anonymousBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        
        UILabel *anonymousLabel = [[UILabel alloc] init];
        anonymousLabel.textColor = kBlackTextColor;
        anonymousLabel.font = [UIFont systemFontOfSize:15];
        anonymousLabel.text = @"匿名";
        anonymousLabel.userInteractionEnabled = NO;
        [anonymousBtn addSubview:anonymousLabel];
        
        [anonymousLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_anonymousImgView.mas_left).offset(-8);
            make.centerY.mas_equalTo(anonymousBtn.mas_centerY);
        }];
        
        [self beginAnimation];
    }
    
    return self;
}

- (void)setIsAnonymous:(BOOL)isAnonymous
{
    _isAnonymous = isAnonymous;
    if (_isAnonymous) {
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_p"];
    } else {
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_n"];
    }
}

- (void)anonymousBtnClick
{
    if (_isAnonymous) {
        _isAnonymous = NO;
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_n"];
    } else {
        _isAnonymous = YES;
        _anonymousImgView.image = [UIImage imageNamed:@"btn_report_p"];
    }
    if (_touchAnonymous) {
        _touchAnonymous();
    }
}

- (void)publishBtnClick
{
    if (_touchPublish) {
        _touchPublish();
    }
}

- (void)beginAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.7]; // 结束时的倍率
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

- (void)endAnimation
{
    [self.animateImgView.layer removeAllAnimations];
}

@end
