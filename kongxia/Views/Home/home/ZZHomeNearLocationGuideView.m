//
//  ZZHomeNearLocationGuideView.m
//  zuwome
//
//  Created by angBiu on 2017/8/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZHomeNearLocationGuideView.h"

@interface ZZHomeNearLocationGuideView ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *settingBtn;

@end

@implementation ZZHomeNearLocationGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_near_location"];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(80);
            make.size.mas_equalTo(CGSizeMake(167.5, 110.5));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"请在设置中打开位置权限";
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(20);
        }];
        
        _settingBtn = [[UIButton alloc] init];
        [_settingBtn setTitle:@"点击前往" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.backgroundColor = kYellowColor;
        _settingBtn.layer.cornerRadius = 3;
        [self addSubview:_settingBtn];
        
        [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(22);
            make.size.mas_equalTo(CGSizeMake(104, 44));
        }];
    }
    
    return self;
}

- (void)settingBtnClick
{
    if ([[[UIDevice currentDevice] systemVersion] integerValue]< 8) {
        [UIAlertView showWithTitle:NSLocalizedString(@"定位服务未开启", nil)
                           message:NSLocalizedString(@"您尚未开启定位功能，无法准确获取定位消息。请在“设置-隐私-定位服务中”，找到“空虾”并打开来获取最完整的服务",nil)
                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                 otherButtonTitles:nil
                          tapBlock:nil];
    } else {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

@end
