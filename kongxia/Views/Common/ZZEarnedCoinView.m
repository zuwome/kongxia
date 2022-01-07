//
//  ZZEarnedCoinView.m
//  zuwome
//
//  Created by qiming xiao on 2019/6/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZEarnedCoinView.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZEarnedCoinView ()

@property (nonatomic, strong) FLAnimatedImageView *earnedCoineGifImageView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconBgImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *earnedLabel;

@property (nonatomic, assign) CGFloat iconWidth;

@property (nonatomic, assign) CGFloat totalWidth;

@property (nonatomic, assign) CGFloat textWidth;

@property (nonatomic, copy) NSString *income;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, assign) BOOL isFirstTime;

@end

@implementation ZZEarnedCoinView

+ (ZZEarnedCoinView *)createViewWithTotalIncome:(NSString *)income {
    CGFloat earnedMoneyWidth = [NSString findWidthForText:[NSString stringWithFormat:@"今日私信收益:%@元", income] havingWidth:SCREEN_WIDTH andFont:[UIFont systemFontOfSize:10]];
    
    ZZEarnedCoinView *aview = [[ZZEarnedCoinView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 32) textWidth:earnedMoneyWidth income:income];
    aview.backgroundColor = UIColor.redColor;
    return aview;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isFirstTime = YES;
        _isAnimating = NO;
        _iconWidth = 22;
        [self createViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textWidth:(CGFloat)textWidth income:(NSString *)income {
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimating = NO;
        _income = income;
        _textWidth = textWidth;
        _iconWidth = 22;
        _totalWidth = _textWidth + _iconWidth + 7 + 10;
        [self layout];
        [self animationShow];
    }
    return self;
}

#pragma mark - public Method
- (void)stopAnimation {
    if (!_isAnimating && _earnedCoineGifImageView.isAnimating) {
        [_earnedCoineGifImageView stopAnimating];
    }
}

- (void)startAnimation {
    if (!_isAnimating && !_earnedCoineGifImageView.isAnimating) {
        [_earnedCoineGifImageView startAnimating];
    }
}

#pragma mark - private method
- (void)earnedIncom:(NSString *)income {
    _income = income;
    _earnedLabel.text = [NSString stringWithFormat:@"今日私信收益:%@元", _income];
    
    if (_isAnimating) {
        return;
    }
    
    [self layout];
    
    [self animationShow];
}

- (void)showImmediately {
    if (_isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    _earnedCoineGifImageView.alpha = 0.0;
    [_earnedCoineGifImageView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgImageView.alpha = 1.0;
        self.iconBgImageView.alpha = 0;
        CGRect frame = _contentView.frame;
        frame.origin.x = self.width - _totalWidth;
        frame.size.width =  _totalWidth;
        _contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self animationHide];
    }];
}

- (void)animationShow {
    if (_isAnimating) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isAnimating = YES;
        _earnedCoineGifImageView.alpha = 0.0;
        [_earnedCoineGifImageView stopAnimating];
        [UIView animateWithDuration:0.5 animations:^{
            self.bgImageView.alpha = 1.0;
            self.iconBgImageView.alpha = 0;
            CGRect frame = _contentView.frame;
            frame.origin.x = self.width - _totalWidth;
            frame.size.width =  _totalWidth;
            _contentView.frame = frame;
        } completion:^(BOOL finished) {
            [self animationHide];
        }];
    });
}

- (void)animationHide {
    CGFloat finalWidth = 32;
    CGFloat x = self.width - 32;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _contentView.frame;
            frame.origin.x = x;
            frame.size.width = finalWidth;
            _contentView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.bgImageView.alpha = 0.0;
                self.iconBgImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                _isAnimating = NO;
                _earnedCoineGifImageView.alpha = 1.0;
                [_earnedCoineGifImageView startAnimating];
            }];
        });
    });
}

#pragma mark - Layout
- (void)createViews {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 12.0;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.iconBgImageView];
    [self.contentView addSubview:self.iconImageView];
    [self.bgImageView addSubview:self.earnedLabel];
    [self.contentView addSubview:self.earnedCoineGifImageView];
}

- (void)layout {
//    self.backgroundColor = UIColor.greenColor;
    
    _textWidth = [NSString findWidthForText:_earnedLabel.text havingWidth:self.width andFont:[UIFont systemFontOfSize:10]];
    _totalWidth = _textWidth + _iconWidth + 7 + 10;
    
    
    self.contentView.frame = CGRectMake(self.width - 32, 0.0, 32, self.height);
    _bgImageView.frame = CGRectMake(0.0, 0.0, _totalWidth, self.contentView.height);
    _iconBgImageView.frame = CGRectMake(0.0, 0.0, 32, 32);
    _iconImageView.frame = CGRectMake(5.0, 4, 22, 22);
    _earnedLabel.frame = CGRectMake(_iconImageView.right + 4, _iconImageView.top + 5, _textWidth, _earnedLabel.font.lineHeight);
    _earnedCoineGifImageView.frame = CGRectMake(-2.0, -1.5, 34, 35);
}

#pragma mark - getters and setters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [[UIImage imageNamed:@"rectangle"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3) resizingMode:UIImageResizingModeStretch];
        _bgImageView.alpha = 0.0;
    }
    return _bgImageView;
}


- (UIImageView *)iconBgImageView {
    if (!_iconBgImageView) {
        _iconBgImageView = [[UIImageView alloc] init];
        _iconBgImageView.image = [UIImage imageNamed:@"rectangle-1"];
        _iconBgImageView.alpha = 1.0;
//        _iconBgImageView.backgroundColor = UIColor.redColor;
    }
    return _iconBgImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icQianbi"];
    }
    return _iconImageView;
}

- (UILabel *)earnedLabel {
    if (!_earnedLabel) {
        _earnedLabel = [[UILabel alloc] init];
        _earnedLabel.textColor = RGBCOLOR(63, 58, 58);
        _earnedLabel.textAlignment = NSTextAlignmentCenter;
        _earnedLabel.font = [UIFont systemFontOfSize:10];
        _earnedLabel.text = [NSString stringWithFormat:@"今日私信收益：%@元", _income];
    }
    return _earnedLabel;
}

- (FLAnimatedImageView *)earnedCoineGifImageView {
    if (!_earnedCoineGifImageView) {
        _earnedCoineGifImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"earnCoins2" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _earnedCoineGifImageView.animatedImage = image;
        _earnedCoineGifImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImmediately)];
        [_earnedCoineGifImageView addGestureRecognizer:tap];
    }
    return _earnedCoineGifImageView;
}

@end
