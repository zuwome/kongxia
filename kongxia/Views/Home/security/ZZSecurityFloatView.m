//
//  ZZSecurityFloatView.m
//  zuwome
//
//  Created by angBiu on 2017/8/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityFloatView.h"

@implementation ZZSecurityFloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kYellowColor;
        _bgView.layer.cornerRadius = 3;
        [self addSubview:_bgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 0;
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(12);
            make.right.mas_equalTo(_bgView.mas_right).offset(-12);
            make.top.mas_equalTo(_bgView.mas_top).offset(12);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-7);
        }];
        
        _traingleView = [[ZZTranigleView alloc] init];
        [self addSubview:_traingleView];
        
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_security_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
        [_bgView addSubview:_closeBtn];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-8);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
    
    return self;
}

- (void)setInfoString:(NSString *)infoString
{
    _infoString = infoString;
    CGFloat width = [ZZUtils widthForCellWithText:infoString fontSize:13];
    CGFloat maxWidth;
    if (_showClose) {
        maxWidth = SCREEN_WIDTH - 40 - 40 - 12 - 30;
    } else {
        maxWidth = SCREEN_WIDTH - 40 - 40 - 12 - 12;
    }
    if (width > maxWidth) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }
    _titleLabel.attributedText = [ZZUtils setLineSpace:infoString space:5 fontSize:13 color:kBlackColor];
}

- (void)setIsUp:(BOOL)isUp
{
    _isUp = isUp;
    _traingleView.isUp = isUp;
    if (isUp) {
        [_traingleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(7, 2.5));
        }];
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top).offset(2.5);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    } else {
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
        }];
        [_traingleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_bottom);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(7, 2.5));
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
}

- (void)setShowClose:(BOOL)showClose
{
    _showClose = showClose;
    if (showClose) {
        _closeBtn.hidden = NO;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-30);
        }];
    } else {
        _closeBtn.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-12);
        }];
    }
}

#pragma mark - UIButtonMethod

- (void)closeBtnClick
{
    if (_touchClose) {
        _touchClose();
    }
}

@end
