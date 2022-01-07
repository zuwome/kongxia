//
//  ZZCompleteIntegralTopView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZCompleteIntegralTopView.h"
@interface ZZCompleteIntegralTopView()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *lookDetailButton;
@property (nonatomic,strong) UIVisualEffectView *effectview;
@end
@implementation ZZCompleteIntegralTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.effectview];
        [self addSubview:self.lookDetailButton];
        [self addSubview:self.titleLab];
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectview.frame = frame;
        _effectview.layer.masksToBounds = YES;
        _effectview.layer.cornerRadius = 7.0f;
        _effectview.alpha = 0.6;
        self.layer.cornerRadius = 7;
        
    }
    return self;
}


- (void)setTaskString:(NSString *)taskString {
    _taskString = taskString;
    self.titleLab.text = taskString;
}
#pragma mark - 约束

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(23);
        make.centerY.equalTo(self);
        make.right.equalTo(self.imageView.mas_left).offset(-3.5);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    
        make.size.mas_equalTo(CGSizeMake(16.5, 15));
    }];
    

    
    [self.lookDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-19);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 25.5));
    }];
    
}



#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = ADaptedFontMediumSize(15);
    }
    return _titleLab;
}

- (UIButton *)lookDetailButton {
    if (!_lookDetailButton) {
        _lookDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookDetailButton.backgroundColor = RGBACOLOR(255, 255, 255, 0.75);
        [_lookDetailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_lookDetailButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _lookDetailButton.layer.cornerRadius = 4;
        _lookDetailButton.titleLabel.font = CustomFont(14);
        [_lookDetailButton addTarget:self action:@selector(lookDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookDetailButton;
}

- (void)lookDetailButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    [self dissMiss];
    if (_lookDetail) {
        _lookDetail();
    }
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView .image = [UIImage imageNamed:@"icJifenCard"];
    }
    return _imageView;
}
/**
 消失
 */
- (void)dissMiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
