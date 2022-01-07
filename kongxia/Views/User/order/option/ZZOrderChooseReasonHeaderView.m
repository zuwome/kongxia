//
//  ZZOrderChooseReasonHeaderView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderChooseReasonHeaderView.h"
@interface ZZOrderChooseReasonHeaderView ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *placeholderImgView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bgView;

@end

@implementation ZZOrderChooseReasonHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview: self.titleLab];
        [self.bgView addSubview:self.placeholderImgView];
        [self.bgView addSubview:self.lineView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews ];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.placeholderImgView.mas_right).offset(6.5);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.offset(-14.5);
    }];

    [self.placeholderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.width.equalTo(@17);
        make.height.equalTo(@17);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.height.equalTo(@0.5);
        make.bottom.offset(0);
    }];
    
}
-(UIView *)bgView  {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = CustomFont(15);
        _titleLab.textColor = kBlackColor;
        _titleLab.text= @"请选择原因";
    }
    return _titleLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGBCOLOR(216, 216, 216);
    }
    return _lineView;
}

- (UIImageView *)placeholderImgView {
    if (!_placeholderImgView) {
        _placeholderImgView = [[UIImageView alloc]init];
        _placeholderImgView.image  = [UIImage imageNamed:@"icChoiceRefundreason"];
    }
    return _placeholderImgView;
}
@end
