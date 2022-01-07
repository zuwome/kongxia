//
//  ZZPayGuaranteeCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPayGuaranteeCell.h"

@interface ZZPayGuaranteeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSArray<UIView *> *viewsArray;

@end

@implementation ZZPayGuaranteeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15.0);
    }];
    
    NSArray *titles = @[@"平台担保支付", @"邀约随心取消", @"极速推荐"];
    NSArray *images = @[@"icPtdbzf", @"icYysxqx", @"icJstj"];
    CGFloat itemWidth = SCREEN_WIDTH / 3;
    
    NSMutableArray<UIView *> *viewsArray = @[].mutableCopy;
    for (int i = 0 ; i < 3 ; i++) {
        UIView *itemView = [self createItemViewWithTitle:titles[i] image:images[i]];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(itemWidth * i);
            make.top.equalTo(_titleLabel.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(@(itemWidth));
        }];
        [viewsArray addObject:itemView];
    }
    _viewsArray = viewsArray.copy;
}

- (UIView *)createItemViewWithTitle:(NSString *)title image:(NSString *)imageStr {
    UIView *itemView = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageStr];
    imageView.tag = 222;
    [itemView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGBCOLOR(158, 158, 158);
    titleLabel.font = CustomFont(13);
    titleLabel.text = title;
    titleLabel.tag = 111;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    
    [itemView addSubview:titleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.top.equalTo(itemView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.bottom.equalTo(itemView).offset(-15.0);
        make.left.right.equalTo(itemView);
    }];
    
    return itemView;
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _titleLabel.text = @"平台保障";
    }
    return _titleLabel;
}

- (void)setGuaranteeTexts:(NSDictionary *)guaranteeTexts {
    _guaranteeTexts = guaranteeTexts;
    [_viewsArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *titleLabel = (UILabel *)[obj viewWithTag:111];
        UIImageView *imageView = (UIImageView *)[obj viewWithTag:222];
        if (idx == 0) {
            if ([_guaranteeTexts[@"text_a"] isKindOfClass:[NSString class]] && !isNullString(_guaranteeTexts[@"text_a"])) {
                titleLabel.text = _guaranteeTexts[@"text_a"];
            }
            if ([_guaranteeTexts[@"icon_a"] isKindOfClass:[NSString class]] && !isNullString(_guaranteeTexts[@"icon_a"])) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_guaranteeTexts[@"icon_a"]]];
            }
        }
        else if (idx == 1) {
            if ([_guaranteeTexts[@"text_b"] isKindOfClass:[NSString class]] && !isNullString(_guaranteeTexts[@"text_b"])) {
                titleLabel.text = _guaranteeTexts[@"text_b"];
            }
            if ([_guaranteeTexts[@"icon_b"] isKindOfClass:[NSString class]] && !isNullString(_guaranteeTexts[@"icon_b"])) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_guaranteeTexts[@"icon_b"]]];
            }
        }
        else {
            if ([_guaranteeTexts[@"text_c"] isKindOfClass:[NSString class]] && !isNullString(_guaranteeTexts[@"text_c"])) {
                titleLabel.text = _guaranteeTexts[@"text_c"];
            }
            if ([_guaranteeTexts[@"icon_c"] isKindOfClass:[NSString class]] && !isNullString(_guaranteeTexts[@"icon_c"])) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_guaranteeTexts[@"icon_c"]]];
            }
        }
    }];
}

@end
