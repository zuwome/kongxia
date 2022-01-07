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
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 8) {
        [UIAlertView showWithTitle:NSLocalizedString(@"消息通知功能未开启", nil)
                           message:NSLocalizedString(@"您尚未开启新消息通知功能，无法及时获得邀约等重要消息。请在设置-通知中心中，找到“空虾”并打开通知来获取最完整的服务。",nil)
                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                 otherButtonTitles:nil
                          tapBlock:nil];
    } else {
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }
    if (_tapSelf) {
        _tapSelf();
    }
    [self removeFromSuperview];
}

@end
