//
//  ZZProtocalChooseView.m
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZProtocalChooseView.h"

@implementation ZZProtocalChooseView
{
    UIImageView *_imgView;
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame isLogin:(BOOL)isLogin
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _isLogin = isLogin;
        _isSelected = NO;
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"btn_report_n"];
        _imgView.hidden = YES;
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _titleLabel = nil;
        NSString *didChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"didLoginChecked"];
        if (!isNullString(didChecked)) {
            _isSelected = YES;
            _imgView.image = [UIImage imageNamed:@"btn_report_p"];
        }
        _titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayContentColor fontSize:12 text:@"登录或注册即同意"];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (_isLogin) {
                make.left.mas_equalTo(self.mas_left);
//            }
//            else {
//                make.left.mas_equalTo(_imgView.mas_right).offset(5);
//            }
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UILabel *protocalLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:12 text:@"《空虾用户协议》"];
        [self addSubview:protocalLabel];
        [protocalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    
        NSString *str = @"和《空虾隐私权政策》";
        UILabel *privateLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:12 text:str];
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName value:kGrayContentColor range:NSMakeRange(0, str.length)];
        
        NSRange range = [str rangeOfString:@"《空虾隐私权政策》"];
        if (range.location != NSNotFound) {
            [attriStr addAttribute:NSForegroundColorAttributeName value:kYellowColor range:range];
        }
        privateLabel.attributedText = attriStr;
        privateLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPrivateProtocol)];
        [privateLabel addGestureRecognizer:tap];
        
        [self addSubview:privateLabel];
        [privateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(protocalLabel.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(_titleLabel.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UIButton *protocalBtn = [[UIButton alloc] init];
        [protocalBtn addTarget:self action:@selector(protocalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:protocalBtn];
        
        [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(protocalLabel);
        }];
    }
    
    return self;
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    if (_isLogin) {
        _titleLabel.text = @"登录即同意";
    }
    else {
        _titleLabel.text = @"注册即同意";
    }
}

- (void)didChecked {
    _isSelected = YES;
    _imgView.image = [UIImage imageNamed:@"btn_report_p"];
}

- (void)btnClick
{

    if (_isSelected) {
        _isSelected = NO;
        _imgView.image = [UIImage imageNamed:@"btn_report_n"];
        if (_isLogin) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"didLoginChecked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {
        _isSelected = YES;
        _imgView.image = [UIImage imageNamed:@"btn_report_p"];
        if (_isLogin) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"didLoginChecked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
   
}

- (void)protocalBtnClick
{
    if (_touchProtocal) {
        _touchProtocal();
    }
}

- (void)showPrivateProtocol {
    if (_touchPrivate) {
        _touchPrivate();
    }
}

@end
