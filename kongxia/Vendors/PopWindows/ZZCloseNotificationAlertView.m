//
//  ZZCloseNotificationAlertView.m
//  zuwome
//
//  Created by YuTianLong on 2017/11/23.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCloseNotificationAlertView.h"

@interface ZZCloseNotificationAlertView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZCloseNotificationAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.75);
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)doneClick {
    BLOCK_SAFE_CALLS(self.doneBlock);
    [self removeFromSuperview];
}

- (void)cancelBtnClick {
    BLOCK_SAFE_CALLS(self.cancelBlock);
    [self removeFromSuperview];
}

#pragma mark -

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(286 * scale);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"关闭推送";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kBlackColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(15);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
        
        
        CGFloat imageScale = 226.0 / 204.0;
        UIImageView *centerImgView = [[UIImageView alloc] init];
        centerImgView.contentMode = UIViewContentModeScaleAspectFill;
        centerImgView.image = [UIImage imageNamed:@"bgPopupReportClosed"];
        [_bgView addSubview:centerImgView];
        
        [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.width.equalTo(@(286 * scale * 0.35));
            make.height.equalTo(@(286 * scale * 0.35 / imageScale));
        }];
        
//        UILabel *contentLabel = [[UILabel alloc] init];
//        contentLabel.textAlignment = NSTextAlignmentCenter;
//        contentLabel.textColor = kBlackColor;
//        contentLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
//        contentLabel.text = @"恭喜你可以抢任务了";
//        contentLabel.numberOfLines = 0;
//        [_bgView addSubview:contentLabel];
//
//        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_bgView.mas_left).offset(20);
//            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
//            make.top.mas_equalTo(centerImgView.mas_bottom).offset(15);
//        }];
        
        UILabel *tipsLabel = [UILabel new];
        tipsLabel.text = @"关闭后将无法收到抢任务通知，会错过很多收益";
        tipsLabel.textColor = kBlackColor;
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.numberOfLines = 0;
        [_bgView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.mas_equalTo(centerImgView.mas_bottom).offset(15);
        }];
        
        UIButton *sureBtn = [[UIButton alloc] init];
        [sureBtn setTitle:@"取消" forState:UIControlStateNormal];
        [sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.backgroundColor = kYellowColor;
        [sureBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 4.0f;
        [_bgView addSubview:sureBtn];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-5);
            make.top.mas_equalTo(tipsLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        cancelBtn.backgroundColor = RGBCOLOR(216, 216, 216);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.cornerRadius = 4.0f;
        [cancelBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.top.mas_equalTo(sureBtn.mas_top);
            make.left.mas_equalTo(_bgView.mas_centerX).offset(5);
            make.bottom.mas_equalTo(sureBtn.mas_bottom);
            make.height.mas_equalTo(44);
        }];
    }
    return _bgView;
}

@end
