//
//  ZZChatCheckPushView.m
//  zuwome
//
//  Created by angBiu on 2017/5/16.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatCheckPushView.h"

@implementation ZZChatCheckPushView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xEE7B77);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"打开推送 第一时间收取邀约信息";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIImageView *rightImgView = [[UIImageView alloc] init];
        rightImgView.image = [UIImage imageNamed:@"icon_chat_right_triangle"];
        [self addSubview:rightImgView];
        
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 10));
        }];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.text = @"立即开启";
        [self addSubview:rightLabel];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }

    return self;
}

- (void)btnClick
{
    if (UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
    }
    if (_tapSelf) {
        _tapSelf();
    }
    [self removeFromSuperview];
}

@end
