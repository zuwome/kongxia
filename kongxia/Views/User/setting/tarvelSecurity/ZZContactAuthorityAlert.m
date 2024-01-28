//
//  ZZContactAuthorityAlert.m
//  zuwome
//
//  Created by angBiu on 2017/8/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZContactAuthorityAlert.h"

@interface ZZContactAuthorityAlert ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZContactAuthorityAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.7);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)closeBtnClick
{
    [self removeFromSuperview];
}

- (void)gotoSetting
{
    [self removeFromSuperview];
    if (UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        if (scale>1) {
            scale = 1;
        }
        
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(317*scale);
        }];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = NO;
        imgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
        [closeBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(closeBtn.mas_top).offset(15);
            make.right.mas_equalTo(closeBtn.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        UIImageView *centerImgView = [[UIImageView alloc] init];
        centerImgView.image = [UIImage imageNamed:@"icon_user_contact_alert"];
        [_bgView addSubview:centerImgView];
        
        [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(34);
            make.size.mas_equalTo(CGSizeMake(100, 87));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.attributedText = [ZZUtils setLineSpace:@"您未打开通讯录权限\n请前往“设置”打开通讯录权限" space:5 fontSize:15 color:kBlackTextColor];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bgView);
            make.top.mas_equalTo(centerImgView.mas_bottom).offset(25);
        }];
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.layer.cornerRadius = 3;
        leftBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        [_bgView addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-6);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setTitle:@"前往" forState:UIControlStateNormal];
        [rightBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.layer.cornerRadius = 3;
        rightBtn.backgroundColor = kYellowColor;
        [_bgView addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.mas_equalTo(leftBtn.mas_top);
            make.left.mas_equalTo(_bgView.mas_centerX).offset(6);
            make.height.mas_equalTo(@44);
        }];
    }
    return _bgView;
}

@end
