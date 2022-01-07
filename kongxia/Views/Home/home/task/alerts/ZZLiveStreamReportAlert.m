//
//  ZZLiveStreamReportAlert.m
//  zuwome
//
//  Created by angBiu on 2017/7/24.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamReportAlert.h"

@interface ZZLiveStreamReportAlert ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZLiveStreamReportAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.75);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)reportBtnClick
{
    [self removeFromSuperview];
    if (_touchReport) {
        _touchReport();
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 4;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(300*scale);
        }];
        
        UIImageView *alerImgView = [[UIImageView alloc] init];
        alerImgView.image = [UIImage imageNamed:@"icon_livestream_reportalert"];
        [self addSubview:alerImgView];
        
        [alerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(12);
            make.bottom.mas_equalTo(_bgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(33.5, 30.5));
        }];
        
        UIImageView *topImgView = [[UIImageView alloc] init];
        topImgView.image = [UIImage imageNamed:@"icon_livestream_reportbg"];
        [_bgView addSubview:topImgView];
        
        [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_bgView);
            make.height.mas_equalTo((300*scale)*(70/301.0));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = kBlackTextColor;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.text = @"举报会上传你们的聊天记录，视频将被立即挂断，是否继续举报";
        contentLabel.numberOfLines = 0;
        [_bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topImgView.mas_bottom).offset(20);
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        cancelBtn.layer.cornerRadius = 3;
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(20);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-6);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(-18);
        }];
        
        UIButton *sureBtn = [[UIButton alloc] init];
        [sureBtn setTitle:@"举报" forState:UIControlStateNormal];
        [sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        sureBtn.backgroundColor = kYellowColor;
        sureBtn.layer.cornerRadius = 3;
        [sureBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:sureBtn];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_centerX).offset(6);
            make.top.mas_equalTo(cancelBtn.mas_top);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.height.mas_equalTo(@44);
        }];
    }
    return _bgView;
}

@end
