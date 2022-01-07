//
//  ZZRentDynamicContributionView.m
//  zuwome
//
//  Created by angBiu on 16/8/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentDynamicContributionView.h"

#import "ZZMemedaModel.h"

@implementation ZZRentDynamicContributionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"赏金贡献榜";
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.contentMode = UIViewContentModeScaleToFill;
        _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
        [self addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(7, 15));
        }];
        
        _thiImgView = [[UIImageView alloc] init];
        _thiImgView.backgroundColor = kBGColor;
        _thiImgView.clipsToBounds = YES;
        _thiImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thiImgView.layer.cornerRadius = 14;
        [self addSubview:_thiImgView];
        
        [_thiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        _secImgView = [[UIImageView alloc] init];
        _secImgView.backgroundColor = kBGColor;
        _secImgView.clipsToBounds = YES;
        _secImgView.contentMode = UIViewContentModeScaleAspectFill;
        _secImgView.layer.cornerRadius = 14;
        [self addSubview:_secImgView];
        
        [_secImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_thiImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        _firImgView = [[UIImageView alloc] init];
        _firImgView.backgroundColor = kBGColor;
        _firImgView.clipsToBounds = YES;
        _firImgView.contentMode = UIViewContentModeScaleAspectFill;
        _firImgView.layer.cornerRadius = 14;
        [self addSubview:_firImgView];
        
        [_firImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_secImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(contributionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)setTips:(NSArray *)array
{
    _thiImgView.hidden = YES;
    _secImgView.hidden = YES;
    _firImgView.hidden = YES;
    NSInteger cout = array.count;
    if (cout > 0) {
        ZZMMDTipsModel *tipsModel = [array lastObject];
        [_thiImgView sd_setImageWithURL:[NSURL URLWithString:tipsModel.from.avatar]];
        _thiImgView.hidden = NO;
    }
    if (cout > 1) {
        ZZMMDTipsModel *tipsModel = array[cout + 1 - 3];
        [_secImgView sd_setImageWithURL:[NSURL URLWithString:tipsModel.from.avatar]];
        _secImgView.hidden = NO;
    }
    if (cout > 2) {
        ZZMMDTipsModel *tipsModel = array[0];
        [_firImgView sd_setImageWithURL:[NSURL URLWithString:tipsModel.from.avatar]];
        _firImgView.hidden = NO;
    }
}

- (void)contributionBtnClick
{
    if (_touchContribution) {
        _touchContribution();
    }
}

@end
