//
//  ZZSecurityView.m
//  zuwome
//
//  Created by angBiu on 2017/8/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityView.h"

@implementation ZZSecurityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel.attributedText = [ZZUtils setLineSpace:@"空虾用户遇到人身危险时的\n专属通道，请谨慎使用" space:5 fontSize:20 color:kBlackTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.attributedText = [ZZUtils setLineSpace:@"空虾将采集录音保留证据，并发送\n短信给紧急联系人" space:5 fontSize:15 color:HEXCOLOR(0xbbbbbb)];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.helpBtn.hidden = NO;
    }
    
    return self;
}

- (void)setTest:(BOOL)test
{
    _test = test;
    if (test) {
        [self.floatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_helpBtn.mas_top).offset(-12);
        }];
        
        _floatView.isUp = NO;
        _floatView.infoString = @"遇到危险 点击紧急求助按钮";
    } else {
        [self.testBtn addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [self.floatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_testBtn.mas_bottom);
        }];
        
        _floatView.isUp = YES;
        _floatView.infoString = @"空虾非常重视您的安全问题 可以点击试用";
    }
}

- (void)helpBtnClick
{
    if (_touchHelp) {
        _touchHelp();
    }
}

- (void)testBtnClick
{
    _testBtn.hidden = YES;
    _floatView.hidden = YES;
    if (_touchTest) {
        _touchTest();
    }
}

#pragma mark - lazyload

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(30);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xbbbbbb);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return _contentLabel;
}

- (UIButton *)testBtn
{
    if (!_testBtn) {
        _testBtn = [[UIButton alloc] init];
        [self addSubview:_testBtn];
        
        [_testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(8);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(@40);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackColor;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"试用一下";
        titleLabel.userInteractionEnabled = NO;
        [_testBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(_testBtn);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
        arrowImgView.userInteractionEnabled = NO;
        [_testBtn addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(8);
            make.centerY.right.mas_equalTo(_testBtn);
            make.size.mas_equalTo(CGSizeMake(6.8, 14));
        }];
    }
    return _testBtn;
}

- (ZZSecurityFloatView *)floatView
{
    if (!_floatView) {
        _floatView = [[ZZSecurityFloatView alloc] init];
        [self addSubview:_floatView];
    }
    return _floatView;
}

- (UIButton *)helpBtn
{
    if (!_helpBtn) {
        CGFloat scale = SCREEN_WIDTH /375.0;
        if (scale > 1) {
            scale = 1;
        }
        _helpBtn = [[UIButton alloc] init];
        [_helpBtn setImage:[UIImage imageNamed:@"icon_security_inside"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_helpBtn];
        
        [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-65*scale);
        }];
    }
    return _helpBtn;
}

@end
