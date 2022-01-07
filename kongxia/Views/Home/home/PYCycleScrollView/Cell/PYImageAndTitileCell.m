//
//  PYImageAndTitileCell.m
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//
#import <Masonry.h>
#import "PYImageAndTitileCell.h"
#import <UIImageView+WebCache.h>

@interface PYImageAndTitileCell()
@property (strong, nonatomic) UIImageView *py_ImageView;//图片
@property (strong, nonatomic) UILabel *py_TitleLab;//大标题
@property (strong, nonatomic) UILabel *py_SubTitleLab;//小标题
@property (strong, nonatomic) UIImageView *arrowImage;//小箭头

@end
@implementation PYImageAndTitileCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.py_TitleLab];
        [self addSubview:self.py_SubTitleLab];
        [self addSubview:self.py_ImageView];
        [self addSubview:self.arrowImage];
    }
    return self;
}

/**
 设置数据
 */
- (void)setModel:(PYCycleItemModel *)model {
    _model = model;
    self.py_SubTitleLab.text = model.sub_title;
    self.py_TitleLab.text = model.title;
    [self.py_ImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"picStory"]];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.mas_centerY).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(6, 13));
    }];
    
    [self.py_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.arrowImage.mas_centerY);
        make.left.offset(6);
        make.size.mas_equalTo(CGSizeMake(46, 43));
    }];
    [self.py_TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.py_ImageView.mas_top);
        make.left.equalTo(self.py_ImageView.mas_right).with.offset(10);
        make.bottom.mas_lessThanOrEqualTo(self.py_SubTitleLab.mas_top).with.offset(-4);
        make.right.mas_lessThanOrEqualTo (self.arrowImage.mas_left).with.offset(-8);
    }];
    
    [self.py_SubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.py_ImageView.mas_bottom);
        make.left.equalTo(self.py_ImageView.mas_right).with.offset(10);
        make.right.mas_lessThanOrEqualTo (self.arrowImage.mas_left).with.offset(-8);
    }];

}
/**
标题
 */
- (UILabel *)py_TitleLab {
    if (!_py_TitleLab) {
        _py_TitleLab = [[UILabel alloc]init];
        _py_TitleLab.font = [UIFont systemFontOfSize:15];
        _py_TitleLab.textColor = kBlackColor;
        _py_TitleLab.text = @"我只是测试数据";
        _py_TitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _py_TitleLab;
}


/**
 子标题
 */
-(UILabel *)py_SubTitleLab {
    if (!_py_SubTitleLab) {
        _py_SubTitleLab = [[UILabel alloc]init];
        _py_SubTitleLab.font = [UIFont systemFontOfSize:13];
        _py_SubTitleLab.textColor = RGBCOLOR(85, 85, 85);
        _py_SubTitleLab.text = @"我只是测试子标题数据";
        _py_SubTitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _py_SubTitleLab;
}
-(UIImageView *)arrowImage {
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"icStoryMore"];
    }
    return _arrowImage;
}
/**
 图片
 */
-(UIImageView *)py_ImageView {
    if (!_py_ImageView) {
        _py_ImageView = [[UIImageView alloc]init];
    }
    return _py_ImageView;
}

@end
