//
//  ZZTaskChooseCell.m
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskChooseCell.h"

@interface ZZTaskChooseCell ()

@property (nonatomic, strong) UIView *shadowView;//阴影层
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZTaskChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZTaskChooseCell);
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZTaskChooseCell);
    }
    return self;
}

commonInitImplementationSafe(ZZTaskChooseCell) {

    self.backgroundColor = [UIColor whiteColor];
    
    self.shadowView = [UIView new];
    self.shadowView.backgroundColor = RGBCOLOR(190, 190, 190);
    _shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
    _shadowView.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
    _shadowView.layer.shadowOpacity = 0.5;//不透明度
    _shadowView.layer.shadowRadius = 2.0f;
    _shadowView.layer.cornerRadius = 4.0f;

    [self.contentView addSubview:self.shadowView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4.0f;
    bgView.layer.borderColor = kLineViewColor.CGColor;
    bgView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:bgView];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@25);
        make.trailing.equalTo(@(-25));
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-10));
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@25);
        make.trailing.equalTo(@(-25));
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-10));
    }];
    
    _imgView = [[UIImageView alloc] init];
    [bgView addSubview:_imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.height.equalTo(@32);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = kBlackColor;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = @"电竞指导";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(_imgView.mas_trailing).offset(8);
//        make.top.equalTo(_imgView.mas_top);
//        make.bottom.equalTo(_imgView.mas_bottom);
//        make.trailing.equalTo(@(-10));
        make.centerY.centerX.equalTo(bgView);
    }];
}

- (void)setData:(ZZSkill *)skill {
    
    _titleLabel.text = skill.name;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:skill.selected_img] placeholderImage:defaultBackgroundImage_SelectTalent options:SDWebImageRetryFailed];
}

@end
