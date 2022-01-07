//
//  ZZPostTaskPriceCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskPriceCell.h"
#import "ZZPostTaskViewModel.h"
#import "ZZPostTaskCellModel.h"

@interface ZZPostTaskPriceCell ()

@property (nonatomic, strong) UIImageView *priceImageView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *priceAccessoryImageView;

@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation ZZPostTaskPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _priceImageView.image = [UIImage imageNamed:_cellModel.icon];
    
    NSString *price = (NSString *)_cellModel.data;
    if (!isNullString(price)) {
        _priceLabel.text = price;
        _priceLabel.textColor = UIColor.blackColor;
    }
    else {
        _priceLabel.text = @"打赏给达人多少钱？";
        _priceLabel.textColor = RGBCOLOR(153, 153, 153);
    }
}

#pragma mark - response method
- (void)action:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(priceCellChoosePrice:)]) {
        [self.delegate priceCellChoosePrice:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.priceImageView];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priceAccessoryImageView];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.titleLabel];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-30);
        make.height.equalTo(@54);
    }];
    
    [_priceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLabel);
        make.right.equalTo(_priceLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_priceAccessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLabel);
        make.left.equalTo(_priceLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 11.5));
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceLabel);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(_priceLabel.mas_bottom).offset(10.0);
    }];
}

#pragma mark - getters and setters
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _line1;
}

- (UIImageView *)priceImageView {
    if (!_priceImageView) {
        _priceImageView = [[UIImageView alloc] init];
        _priceImageView.image = [UIImage imageNamed:@"icJutiweizhi"];
    }
    return _priceImageView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"打赏给达人多少钱？";
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = RGBCOLOR(153, 153, 153);
        _priceLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [_priceLabel addGestureRecognizer:tap];
    }
    return _priceLabel;
}

- (UIImageView *)priceAccessoryImageView {
    if (!_priceAccessoryImageView) {
        _priceAccessoryImageView = [[UIImageView alloc] init];
        _priceAccessoryImageView.image = [UIImage imageNamed:@"icon_order_right"];
    }
    return _priceAccessoryImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"一条通告最多可以同时选择5位达人";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _titleLabel;
}

@end
