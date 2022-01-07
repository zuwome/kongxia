//
//  ZZOpenSanChatGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOpenNotificationGuide.h"
#import "UILabel+Extension.h"

@interface ZZOpenNotificationGuide()

@property(nonatomic,strong) UIView  *showBgView;


@property(nonatomic,strong) UILabel  *showOpenLable;

@property(nonatomic,strong) UIButton *closeButton;

@property(nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIColor *showTitleColor;
@property(nonatomic,strong) UILabel *titleLab;
/**
 立即开启
 */
@property(nonatomic,strong) UIButton *openButton;
@property(nonatomic,assign) CGFloat heightProportion;//弹窗的高度比例

@end
@implementation ZZOpenNotificationGuide

+ (void)showShanChatPromptWhenUserOpenSanChatSwitch:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName {
    
   if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
       [[[ZZOpenNotificationGuide alloc]init] showShanChatPromptWhenUserOpenSanChatSwitch:showViewController heightProportion:heightProportion  showMessageTitle:showMessageTitle showImageName:showImageName showTitleColor:nil];
   }
}


/**
 通知用户开启系统通知
 注*只是弹出一次
 @param showViewController 要展示的弹窗的根视图 ,nil 默认为根
 @param heightProportion 当前背景的高度
 @param showMessageTitle 要展示的标题
 @param showImageName 要展示的图片
 注* 内部做了用户是否已经开启通知的判断了
 */
+ (void)showShanChatPromptWhenUserFirstIntoViewController:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName {
    NSString *stringKey = [NSString stringWithFormat:@"FirstInto_OpenNotification_%@",showImageName];
     NSString *string = [ZZKeyValueStore getValueWithKey:stringKey];
    if (!string) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            [ZZKeyValueStore saveValue:@"First" key:stringKey];
            [[[ZZOpenNotificationGuide alloc]init] showShanChatPromptWhenUserOpenSanChatSwitch:showViewController heightProportion:heightProportion  showMessageTitle:showMessageTitle showImageName:showImageName showTitleColor:nil];
        }
    }
}

- (void)showShanChatPromptWhenUserOpenSanChatSwitch:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName showTitleColor:(UIColor *)titleColor  {
    _heightProportion =  heightProportion;
    _showTitleColor = titleColor;
    [self showView:showViewController];
    [self setUI];
    [self configurationParametersShowMessageTitle:showMessageTitle showImageName:showImageName];
}
/**
 开启通知出租界面
 
 */
+ (void)openNotificationWhenOpenRentSuccess:(UIViewController *)showViewController heightProportion:(CGFloat)heightProportion showMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName  showTitleColor:(UIColor *)titleColor {
    
    [[[ZZOpenNotificationGuide alloc]init] showShanChatPromptWhenUserOpenSanChatSwitch:showViewController heightProportion:heightProportion  showMessageTitle:showMessageTitle showImageName:showImageName showTitleColor:titleColor];

}

- (void)setUI{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:self.showBgView];
    
    [self.showBgView addSubview:self.closeButton];
    [self.showBgView addSubview:self.imageView];
    [self.showBgView addSubview:self.showOpenLable];
    [self.showBgView addSubview:self.titleLab];
    [self.showBgView addSubview:self.openButton];
    [self setUpTheConstraints];
}
- (void)setUpTheConstraints {
    
    [self.showBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width).multipliedBy(0.82);
        make.height.equalTo(self.mas_height).multipliedBy(self.heightProportion);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.showOpenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.showBgView.mas_centerY).multipliedBy(0.2);
        make.left.offset(50);
        make.right.offset(-50);

    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.lessThanOrEqualTo(self.showOpenLable.mas_bottom).offset(13);
        make.centerX.equalTo(self.showBgView.mas_centerX);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.lessThanOrEqualTo(@55);
        make.top.equalTo(self.imageView.mas_bottom).offset(3);
        make.bottom.equalTo (self.openButton.mas_top).offset(-3);
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.width.mas_equalTo(AdaptedWidth(163));
        make.height.mas_equalTo(@44);
        make.centerX.equalTo(self.showBgView.mas_centerX);
    }];
    
}
- (void)configurationParametersShowMessageTitle:(NSString *)showMessageTitle showImageName:(NSString *)showImageName  {
    if (showImageName) {
        self.imageView.image = [UIImage imageNamed:showImageName];
    }
    
    self.titleLab.text = showMessageTitle;
    if (self.showTitleColor) {
      self.titleLab.textColor = self.showTitleColor;
    }
    [UILabel changeLineSpaceForLabel:self.titleLab WithSpace:5];
}
#pragma mark - 懒加载

- (UIView *)showBgView {
    if (!_showBgView) {
        _showBgView = [[UIView alloc]init];
        _showBgView.layer.cornerRadius = 6;
        _showBgView.clipsToBounds = YES;
        _showBgView.backgroundColor = kBGColor;
    }
    return _showBgView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"open_Notification_icClose"] forState:UIControlStateNormal];
    }
    return _closeButton;
}
- (UILabel *)showOpenLable {
    if (!_showOpenLable) {
        _showOpenLable = [[UILabel alloc]init];
        _showOpenLable.textColor = kBlackColor;
        _showOpenLable.text = @"开启通知";
        _showOpenLable.textAlignment = NSTextAlignmentCenter;
        _showOpenLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    }
    return _showOpenLable;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = kBlackColor;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _openButton.layer.cornerRadius = 22;
        _openButton.clipsToBounds = YES;
        [_openButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_openButton setTitle:@"立即开启" forState:UIControlStateNormal];
        [_openButton setBackgroundColor:kYellowColor];
        _openButton.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    return _openButton;
}

#pragma mark -  按钮的点击事件
- (void)closeButtonClick {
    [self dissMiss];
}

- (void)openButtonClick {
    
    [self dissMiss];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


@end
