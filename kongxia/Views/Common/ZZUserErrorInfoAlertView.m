//
//  ZZUserErrorInfoAlertView.m
//  zuwome
//
//  Created by angBiu on 2017/6/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserErrorInfoAlertView.h"

#import "ZZUserEditViewController.h"
#import "ZZEditViewController.h"

@interface ZZUserErrorInfoAlertView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZUserErrorInfoAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.5);
        [self addSubview:coverView];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user
{
    _user = user;
    NSRange range = [[ZZUserHelper shareInstance].loginer.avatar rangeOfString:@"person-flat.png"];
    if (isNullString(user.avatar) || range.location != NSNotFound ) {
        [self createErrorAvatarView];
    } else if (isNullString(user.nickname)) {
        [self createErrorNicknameView];
    }
    
    UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navCtl = [tabs selectedViewController];
    UIViewController *ctl = navCtl.viewControllers[0];
    [ctl.view.window addSubview:self];
}

- (void)createErrorNicknameView
{
    CGFloat scale = SCREEN_WIDTH/375.0;
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"icon_errorinfo_top"];
    [self.bgView addSubview:topImgView];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(scale*56.5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = HEXCOLOR(0xE63138);
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.text = @"用户名不可用";
    [topImgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(topImgView);
    }];
    
//    UIButton *cancelBtn = [[UIButton alloc] init];
//    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:cancelBtn];
//    
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.mas_equalTo(self.bgView);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
//    
//    UIImageView *cancelImgView = [[UIImageView alloc] init];
//    cancelImgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
//    cancelImgView.userInteractionEnabled = NO;
//    [cancelBtn addSubview:cancelImgView];
//    
//    [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(cancelBtn.mas_top).offset(15);
//        make.right.mas_equalTo(cancelBtn.mas_right).offset(-15);
//        make.size.mas_equalTo(CGSizeMake(16, 16));
//    }];
    
    UIView *nameBgView = [[UIView alloc] init];
    [self.bgView addSubview:nameBgView];
    
    [nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImgView.mas_bottom).offset(34);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = kBlackTextColor;
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.text = _user.nickname_unpass;
    [nameBgView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(nameBgView);
    }];
    
    UIImageView *errorImgView = [[UIImageView alloc] init];
    errorImgView.image = [UIImage imageNamed:@"icon_user_photoerror"];
    [nameBgView addSubview:errorImgView];
    
    [errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(5);
        make.right.centerY.mas_equalTo(nameBgView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = HEXCOLOR(0x9B9B9B);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.text = _user.nickname_unpass_reason;
    [self.bgView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(25);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-25);
        make.top.mas_equalTo(nameBgView.mas_bottom).offset(20);
    }];
    
    UIButton *changeBtn = [[UIButton alloc] init];
    changeBtn.backgroundColor = kYellowColor;
    changeBtn.layer.cornerRadius = 25;
    [changeBtn setTitle:@"更换用户名" forState:UIControlStateNormal];
    [changeBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [changeBtn addTarget:self action:@selector(nickChangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:changeBtn];
    
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(25);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-25);
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(@50);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-15);
    }];
    
    changeBtn.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
    changeBtn.layer.shadowOffset = CGSizeMake(0, 1);
    changeBtn.layer.shadowOpacity = 0.9;
    changeBtn.layer.shadowRadius = 1;
}

- (void)createErrorAvatarView
{
//    UIButton *cancelBtn = [[UIButton alloc] init];
//    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:cancelBtn];
//    
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.mas_equalTo(self.bgView);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
//    
//    UIImageView *cancelImgView = [[UIImageView alloc] init];
//    cancelImgView.image = [UIImage imageNamed:@"icon_home_refresh_cancel"];
//    cancelImgView.userInteractionEnabled = NO;
//    [cancelBtn addSubview:cancelImgView];
//    
//    [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(cancelBtn.mas_top).offset(15);
//        make.right.mas_equalTo(cancelBtn.mas_right).offset(-15);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.clipsToBounds = YES;
    headImgView.layer.cornerRadius = 6;
    headImgView.backgroundColor = kGrayTextColor;
    [self.bgView addSubview:headImgView];
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(118, 118));
    }];
    
    [headImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar_unpass]];
    
    UIView *whiteCycleView = [[UIView alloc] init];
    whiteCycleView.layer.cornerRadius = 20;
    whiteCycleView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:whiteCycleView];
    
    [whiteCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headImgView.mas_right).offset(12);
        make.bottom.mas_equalTo(headImgView.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIImageView *errorImgView = [[UIImageView alloc] init];
    errorImgView.image = [UIImage imageNamed:@"icon_user_photoerror"];
    [self.bgView addSubview:errorImgView];
    
    [errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(whiteCycleView);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HEXCOLOR(0xE63138);
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.text = @"请更换头像";
    [self.bgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(headImgView.mas_bottom).offset(18);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = HEXCOLOR(0x9B9B9B);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.text = _user.avatar_unpass_reason;
    [self.bgView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(20);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
    }];
    
    UIButton *changeBtn = [[UIButton alloc] init];
    changeBtn.backgroundColor = kYellowColor;
    changeBtn.layer.cornerRadius = 25;
    [changeBtn setTitle:@"更换头像" forState:UIControlStateNormal];
    [changeBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [changeBtn addTarget:self action:@selector(imageChangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:changeBtn];
    
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(25);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-25);
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(@50);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-15);
    }];
    
    changeBtn.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
    changeBtn.layer.shadowOffset = CGSizeMake(0, 1);
    changeBtn.layer.shadowOpacity = 0.9;
    changeBtn.layer.shadowRadius = 1;
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)imageChangeBtnClick
{
    [self cancelBtnClick];
    UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navCtl = [tabs selectedViewController];
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [navCtl pushViewController:controller animated:YES];
}

- (void)nickChangeBtnClick
{
    [self cancelBtnClick];
    UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navCtl = [tabs selectedViewController];
    ZZEditViewController *controller = [[ZZEditViewController alloc] init];
    controller.editType = EditTypeName;
    controller.updateName = YES;
    controller.hidesBottomBarWhenPushed = YES;
    [navCtl pushViewController:controller animated:YES];
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 6;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(scale*294);
        }];
    }
    return _bgView;
}

@end
