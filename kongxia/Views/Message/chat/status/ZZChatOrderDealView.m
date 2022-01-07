//
//  ZZChatOrderDealView.m
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatOrderDealView.h"

@interface ZZChatOrderDealView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *refuseBtn;

@end

@implementation ZZChatOrderDealView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgBtn.backgroundColor = HEXACOLOR(0x000000, 0.6);
        [bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 275)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        _bgView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
        
        self.titleLabel.text = @"处理邀约";
        [self.acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)acceptBtnClick
{
    if (_touchAccept) {
        _touchAccept();
    }
    [self cancelBtnClick];
}

- (void)refuseBtnClick
{
    if (_touchRefuse) {
        _touchRefuse();
    }
    [self cancelBtnClick];
}

- (void)cancelBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showView
{
    self.bgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

#pragma mark - 

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_bgView);
            make.height.mas_equalTo(@57);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
        [_bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.bottom.mas_equalTo(_titleLabel.mas_bottom);
            make.height.mas_equalTo(@1);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_cancel"];
        imgView.userInteractionEnabled = NO;
        [cancelBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cancelBtn.mas_top).offset(15);
            make.right.mas_equalTo(cancelBtn.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    return _titleLabel;
}

- (UIButton *)acceptBtn
{
    if (!_acceptBtn) {
        _acceptBtn = [[UIButton alloc] init];
        [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
        [_acceptBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _acceptBtn.backgroundColor = kYellowColor;
        _acceptBtn.layer.cornerRadius = 22;
        [_bgView addSubview:_acceptBtn];
        
        [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(18);
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.height.mas_equalTo(@44);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kGrayContentColor;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"提前与对方联系，合理规划行程，确保高履约率";
        titleLabel.numberOfLines = 0;
        [_bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_acceptBtn.mas_bottom).offset(5);
            make.left.mas_equalTo(_acceptBtn.mas_left);
            make.right.mas_equalTo(_acceptBtn.mas_right);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEXCOLOR(0xD8D8D8);
        [_bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.bottom.mas_equalTo(_acceptBtn.mas_bottom).offset(45);
            make.height.mas_equalTo(@1);
        }];
    }
    return _acceptBtn;
}

- (UIButton *)refuseBtn
{
    if (!_refuseBtn) {
        _refuseBtn = [[UIButton alloc] init];
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _refuseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _refuseBtn.backgroundColor = kYellowColor;
        _refuseBtn.layer.cornerRadius = 22;
        [_bgView addSubview:_refuseBtn];
        
        [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_acceptBtn.mas_bottom).offset(60);
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.height.mas_equalTo(@44);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kGrayContentColor;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"若无法赴约，请点击拒绝邀约选择拒绝理由";
        [_bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_refuseBtn.mas_bottom).offset(5);
            make.left.mas_equalTo(_refuseBtn.mas_left);
            make.right.mas_equalTo(_refuseBtn.mas_right);
        }];
    }
    return _refuseBtn;
}

@end
