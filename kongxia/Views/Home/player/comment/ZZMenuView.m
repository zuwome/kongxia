//
//  ZZMenuView.m
//  zuwome
//
//  Created by angBiu on 2017/3/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMenuView.h"

@interface ZZMenuView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bgView.layer.cornerRadius = 6;
        self.imgView.hidden = NO;
    }
    
    return self;
}

- (void)setType:(NSInteger)type
{
    [_bgView removeAllSubviews];
    _type = type;
    NSArray *titleArray = @[];
    switch (type) {
        case 0:
        {
            titleArray = @[@"删除"];
            [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bgView.mas_centerX);
            }];
        }
            break;
        case 1:
        {
            titleArray = @[@"删除",@"举报"];
            [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bgView.mas_centerX).offset(10);
            }];
        }
            break;
        case 2:
        {
            titleArray = @[@"举报"];
            [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bgView.mas_centerX);
            }];
        }
            break;
        default:
            break;
    }
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60*i, 0, 60, 35)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = HEXCOLOR(0x28282A);
        [_bgView addSubview:btn];
        
        if (i != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60*i, 0, 1, 35)];
            lineView.backgroundColor = [UIColor whiteColor];
            [_bgView addSubview:lineView];
        }
    }
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleArray.count*60);
    }];
}

- (void)btnClick:(UIButton *)sender
{
    [self removeFromSuperview];
    switch (_type) {
        case 0:
        {
            if (_touchDelete) {
                _touchDelete();
            }
        }
            break;
        case 1:
        {
            if (sender.tag == 100) {
                if (_touchDelete) {
                    _touchDelete();
                }
            } else {
                if (_touchReport) {
                    _touchReport();
                }
            }
        }
            break;
        case 2:
        {
            if (_touchReport) {
                _touchReport();
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark  -

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.clipsToBounds = YES;
        _bgView.backgroundColor = HEXCOLOR(0x28282A);
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self);
            make.height.mas_equalTo(@35);
        }];
    }
    return _bgView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_player_menu_triangle"];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_bottom);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(19.5, 10));
        }];
    }
    return _imgView;
}

@end
