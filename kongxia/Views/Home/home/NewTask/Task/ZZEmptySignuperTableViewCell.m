//
//  ZZEmptySignuperTableViewCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZEmptySignuperTableViewCell.h"

@interface ZZEmptySignuperTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLbale;

@end

@implementation ZZEmptySignuperTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configure {
    _titleLbale.text = _item.title;
    _iconImageView.image = [UIImage imageNamed:_item.icon];//
    [self layoutFrames];
}

#pragma mark - Layout
- (void)setItem:(TaskEmptyItem *)item {
    _item = item;
    [self configure];
}

- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLbale];
}

- (void)layoutFrames {
    CGSize iconImageSize = CGSizeMake(129, 104);
    _iconImageView.frame = CGRectMake(self.width * 0.5 - iconImageSize.width * 0.5, 45, iconImageSize.width, iconImageSize.height);
    _titleLbale.frame = CGRectMake(0.0, _iconImageView.bottom + 15.0, self.width, _titleLbale.font.lineHeight);
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"picQuesheng"];
    }
    return _iconImageView;
}

- (UILabel *)titleLbale {
    if (!_titleLbale) {
        _titleLbale = [[UILabel alloc] init];
        _titleLbale.font = [UIFont systemFontOfSize:14.0];
        _titleLbale.text = @"暂时没有人报名呢";
        _titleLbale.textColor = RGBCOLOR(153, 153, 153);
        _titleLbale.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbale;
}


@end
