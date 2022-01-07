//
//  ZZWXGuideView.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZWXGuideView.h"

@implementation ZZWXGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.52);
        [self addSubview:coverView];
        
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 4;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(254*scale);
        }];
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = kBGColor;
        [bgView addSubview:grayView];
        
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(5);
            make.right.mas_equalTo(bgView.mas_right).offset(-5);
            make.top.mas_equalTo(bgView.mas_top).offset(5);
            make.height.mas_equalTo(@126);
        }];
        
        UIImageView *cancelImgView = [[UIImageView alloc] init];
        cancelImgView.image = [UIImage imageNamed:@"icon_cancel"];
        [bgView addSubview:cancelImgView];
        
        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top).offset(12);
            make.right.mas_equalTo(bgView.mas_right).offset(-12);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        UIImageView *packetImgView = [[UIImageView alloc] init];
        packetImgView.image = [UIImage imageNamed:@"icon_wx_guide_packet"];
        [bgView addSubview:packetImgView];
        
        [packetImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(grayView.mas_centerY);
        }];
        
        UIView *titleView = [[UIView alloc] init];
        [bgView addSubview:titleView];
        
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.mas_equalTo(grayView.mas_bottom).offset(20);
        }];
        
        UIImageView *wxImgView = [[UIImageView alloc] init];
        wxImgView.image = [UIImage imageNamed:@"icon_wx_wx_p"];
        [titleView addSubview:wxImgView];
        
        [wxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleView.mas_left);
            make.centerY.mas_equalTo(titleView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(23, 19));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.text = @"填写微信 获得打赏";
        [titleView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wxImgView.mas_right).offset(7);
            make.right.mas_equalTo(titleView.mas_right);
            make.top.bottom.mas_equalTo(titleView);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = kGrayContentColor;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.text = @"填写自己的真实微信号，每次被别人查看都能获得一次收益哦，快来参与吧";
        contentLabel.numberOfLines = 0;
        [bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.top.mas_equalTo(titleView.mas_bottom).offset(15);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-15);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)tapSelf
{
    [ZZKeyValueStore saveValue:@"firstMyWxGuide" key:[ZZStoreKey sharedInstance].firstMyWxGuide];
    [self removeFromSuperview];
}

@end
