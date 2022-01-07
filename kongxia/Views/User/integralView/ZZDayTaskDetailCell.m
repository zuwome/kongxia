//
//  ZZDayTaskDetailCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZDayTaskDetailCell.h"
@interface ZZDayTaskDetailCell()
@property (nonatomic,copy) UILabel *titleLab;
@property (nonatomic,copy) UILabel *titleScoreLab;
@property (nonatomic,copy) UIButton *gotoCompleteButton;
@property (nonatomic,copy) UIView *lineView;
@property (nonatomic,copy) UIImageView *dayTaskmageView;

@end
@implementation ZZDayTaskDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.titleScoreLab];
        [self.contentView addSubview:self.gotoCompleteButton];
        [self.contentView addSubview:self.dayTaskmageView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma  mark - 懒加载

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = kBlackColor;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = CustomFont(15);
    }
    return _titleLab;
}

- (UILabel *)titleScoreLab {
    if (!_titleScoreLab) {
        _titleScoreLab = [[UILabel alloc]init];
        _titleScoreLab.font = ADaptedFontMediumSize(13);
        _titleScoreLab.textAlignment = NSTextAlignmentLeft;
        _titleScoreLab.textColor = kBlackColor;
    }
    return _titleScoreLab;
}


-(UIImageView *)dayTaskmageView {
    if (!_dayTaskmageView) {
        _dayTaskmageView = [[UIImageView alloc]init];
        _dayTaskmageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _dayTaskmageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _lineView;
}

- (UIButton *)gotoCompleteButton {
    if (!_gotoCompleteButton) {
        _gotoCompleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoCompleteButton addTarget:self action:@selector(gotoCompleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _gotoCompleteButton.layer.cornerRadius = 13.5;
        _gotoCompleteButton.titleLabel.font =  CustomFont(14);
        _gotoCompleteButton.backgroundColor = RGBCOLOR(244, 203, 7);
        [_gotoCompleteButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
    return _gotoCompleteButton;
}

#pragma mark - 去分享的点击事件

- (void)gotoCompleteButtonClick {
    if (self.gotoCompleteBlock) {
        self.gotoCompleteBlock(self.dayTaskModel);
    }
}

#pragma  mark - 数据逻辑
/**
 根据数据变动cell
 */
- (void)setDayTaskModel:(ZZIntegralTaskModel *)dayTaskModel {
    if (_dayTaskModel != dayTaskModel) {
        _dayTaskModel = dayTaskModel;
        self.titleLab.text = dayTaskModel.taskname;
        self.dayTaskmageView.image = [UIImage imageNamed:dayTaskModel.imageName];
        [self setTitleScore:dayTaskModel.score];
        
        if ([dayTaskModel.status integerValue] ==0) {
            self.gotoCompleteButton.enabled = YES;
            [self.gotoCompleteButton setTitle:dayTaskModel.action forState:UIControlStateNormal];
              _gotoCompleteButton.backgroundColor = RGBCOLOR(244, 203, 7);
        }else{
            [self.gotoCompleteButton setTitle:@"已完成" forState:UIControlStateNormal];
            self.gotoCompleteButton.enabled = NO;
            _gotoCompleteButton.backgroundColor = RGBACOLOR(224, 224, 224, 0.5);
        }
        
    }
}

- (void)setTitleScore:(NSString *)scoreString {
    NSString *signString = [NSString stringWithFormat:@"积分+%@",scoreString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:signString];
    
    NSRange dayNumberRange = [signString rangeOfString:@"积分"];
    
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Futura-Medium" size:13]
                       range:NSMakeRange(dayNumberRange.length,signString.length - dayNumberRange.length)];
    
    self.titleScoreLab.attributedText = attrString;
}

#pragma  mark - 约束
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dayTaskmageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayTaskmageView.mas_right).offset(15);
        make.top.equalTo(self.dayTaskmageView.mas_top);
        make.right.offset(-140);
        make.bottom.equalTo(self.titleScoreLab.mas_top);
    }];
    [self.titleScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayTaskmageView.mas_right).offset(16.5);
        make.bottom.equalTo(self.dayTaskmageView.mas_bottom);
        make.right.offset(-140);
    }];
    [self.gotoCompleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64, 27));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
    }];
}


@end
