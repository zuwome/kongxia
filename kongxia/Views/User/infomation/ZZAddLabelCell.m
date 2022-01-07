//
//  ZZAddLabelCell.m
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAddLabelCell.h"

@implementation ZZAddLabelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 2;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = kBlackTextColor.CGColor;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0x7A7A7B);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgView);
        }];
    }
    
    return self;
}

- (void)setData:(ZZUserLabel *)model selected:(BOOL)selected
{
    _titleLabel.text = model.content;
    if (selected) {
        _bgView.layer.borderColor = HEXCOLOR(0x3F3A3A).CGColor;
        _bgView.backgroundColor = kYellowColor;
        _titleLabel.textColor = HEXCOLOR(0x3F3A3A);
    } else {
        _bgView.layer.borderColor = HEXCOLOR(0x7A7A7B).CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = HEXCOLOR(0x7A7A7B);
    }
}

@end
