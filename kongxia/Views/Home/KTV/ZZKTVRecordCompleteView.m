//
//  ZZKTVRecordCompleteView.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/14.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVRecordCompleteView.h"

#import "ZZGiftHelper.h"
#import "ZZKTVConfig.h"

@interface ZZKTVRecordCompleteView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UIButton *completeBtn;

@property (nonatomic, strong) ZZPrivateChatGiftView *animationView;

@property (nonatomic, assign) BOOL isRecivedComplete;

@end

@implementation ZZKTVRecordCompleteView

- (instancetype)initWithFrame:(CGRect)frame
                         task:(ZZKTVModel *)model
            isRecivedComplete:(BOOL)isRecivedComplete
                    gift_rate:(CGFloat)gift_rate {
    self = [super initWithFrame:frame];
    if (self) {
        _isRecivedComplete = isRecivedComplete;
        [self layout];
        [self configureModel:model isRecivedComplete:isRecivedComplete gift_rate:gift_rate];
    }
    return self;
}

- (void)configureModel:(ZZKTVModel *)model
     isRecivedComplete:(BOOL)isRecivedComplete
             gift_rate:(CGFloat)gift_rate {
    if (isRecivedComplete) {
        _desLabel.text = [NSString stringWithFormat:@"礼物收益%.2f元已划入钱包",model.gift.price * gift_rate];
        [self showAnimationWithAnimateInfo:@{
            @"icon": model.gift.icon,
            @"lottie": model.gift.lottie,
        }];
    }
    else {
        _subTitleLabel.text = @"来晚了！";
        _desLabel.text = @"礼物刚刚已被领取完，下次要早点来参与哦";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"emoji_kuqi"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_subTitleLabel.mas_top).offset(-32.0);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
    }
    
}


#pragma mark - response method
- (void)close {
    if ([_animationView isAnimationPlaying]) {
        [_animationView stop];
    }
    [self removeFromSuperview];
}


#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.desLabel];
    [self addSubview:self.completeBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (_isRecivedComplete) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(75.0);
        }];
        
        [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-77.5);
            make.size.mas_equalTo(CGSizeMake(126, 50.0));
        }];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_completeBtn.mas_top).offset(-28);
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_desLabel.mas_top).offset(-5);
        }];
    }
    else {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(146);
        }];
        
        [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-146);
            make.size.mas_equalTo(CGSizeMake(126, 50.0));
        }];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_completeBtn.mas_top).offset(-28);
            make.left.equalTo(self).offset(91.0);
            make.right.equalTo(self).offset(-91.0);
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_desLabel.mas_top).offset(-5);
        }];
    }
}

- (void)showAnimationWithAnimateInfo:(NSDictionary *)lottieInfo {
    if (!lottieInfo || isNullString(lottieInfo[@"lottie"])) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutIfNeeded];
        _animationView = [[ZZPrivateChatGiftView alloc] initWithContentsOfURL:[NSURL URLWithString:lottieInfo[@"lottie"]]];
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:lottieInfo[@"icon"]]];
        [_animationView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_animationView);
        }];
        
        [self addSubview:_animationView];
        _animationView.frame = CGRectMake(0.0, _titleLabel.bottom, SCREEN_WIDTH, _subTitleLabel.top - _titleLabel.bottom);
        _animationView.loopAnimation = NO;
        _animationView.cacheEnable = YES;
        _animationView.userInteractionEnabled = YES;
        [_animationView playWithCompletion:^(BOOL animationFinished) {
        }];
    });
}


#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.92);
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"哇！歌神";
        _titleLabel.font = ADaptedFontSCBoldSize(23);
        _titleLabel.textColor = kGoldenRod;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"领取成功！";
        _subTitleLabel.font = ADaptedFontSCBoldSize(19);
        _subTitleLabel.textColor = UIColor.whiteColor;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"礼物收益X元已划入钱包";
        _desLabel.font = ADaptedFontSCBoldSize(23);
        _desLabel.textColor = RGBACOLOR(255, 255, 255, 0.92);
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.numberOfLines = 2;
    }
    return _desLabel;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [[UIButton alloc] init];
        _completeBtn.normalTitle = @"返回";
        _completeBtn.normalTitleColor = UIColor.blackColor;
        _completeBtn.titleLabel.font = ADaptedFontBoldSize(14);
        _completeBtn.backgroundColor = kGoldenRod;
        _completeBtn.layer.cornerRadius = 25.0;
        [_completeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

@end
