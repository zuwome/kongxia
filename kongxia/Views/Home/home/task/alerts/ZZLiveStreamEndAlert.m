//
//  ZZLiveStreamEndVeiw.m
//  zuwome
//
//  Created by angBiu on 2017/7/19.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamEndAlert.h"

@interface ZZLiveStreamEndAlert ()

@end

@implementation ZZLiveStreamEndAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.3);
        
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    _contentLabel.textColor = HEXCOLOR(0x9b9b9b);
    switch (type) {
        case 1:
        {
            _titleLabel.text = @"无法发布任务";
            _centerImgView.image = [UIImage imageNamed:@"icon_livestream_countdown"];
            _contentLabel.textColor = HEXCOLOR(0x3f3a3a);
        }
            break;
        case 2:
        {
            _titleLabel.text = @"暂无达人抢任务";
            _centerImgView.image = [UIImage imageNamed:@"icon_livestream_nobody"];
            _contentLabel.text = @"目前没有合适的达人抢您的任务，可以稍后试一试，小技巧：19点以后，会有更多达人在线哦";
        }
            break;
        case 3:
        {
            _titleLabel.text = @"不再推荐此人";
            _centerImgView.image = [UIImage imageNamed:@"icon_livestream_norecommend"];
            _contentLabel.text = @"您发布的任务将不再推荐给此达人";
        }
            break;
        case 4:
        {
            _titleLabel.text = @"选择时间已用完";
            _centerImgView.image = [UIImage imageNamed:@"icon_livestream_countdown"];
            _contentLabel.attributedText = [ZZUtils setLineSpace:@"您未在规定时间内选择达人，当前任务自动取消，请重新发布任务" space:5 fontSize:14 color:HEXCOLOR(0x9b9b9b)];
            _contentLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case 5:
        {
            _titleLabel.text = @"支付时间已过";
            _centerImgView.image = [UIImage imageNamed:@"icon_livestream_countdown"];
            [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)sureBtnClick
{
    if (_touchSure) {
        _touchSure();
    }
    [self removeFromSuperview];
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
            make.width.mas_equalTo(286*scale);
        }];
        
        self.titleLabel.text = @"您已连续取消1次，若连续取消3次任务，今日将无法发布1V1视频通话，";
        self.centerImgView.image = [UIImage imageNamed:@"icon_livestream_reqeust_center"];
        self.contentLabel.text = @"您已连续取消3次任务，2小时内无法发布新的任务";
        self.sureBtn.hidden = NO;
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = NO;
        imgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
        [closeBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(closeBtn.mas_top).offset(15);
            make.right.mas_equalTo(closeBtn.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x3f3a3a);
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(18);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)centerImgView
{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_centerImgView];
        
        [_centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(14);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
    }
    return _centerImgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = HEXCOLOR(0x9b9b9b);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(22);
            make.right.mas_equalTo(_bgView.mas_right).offset(-22);
            make.top.mas_equalTo(_centerImgView.mas_bottom).offset(8);
        }];
    }
    return _contentLabel;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.backgroundColor = kYellowColor;
        _sureBtn.layer.cornerRadius = 3;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-16);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
    }
    return _sureBtn;
}

@end
