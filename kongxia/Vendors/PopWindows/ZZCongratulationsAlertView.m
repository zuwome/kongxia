//
//  ZZCongratulationsAlertView.m
//  zuwome
//
//  Created by YuTianLong on 2017/11/23.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCongratulationsAlertView.h"

@interface ZZCongratulationsAlertView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZCongratulationsAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.75);
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)cancelBtnClick {
    
    BLOCK_SAFE_CALLS(self.doneBlock);
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
        
        CGFloat imageScale = 294.0 / 163.0;
        UIImageView *centerImgView = [[UIImageView alloc] init];
        centerImgView.contentMode = UIViewContentModeScaleAspectFill;
        centerImgView.image = [UIImage imageNamed:@"icon_bgCongratulationGrabMission"];
        [_bgView addSubview:centerImgView];
        
        [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(0);
            make.left.mas_equalTo(_bgView.mas_left).offset(-1);
            make.right.mas_equalTo(_bgView.mas_right).offset(1);
            make.height.equalTo(@(286 * scale / imageScale));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = kBlackColor;
        contentLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
        contentLabel.text = @"恭喜你可以抢任务了";
        contentLabel.numberOfLines = 0;
        [_bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.mas_equalTo(centerImgView.mas_bottom).offset(15);
        }];
        
        UILabel *tipsLabel = [UILabel new];
        tipsLabel.text = @"您提交的视频正在审核，我们将在2小时内给您反馈";
        tipsLabel.textColor = kBlackColor;
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.numberOfLines = 0;
        [_bgView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
        }];
        
        
        UIButton *sureBtn = [[UIButton alloc] init];
        [sureBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.backgroundColor = kYellowColor;
        [sureBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 4.0f;
        [_bgView addSubview:sureBtn];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.top.mas_equalTo(tipsLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
        
//        UIButton *closeBtn = [[UIButton alloc] init];
//        [closeBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bgView addSubview:closeBtn];
//        
//        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.mas_equalTo(_bgView);
//            make.size.mas_equalTo(CGSizeMake(50, 50));
//        }];
//        
//        UIImageView *imgView = [[UIImageView alloc] init];
//        imgView.userInteractionEnabled = NO;
//        imgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
//        [closeBtn addSubview:imgView];
//        
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(closeBtn.mas_top).offset(15);
//            make.right.mas_equalTo(closeBtn.mas_right).offset(-15);
//            make.size.mas_equalTo(CGSizeMake(15, 15));
//        }];
    }
    return _bgView;
}

@end
