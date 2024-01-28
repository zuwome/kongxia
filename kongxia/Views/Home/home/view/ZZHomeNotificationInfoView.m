//
//  ZZHomeNotificationInfoView.m
//  zuwome
//
//  Created by angBiu on 2017/3/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZHomeNotificationInfoView.h"

@implementation ZZHomeNotificationInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF9F3D0);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXCOLOR(0xDDA200);
        
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"打开通知，不错过任何消息并获得首页推荐机会";
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(15);
        }];
        
        UIButton *settingBtn = [[UIButton alloc] init];
        [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn setTitle:@"打开" forState:UIControlStateNormal];
        [settingBtn setTitleColor:HEXCOLOR(0xDDA200) forState:UIControlStateNormal];
        settingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:settingBtn];
        
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(@50);
        }];
        
        UIButton *ignoreBtn = [[UIButton alloc] init];
        [ignoreBtn addTarget:self action:@selector(ignoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [ignoreBtn setTitle:@"忽略" forState:UIControlStateNormal];
        [ignoreBtn setTitleColor:HEXCOLOR(0xDDA200) forState:UIControlStateNormal];
        ignoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:ignoreBtn];
        
        [ignoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(settingBtn.mas_left);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(@50);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.userInteractionEnabled = NO;
        lineView.backgroundColor = HEXCOLOR(0xDDA200);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ignoreBtn.mas_right);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(@1);
        }];
    }
    
    return self;
}

- (void)ignoreBtnClick
{
    if (_callBack) {
        _callBack();
    }
}

- (void)settingBtnClick
{
    [self ignoreBtnClick];
    if (UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
    }
}

@end
