//
//  ZZNewOrderResonCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewOrderResonCell.h"
@interface ZZNewOrderResonCell()

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *detaillLab;
@property(nonatomic,strong) UIImageView *arrowImageView;
@property(nonatomic,strong) UIView *lineView;

@end
@implementation ZZNewOrderResonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setModel:(ZZInvitationModel *)model {
    if (_model !=model) {
        _model = model;
        self.titleLab.text = model.title;
        self.detaillLab.text = model.detailTitle;
        [UILabel changeLineSpaceForLabel:self.detaillLab WithSpace:5];
    }
}
- (void)setUI {
    [self addSubview:self.titleLab];
    [self addSubview:self.detaillLab];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.equalTo(@11.5);
        make.height.equalTo(@21);
    }];
    
    [self.detaillLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-18);
        make.top.equalTo(self.titleLab.mas_bottom).offset(6);
        make.bottom.equalTo(self.lineView.mas_top).offset(-6);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.equalTo(self.arrowImageView.mas_height);
        make.height.equalTo(@20);
        make.centerY.equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(@0.5);
    }];
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = CustomFont(15);
        _titleLab.textColor = kBlackColor;
        
    }
    return _titleLab;
}

- (UILabel *)detaillLab {
    if (!_detaillLab) {
        _detaillLab = [[UILabel alloc]init];
        _detaillLab.textColor = RGBCOLOR(128, 128, 128);
        _detaillLab.font = CustomFont(12);
        _detaillLab.numberOfLines = 0;
    }
    return _detaillLab;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = [UIImage imageNamed:@"icMoreRefundreason"];
    }
    return _arrowImageView ;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
