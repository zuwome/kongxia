//
//  ZZServiceChargeCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/13.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZServiceChargeCell.h"
#import "ZZAuditFeeModel.h"

@interface ZZServiceChargeCell ()

@property (nonatomic, strong) UIView *shadowView;//阴影层
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *discount;

@end

@implementation ZZServiceChargeCell

+ (NSString *)reuseIdentifier {
    return @"ZZServiceChargeCell";
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        commonInitSafe(ZZServiceChargeCell);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonInitSafe(ZZServiceChargeCell);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

commonInitImplementationSafe(ZZServiceChargeCell) {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.shadowView = [UIView new];
    _shadowView.layer.shadowColor = RGBCOLOR(160, 137, 25).CGColor;//阴影颜色
    _shadowView.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
    _shadowView.layer.shadowOpacity = 0.4;//不透明度
    _shadowView.layer.shadowRadius = 2.0f;
    _shadowView.layer.cornerRadius = 8.0f;

    self.backgroundImageView = [UIImageView new];
    _backgroundImageView.backgroundColor = [UIColor whiteColor];
    _backgroundImageView.layer.masksToBounds = YES;
    _backgroundImageView.layer.cornerRadius = 8.0f;
    _backgroundImageView.layer.borderWidth = 1.0f;
    _backgroundImageView.layer.borderColor = RGBCOLOR(245, 245, 245).CGColor;
    self.backgroundImageView.userInteractionEnabled = YES;
//    _backgroundImageView.image = [UIImage imageNamed:@"rectangle4"];
    
    self.monthLabel = [UILabel new];
    self.monthLabel.textColor = kBlackColor;
    self.monthLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = RGBCOLOR(245, 88, 66);
    self.priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.discount = [UILabel new];
    self.discount.textColor = [UIColor whiteColor];
    self.discount.backgroundColor = RGBCOLOR(245, 88, 66);
    self.discount.layer.masksToBounds = YES;
    self.discount.layer.cornerRadius = 4.0f;
    self.discount.font = [UIFont systemFontOfSize:15];
    self.discount.textAlignment = NSTextAlignmentCenter;
    
    UIButton *openingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openingBtn setTitle:@"开通" forState:(UIControlStateNormal)];
    [openingBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    openingBtn.backgroundColor = RGBCOLOR(244, 203, 7);
    openingBtn.layer.masksToBounds = YES;
    openingBtn.layer.cornerRadius = 4.0f;
    openingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [openingBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.backgroundImageView];
    
    [self.backgroundImageView addSubview:self.monthLabel];
    [self.backgroundImageView addSubview:self.priceLabel];
    [self.backgroundImageView addSubview:self.discount];
    [self.backgroundImageView addSubview:openingBtn];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@(-10));
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@(-10));
    }];
    
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.leading.equalTo(@15);
        make.width.equalTo(@60);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.leading.equalTo(self.monthLabel.mas_trailing).offset(15);
        make.width.equalTo(@50);
    }];
    
    [self.discount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backgroundImageView.mas_centerY);
        make.leading.equalTo(self.priceLabel.mas_trailing).offset(10);
        make.width.equalTo(@35);
        make.height.equalTo(@20);
    }];
    
    [openingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-10));
        make.centerY.equalTo(self.backgroundImageView.mas_centerY);
        make.width.equalTo(@53);
        make.height.equalTo(@32);
    }];
}

- (IBAction)openClick:(UIButton *)sender {
    BLOCK_SAFE_CALLS(self.openBlock);
}

- (void)setSelectCurrent:(BOOL)selectCurrent {
    _selectCurrent = selectCurrent;
    
    self.backgroundImageView.image = selectCurrent ? [UIImage imageNamed:@"rectangle4"] : nil;
    
    _backgroundImageView.layer.borderWidth = selectCurrent ? 0.0f : 1.0f;
    _backgroundImageView.layer.borderColor = selectCurrent ? [UIColor whiteColor].CGColor : RGBCOLOR(245, 245, 245).CGColor;
}

- (void)setupWithModel:(ZZAuditFeeModel *)model {
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@", model.duration_text];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", model.price_text];
    self.discount.text = [NSString stringWithFormat:@"%@", model.discount_text];
    if ([model.discount intValue] == 0) {
        self.discount.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
