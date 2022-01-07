//
//  ZZIntegralExchangeCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegralExchangeCell.h"
@interface ZZIntegralExchangeCell()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *imageMebiIconView;
@property (nonatomic,strong) UIImageView *imageJiFenIconView;
@property (nonatomic,strong) UILabel *mebiLab;
@property (nonatomic,strong) UILabel *integralLab;

@end
@implementation ZZIntegralExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xf8f8f8);
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.imageMebiIconView];
        [self.bgImageView addSubview:self.imageJiFenIconView];
        [self.bgImageView addSubview:self.mebiLab];
        [self.bgImageView addSubview:self.integralLab];

    }
    return self;
}

- (void)setModel:(ZZIntegralExChangeDetailModel *)model {
    if (_model != model) {
        _model = model;
        self.mebiLab.text = [NSString stringWithFormat:@"%ld么币",(long)model.mcoin];
        self.integralLab.text = [NSString stringWithFormat:@"%ld积分",(long)model.integral];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.centerY.equalTo(self);
        make.height.equalTo(@59);
    }];
    
    [self.imageMebiIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13.5);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.mebiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageMebiIconView.mas_right).offset(5);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
    }];
    
    
    [self.imageJiFenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.integralLab.mas_left).offset(-5);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.left.offset(AdaptedWidth(240));
        make.size.mas_equalTo(CGSizeMake(16.5, 15));
    }];
    
    
    [self.integralLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.right.offset(-15.5);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)imageJiFenIconView {
    if (!_imageJiFenIconView ) {
        _imageJiFenIconView = [[UIImageView alloc]init];
        _imageJiFenIconView.image = [UIImage imageNamed:@"icJifenCard"];
    }
    return _imageJiFenIconView;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"IntegralExchangeBG"];
    }
    return _bgImageView;
}
- (UIImageView *)imageMebiIconView {
    if (!_imageMebiIconView) {
        _imageMebiIconView = [[UIImageView alloc]init];
        _imageMebiIconView.image = [UIImage imageNamed:@"icMebiJfdh"];
    }
    return _imageMebiIconView;
}

-(UILabel *)mebiLab {
    if (!_mebiLab) {
        _mebiLab = [[UILabel alloc]init];
        _mebiLab.textColor = kBlackColor;
        _mebiLab.textAlignment = NSTextAlignmentLeft;
        _mebiLab.font = ADaptedFontBoldSize(15);
    }
    return _mebiLab;
}

- (UILabel *)integralLab {
    if (!_integralLab) {
        _integralLab = [[UILabel alloc]init];
        _integralLab.textColor = kBlackColor;
        _integralLab.textAlignment = NSTextAlignmentLeft;
        _integralLab.font = ADaptedFontMediumSize(15);
    }
    return _integralLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
