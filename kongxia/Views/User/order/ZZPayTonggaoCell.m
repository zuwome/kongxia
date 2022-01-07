//
//  ZZPayTonggaoCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/7/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPayTonggaoCell.h"

@interface ZZPayTonggaoCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSArray<UIView *> *viewsArray;

@end

@implementation ZZPayTonggaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15.0);
    }];
    
    NSArray *titles = @[@"资金安全", @"真实资料", @"在线客服"];
    NSArray *subTitles = @[@"平台监督 担保支付", @"实名认证 真实可靠", @"在线客服 全程服务"];
    NSArray *images = @[@"icZaixiankefu", @"icZijinanquan", @"icZiliaozhenshi"];
    CGFloat itemWidth = SCREEN_WIDTH / 3;
    
    NSMutableArray<UIView *> *viewsArray = @[].mutableCopy;
    for (int i = 0 ; i < 3 ; i++) {
        UIView *itemView = [self createItemViewWithTitle:titles[i] image:images[i] subtitle:subTitles[i]];
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

- (UIView *)createItemViewWithTitle:(NSString *)title image:(NSString *)imageStr subtitle:(NSString *)subTitle {
    UIView *itemView = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageStr];
    imageView.tag = 222;
    [itemView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGBCOLOR(63, 58, 58);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    titleLabel.text = title;
    titleLabel.tag = 111;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = RGBCOLOR(102, 102, 102);
    subTitleLabel.font = CustomFont(11);
    subTitleLabel.text = subTitle;
    subTitleLabel.tag = 111;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.numberOfLines = 1;
    
    [itemView addSubview:titleLabel];
    [itemView addSubview:subTitleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.top.equalTo(itemView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.top.equalTo(imageView.mas_bottom).offset(3.0);
        make.left.right.equalTo(itemView);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.top.equalTo(titleLabel.mas_bottom).offset(3.0);
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

@end
