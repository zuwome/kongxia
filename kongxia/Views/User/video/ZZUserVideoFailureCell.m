//
//  ZZUserVideoFailureCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserVideoFailureCell.h"

#import <AVFoundation/AVFoundation.h>
#import "ZZVideoUploadStatusView.h"

@interface ZZUserVideoFailureCell ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat space;

@end

@implementation ZZUserVideoFailureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _width = (SCREEN_WIDTH - 15)/2.0;
        _height = _width*13/9;
        _space = (_height - 29 - 32 - 20)/3.0;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 3;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        self.coverView.hidden = NO;
        self.timeLabel.text = @"仅保留24小时";
        self.retryImgView.image = [UIImage imageNamed:@"icon_user_video_retry"];
        self.deleteImgView.image = [UIImage imageNamed:@"icon_record_delete"];
    }
    
    return self;
}

- (void)hideViews
{
    self.retryImgView.hidden = YES;
    self.deleteImgView.hidden = YES;
    self.timeLabel.hidden = YES;
}

- (void)showViews
{
    self.retryImgView.hidden = NO;
    self.deleteImgView.hidden = NO;
    self.timeLabel.hidden = NO;
}

#pragma mark - UIButtonMethod

- (void)retryBtnClick
{
    if (!self.retryImgView.hidden) {
        if (_touchRetry) {
            _touchRetry();
        }
        [self hideViews];
    }
}

- (void)deleteBtnClick
{
    if (!self.deleteImgView.hidden) {
        if (_touchDelete) {
            _touchDelete();
        }
    }
}

#pragma mark -

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        _coverView.layer.cornerRadius = 3;
        _coverView.clipsToBounds = YES;
        _coverView.alpha = 0.8;
        [self.contentView addSubview:_coverView];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, _width, _height);
        [_coverView addSubview:effectview];
    }
    return _coverView;
}

- (UIImageView *)retryImgView
{
    if (!_retryImgView) {
        _retryImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_retryImgView];
        
        [_retryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(_space);
            make.size.mas_equalTo(CGSizeMake(32, 29));
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(retryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_retryImgView.mas_centerX);
            make.centerY.mas_equalTo(_retryImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
    }
    return _retryImgView;
}

- (UIImageView *)deleteImgView
{
    if (!_deleteImgView) {
        _deleteImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_deleteImgView];
        
        [_deleteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-_space);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_deleteImgView.mas_centerX);
            make.centerY.mas_equalTo(_deleteImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
    }
    return _deleteImgView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return _timeLabel;
}

@end
