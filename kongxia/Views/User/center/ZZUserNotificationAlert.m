//
//  ZZUserNotificationAlert.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZUserNotificationAlert.h"

@interface ZZUserNotificationAlert ()

@property (nonatomic) UIView *bgView;
@property (nonatomic) UIView *containView;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIImageView *icon;
@property (nonatomic) UILabel *subTitle;
@property (nonatomic) UIButton *sureBtn;
@property (nonatomic) UIButton *closeBtn;

@end

@implementation ZZUserNotificationAlert

+ (void)showAlert {
    ZZUserNotificationAlert *alert = [[ZZUserNotificationAlert alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:alert];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{} completion:^(BOOL finished) {}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [self addSubview:_bgView];
    
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = [UIColor whiteColor];
    _containView.layer.cornerRadius = 6;
    _containView.clipsToBounds = YES;
    [self addSubview:_containView];
    
    _title = [[UILabel alloc] init];
    _title.text = @"开启通知";
    _title.textColor = kBlackColor;
    _title.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightSemibold)];
    [_containView addSubview:_title];
    
    _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgNoticePopup"]];
    [_containView addSubview:_icon];
    
    _subTitle = [[UILabel alloc] init];
    _subTitle.numberOfLines = 0;
    _subTitle.textAlignment = NSTextAlignmentCenter;
    _subTitle.text = @"打开系统通知，才能获取首页推荐机会，及时处理邀约信息哦";
    _subTitle.textColor = kBlackColor;
    _subTitle.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightSemibold)];
    [_containView addSubview:_subTitle];
    
    _sureBtn = [[UIButton alloc] init];
    [_sureBtn setTitle:@"立即开启" forState:(UIControlStateNormal)];
    [_sureBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
    [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_sureBtn setBackgroundColor:kGoldenRod];
    _sureBtn.layer.cornerRadius = 22;
    _sureBtn.clipsToBounds = YES;
    [_sureBtn addTarget:self action:@selector(openNotification) forControlEvents:(UIControlEventTouchUpInside)];
    [_containView addSubview:_sureBtn];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:[UIImage imageNamed:@"open_Notification_icClose"] forState:(UIControlStateNormal)];
    [_closeBtn addTarget:self action:@selector(closeAlert) forControlEvents:(UIControlEventTouchUpInside)];
    [_containView addSubview:_closeBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containView).offset(20);
        make.centerX.equalTo(_containView);
        make.height.equalTo(@25);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_title.mas_bottom).offset(15);
        make.centerX.equalTo(_containView);
        make.size.mas_equalTo(CGSizeMake(180, 116));
    }];
    
    [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_icon.mas_bottom).offset(10);
        make.centerX.equalTo(_containView);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_containView);
        make.size.mas_equalTo(CGSizeMake(160, 44));
        make.top.equalTo(_subTitle.mas_bottom).offset(15);
        make.bottom.equalTo(@-15);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)closeAlert {
    [self removeFromSuperview];
}

- (void)openNotification {
    if (UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
    }
    [self closeAlert];
}

@end
