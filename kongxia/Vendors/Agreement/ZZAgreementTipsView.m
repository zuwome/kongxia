//
//  ZZAgreementTipsView.m
//  zuwome
//
//  Created by YuTianLong on 2017/9/27.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZAgreementTipsView.h"

@interface ZZAgreementTipsView ()

@end

@implementation ZZAgreementTipsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZAgreementTipsView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZAgreementTipsView);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

commonInitImplementationSafe(ZZAgreementTipsView) {

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 10.0f;

    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"当您同意《空虾隐私条款》方可使用空虾";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *separator = [UIView new];
    separator.backgroundColor = RGBCOLOR(227, 227, 227);

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"知道了" forState:UIControlStateNormal];
    [doneButton setTitleColor:RGBCOLOR(33, 158, 252) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];

    [backgroundView addSubview:tipsLabel];
    [backgroundView addSubview:separator];
    [backgroundView addSubview:doneButton];
    [self addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@35);
        make.trailing.equalTo(@(-35));
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@125);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.top.equalTo(@0);
        make.height.equalTo(@80);
    }];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom);
        make.leading.trailing.bottom.equalTo(@0);
    }];
}

#pragma mark - Private methods

- (IBAction)doneClick:(id)sender {
    BLOCK_SAFE_CALLS(self.doneBlock);
}

- (void)show:(BOOL)animated {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    window.alpha = 0.5;
    [window addSubview:self];
    animated ?
    [self shakeToShow:self] :
    nil;
}

- (void)dismiss {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.alpha = 1;
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self layoutSubviews];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)shakeToShow:(UIView *)aView{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
