//
//  ZZOrderDetailCell.m
//  zuwome
//
//  Created by wlsy on 16/1/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderDetailCell.h"

@implementation ZZOrderDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_nameLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        btn.userInteractionEnabled = NO;
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);
        _bgView.layer.shadowOpacity = 0.9;
        _bgView.layer.shadowRadius = 1;
    }
    
    return self;
}

@end
