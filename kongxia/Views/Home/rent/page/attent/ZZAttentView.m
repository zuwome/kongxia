//
//  ZZAttentView.m
//  zuwome
//
//  Created by angBiu on 16/8/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAttentView.h"

@implementation ZZAttentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIButton *attentBtn = [[UIButton alloc] init];
        [attentBtn addTarget:self action:@selector(attentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:attentBtn];
        
        [attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.attentBgView.hidden = YES;
    }
    
    return self;
}

- (void)setFontSize:(NSInteger)fontSize
{
    _fontSize = fontSize;
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _attentLabel.font = [UIFont systemFontOfSize:fontSize];
    
    CGFloat height = [ZZUtils heightForCellWithText:@"关注" fontSize:fontSize labelWidth:SCREEN_WIDTH] - 5;
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(height, height));
    }];
}

- (void)setFollow_status:(NSInteger)follow_status
{
    _attentBgView.hidden = YES;
    _titleLabel.hidden = NO;
    switch (follow_status) {
        case 0:
        {
            _attentBgView.hidden = NO;
            _titleLabel.hidden = YES;
            _bgView.backgroundColor = kYellowColor;
            _bgView.alpha = 1;
        }
            break;
        case 1:
        {
            _titleLabel.text = @"已关注";
            _titleLabel.textColor = [UIColor whiteColor];
            _bgView.backgroundColor = [UIColor whiteColor];
            _bgView.alpha = 0.3;
        }
            break;
        case 2:
        {
            _titleLabel.text = @"互相关注";
            _titleLabel.textColor = [UIColor whiteColor];
            _bgView.backgroundColor = [UIColor whiteColor];
            _bgView.alpha = 0.3;
        }
            break;
        default:
            break;
    }
}

- (void)setListFollow_status:(NSInteger)listFollow_status
{
    _titleLabel.textColor = kBlackTextColor;
    _attentBgView.hidden = YES;
    _titleLabel.hidden = NO;
    switch (listFollow_status) {
        case 0:
        {
            _attentBgView.hidden = NO;
            _titleLabel.hidden = YES;
            _bgView.backgroundColor = HEXCOLOR(0xFCF0B5);
        }
            break;
        case 1:
        {
            _titleLabel.text = @"已关注";
            _bgView.backgroundColor = HEXACOLOR(0xFDF086, 0.4);
        }
            break;
        case 2:
        {
            _titleLabel.text = @"互相关注";
            _bgView.backgroundColor = HEXACOLOR(0xFDF086, 0.2);
        }
            break;
        default:
            break;
    }
}

- (void)setUser:(ZZUser *)user
{
    if ([user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

- (void)attentBtnClick
{
    if (_touchAttent) {
        _touchAttent();
    }
}

#pragma mark - 

- (UIView *)attentBgView
{
    if (!_attentBgView) {
        _attentBgView = [[UIView alloc] init];
        _attentBgView.userInteractionEnabled = NO;
        [self addSubview:_attentBgView];
        
        [_attentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.mas_equalTo(self);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_attent"];
        [_attentBgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(_attentBgView);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];
        
        _attentLabel = [[UILabel alloc] init];
        _attentLabel.text = @"关注";
        _attentLabel.textColor = kBlackTextColor;
        [_attentBgView addSubview:_attentLabel];
        
        [_attentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(3);
            make.centerY.right.mas_equalTo(_attentBgView);
        }];
    }
    return _attentBgView;
}

@end
