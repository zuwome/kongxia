//
//  PYImageCollectionViewCell.m
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "PYImageCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface PYImageCollectionViewCell ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *arrowImage;//小箭头

@end
@implementation PYImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        
        [self addSubview:self.arrowImage];
        [self setUI];
    }
    return self;
}

/**
 外部给数据
 */
- (void)setModel:(PYCycleItemModel *)model {
        _model = model;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:[UIImage imageNamed:@"rectangle21"]];
}
-(UIImageView *)arrowImage {
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"icStoryMore"];
    }
    return _arrowImage;
}
- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self addSubview:imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}
- (void)setUI
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.height.equalTo(self.mas_height).multipliedBy(0.729);
        make.centerY.mas_equalTo(self.mas_centerY).offset(5);
        make.right.mas_equalTo(-5);
    }];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.imageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6, 13));
    }];
}
@end
