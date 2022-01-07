//
//  ZZAlertNotNetEmptyView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//
#import "ZZNetWorkCheckViewController.h"
#import "ZZNewHomeViewController.h"

#import "ZZAlertNotNetEmptyView.h"
@interface ZZAlertNotNetEmptyView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *closeButtion;
@property (nonatomic,strong) UIImageView *emptyImageView;
@property (nonatomic,strong) UILabel *titleDetailLab;
@property (nonatomic,strong) UIButton *emptyButtion;
@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,strong) UIView *bgView;
@end
@implementation ZZAlertNotNetEmptyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.39);;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        tap1.delegate = self;
        [self addGestureRecognizer:tap1];
    }
    return self;
}

- (void)alertShowViewController:(UIViewController *)showViewController {
    if (![[UIViewController currentDisplayViewController] isKindOfClass: [showViewController class]] || [[UIViewController currentDisplayViewController] isKindOfClass: [ZZNewHomeViewController class]]) {
        [self setUpUI];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
        self.viewController = showViewController;
        [self showView:showViewController];
    }
}

- (void)setUpUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.emptyImageView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.closeButtion];
    [self.bgView addSubview:self.titleDetailLab];
    [self.bgView addSubview:self.emptyButtion];
    [self setUpTheConstraints];
}

- (void)setUpTheConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32.5);
        make.right.offset(-32.5);
        make.centerY.equalTo(self);
        make.height.equalTo(self.bgView.mas_width).multipliedBy(272/310.0f);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(14);
    }];
    [self.closeButtion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.titleLab.mas_bottom).offset(17.5);
    }];
    [self.titleDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(17);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [self.emptyButtion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
        make.height.equalTo(@44);
        make.centerX.equalTo(self.bgView);
        make.width.equalTo(@(AdaptedWidth(162)));
    }];
 
}

- (UILabel *)titleDetailLab {
    if (!_titleDetailLab) {
        _titleDetailLab = [[UILabel alloc]init];
        _titleDetailLab.font = CustomFont(15);
        _titleDetailLab.textColor = kBlackColor;
        _titleDetailLab.textAlignment = NSTextAlignmentCenter;
        _titleDetailLab.text = @"无网络可用，请检查您的网络设置";
    }
    return _titleDetailLab;
}
- (UIButton *)closeButtion {
    if (!_closeButtion) {
        _closeButtion = [UIButton buttonWithType:UIButtonTypeCustom];
         [_closeButtion addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
        [_closeButtion setImage:[UIImage imageNamed:@"rectangle99"] forState:UIControlStateNormal];
    }
    return _closeButtion;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"无网络";
        _titleLab.font = ADaptedFontBoldSize(17);
        _titleLab.textColor = kBlackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]init];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        _emptyImageView.image = [UIImage imageNamed:@"imNetworkfailure.png"];
    }
    return _emptyImageView;
}
- (UIButton *)emptyButtion {
    if (!_emptyButtion) {
        _emptyButtion = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyButtion addTarget:self action:@selector(checkNetWorkClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emptyButtion setTitle:@"去检查" forState:UIControlStateNormal];
        [_emptyButtion setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_emptyButtion setBackgroundColor:RGBCOLOR(244, 203, 7)];
        _emptyButtion.layer.cornerRadius = 4;
    }
    return _emptyButtion;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6;
    }
    return _bgView;
}

- (void)checkNetWorkClick:(UIButton *)sender {
    [self dissMiss];
    ZZNetWorkCheckViewController *checkViewController = [[ZZNetWorkCheckViewController alloc]init];
    checkViewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:checkViewController animated:YES];
}

/**
 消失
 */
- (void)dissMiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

- (void)showView:(UIViewController *)viewController {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.hidden = NO;
    } completion:nil];
}
#pragma mark - 点击消失
- (void)click {
    [self dissMiss];
}
@end
