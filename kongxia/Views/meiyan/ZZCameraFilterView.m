//
//  ZZFilterView.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCameraFilterView.h"

@interface ZZCameraFilterView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) CameraFilterView *filterView;

@end

@implementation ZZCameraFilterView

+ (instancetype)show {
    ZZCameraFilterView *filterView = [[ZZCameraFilterView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:filterView];
    [filterView show];
    return filterView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        [self loadFiltersSettings];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ZZCameraFilterView is gone");
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        _filterView.top = SCREEN_HEIGHT - 240.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0;
        _filterView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_filterView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)closeAction {
    [self hide];
}

- (void)loadFiltersSettings {
    AgoraBeautyOptions *filterOption = [[ZZBeautyManager shared] loadFilterSetting];
    _filterView.whiteningSlider.value = filterOption.lighteningLevel;
    _filterView.mopiSlider.value = filterOption.smoothnessLevel;
    _filterView.rosySlider.value = filterOption.rednessLevel;
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:filterOptions:)]) {
        [self.delegate view:self filterOptions:filterOption];
    }
}

- (void)saveFiltersSettings:(FilterType)type value:(CGFloat)value {
    AgoraBeautyOptions *filterOption = [[ZZBeautyManager shared] safeFilterSettings:type value:value];
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:filterOptions:)]) {
        [self.delegate view:self filterOptions:filterOption];
    }
}

- (void)sliderValueChanged:(UISlider *)slider {
    [self saveFiltersSettings:(FilterType)slider.tag value:slider.value];
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.filterView];
    
    _bgView.frame = self.bounds;
    _filterView.frame = CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, 240.0);
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = ColorClear;
//        _bgView.alpha = 0.1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (CameraFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CameraFilterView alloc] init];
        [_filterView.whiteningSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_filterView.mopiSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_filterView.rosySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _filterView;
}

@end

@interface CameraFilterView ()

@end

@implementation CameraFilterView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.whiteningLabel];
    [self addSubview:self.whiteningwImageView];
    [self addSubview:self.mopiLabel];
    [self addSubview:self.mopiImageview];
    [self addSubview:self.rosyLabel];
    [self addSubview:self.rosyImageView];
    [self addSubview:self.whiteningSlider];
    [self addSubview:self.mopiSlider];
    [self addSubview:self.rosySlider];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(32.0);
    }];
    
    [_whiteningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(25.5);
        make.left.equalTo(self).offset(29.0);
    }];
    
    [_whiteningwImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_whiteningLabel);
        make.left.equalTo(_whiteningLabel.mas_right).offset(8.0);
    }];
    
    [_whiteningSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_whiteningLabel);
        make.left.equalTo(_whiteningwImageView.mas_right).offset(17.0);
        make.right.equalTo(self).offset(-29.0);
    }];
    
    [_mopiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteningLabel.mas_bottom).offset(29.5);
        make.left.equalTo(self).offset(29.0);
    }];
    
    [_mopiImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mopiLabel);
        make.left.equalTo(_mopiLabel.mas_right).offset(8.0);
    }];
    
    [_mopiSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mopiImageview);
        make.left.equalTo(_mopiImageview.mas_right).offset(17.0);
        make.right.equalTo(self).offset(-29.0);
    }];
    
    [_rosyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mopiLabel.mas_bottom).offset(29.5);
        make.left.equalTo(self).offset(29.0);
    }];
    
    [_rosyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rosyLabel);
        make.left.equalTo(_rosyLabel.mas_right).offset(8.0);
    }];
    
    [_rosySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rosyImageView);
        make.left.equalTo(_rosyImageView.mas_right).offset(17.0);
        make.right.equalTo(self).offset(-29.0);
    }];
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = ColorBlack;
        _bgView.alpha = 0.6;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"美颜";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.0];
        _titleLabel.textColor = ColorWhite;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)whiteningLabel {
    if (!_whiteningLabel) {
        _whiteningLabel = [[UILabel alloc] init];
        _whiteningLabel.text = @"美白";
        _whiteningLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.0];
        _whiteningLabel.textColor = ColorWhite;
    }
    return _whiteningLabel;
}

- (UILabel *)mopiLabel {
    if (!_mopiLabel) {
        _mopiLabel = [[UILabel alloc] init];
        _mopiLabel.text = @"磨皮";
        _mopiLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.0];
        _mopiLabel.textColor = ColorWhite;
    }
    return _mopiLabel;
}

- (UILabel *)rosyLabel {
    if (!_rosyLabel) {
        _rosyLabel = [[UILabel alloc] init];
        _rosyLabel.text = @"红润";
        _rosyLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.0];
        _rosyLabel.textColor = ColorWhite;
    }
    return _rosyLabel;
}

- (UIImageView *)whiteningwImageView {
    if (!_whiteningwImageView) {
        _whiteningwImageView = [[UIImageView alloc] init];
        _whiteningwImageView.image = [UIImage imageNamed: @"icMeibai"];
    }
    return _whiteningwImageView;
}

- (UIImageView *)mopiImageview {
    if (!_mopiImageview) {
        _mopiImageview = [[UIImageView alloc] init];
        _mopiImageview.image = [UIImage imageNamed: @"icMopi"];
    }
    return _mopiImageview;
}

- (UIImageView *)rosyImageView {
    if (!_rosyImageView) {
        _rosyImageView = [[UIImageView alloc] init];
        _rosyImageView.image = [UIImage imageNamed: @"icHongrun"];
    }
    return _rosyImageView;
}

- (ZZSlider *)whiteningSlider {
    if (!_whiteningSlider) {
        _whiteningSlider = [[ZZSlider alloc] init];
        _whiteningSlider.minimumValue = 0;
        _whiteningSlider.maximumValue = 1;
        _whiteningSlider.tag = 0;
    }
    return _whiteningSlider;
}

- (ZZSlider *)mopiSlider {
    if (!_mopiSlider) {
        _mopiSlider = [[ZZSlider alloc] init];
        _mopiSlider.minimumValue = 0;
        _mopiSlider.maximumValue = 1;
        _mopiSlider.tag = 1;
    }
    return _mopiSlider;
}

- (ZZSlider *)rosySlider {
    if (!_rosySlider) {
        _rosySlider = [[ZZSlider alloc] init];
        _rosySlider.minimumValue = 0;
        _rosySlider.maximumValue = 1;
        _rosySlider.tag = 2;
    }
    return _rosySlider;
}


@end
