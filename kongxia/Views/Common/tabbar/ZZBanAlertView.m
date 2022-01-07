//
//  ZZBanAlertView.m
//  zuwome
//
//  Created by angBiu on 2017/4/19.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZBanAlertView.h"

#import "ZZLinkWebViewController.h"

@implementation ZZBanAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:frame];
        bgBtn.backgroundColor = kBlackTextColor;
        bgBtn.alpha = 0.83;
        [self addSubview:bgBtn];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 4;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(@265);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_ban_info"];
        [bgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.mas_equalTo(bgView.mas_top).offset(34);
            make.size.mas_equalTo(CGSizeMake(148, 106));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(25);
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"查看详情并申诉" forState:UIControlStateNormal];
        [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 22;
        btn.backgroundColor = kYellowColor;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(20);
            make.right.mas_equalTo(bgView.mas_right).offset(-20);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(18);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-20);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(60, 50));
        }];
        
        UIImageView *cancelImgView = [[UIImageView alloc] init];
        cancelImgView.image = [UIImage imageNamed:@"icon_cancel"];
        cancelImgView.userInteractionEnabled = NO;
        [cancelBtn addSubview:cancelImgView];
        
        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cancelBtn.mas_top).offset(15);
            make.right.mas_equalTo(cancelBtn.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    
    return self;
}

- (void)btnClick
{
    [self cancelBtnClick];
    UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navCtl = [tabs selectedViewController];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = [NSString stringWithFormat:@"%@/api/user/ban/page",kBase_URL];
    controller.isHideBar = NO;
    controller.hidesBottomBarWhenPushed = YES;
    controller.navigationItem.title = @"封禁申诉";
    [navCtl pushViewController:controller animated:YES];
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

@end
