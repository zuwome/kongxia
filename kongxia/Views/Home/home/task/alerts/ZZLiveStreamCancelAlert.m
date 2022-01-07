//
//  ZZLiveStreamCancelAlert.m
//  zuwome
//
//  Created by angBiu on 2017/7/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamCancelAlert.h"

@interface ZZLiveStreamCancelAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ZZLiveStreamCancelAlert

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

- (void)sureBtnClick
{
    [self cancelBtnClick];
    if (_touchCancel) {
        _touchCancel();
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
            make.width.mas_equalTo(310*scale);
        }];
        
        self.imgView.image = [UIImage imageNamed:@"icon_livestream_cancel_alert"];
        NSString *cancelCountStr = [NSString stringWithFormat:@"%@",[ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].cancel_count]];
        NSString *cancelMaxStr = [NSString stringWithFormat:@"%@",[ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].cancel_count_max]];
        
        
        NSString *string = @"";
        if ([cancelCountStr intValue] == 0) {
            string = [NSString stringWithFormat:@"若连续取消%@次任务，2小时内将无法发布任务", cancelMaxStr];
        } else {
            string = [NSString stringWithFormat:@"您已连续取消%@次，若连续取消%@次任务，2小时内将无法发布任务",cancelCountStr,cancelMaxStr];
        }
        NSRange range1 = [string rangeOfString:cancelCountStr];
        NSRange range2 = [string rangeOfString:cancelMaxStr];
        NSMutableAttributedString *attributedString = [ZZUtils setLineSpace:string space:5 fontSize:14 color:kBlackTextColor];
        [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:range1];
        [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:range2];
        self.titleLabel.attributedText = attributedString;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.cancelBtn.hidden = NO;
        self.sureBtn.hidden = NO;
    }
    return _bgView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(30);
            make.size.mas_equalTo(CGSizeMake(72, 80.5));
        }];
    }
    return _imgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(30);
            make.right.mas_equalTo(_bgView.mas_right).offset(-30);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(20);
        }];
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"再看看" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.backgroundColor = kYellowColor;
        _cancelBtn.layer.cornerRadius = 3;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-6);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-14);
        }];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定取消" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        _sureBtn.layer.cornerRadius = 3;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-18);
            make.left.mas_equalTo(_bgView.mas_centerX).offset(5);
            make.top.bottom.mas_equalTo(_cancelBtn);
        }];
    }
    return _sureBtn;
}

@end
