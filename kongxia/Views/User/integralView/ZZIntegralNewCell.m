//
//  ZZIntegralNewCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegralNewCell.h"
@interface ZZIntegralNewCell()
@property (nonatomic,strong) UIImageView *iconImageView;//活动图标
@property (nonatomic,strong) UILabel *eventDetailsLab;//活动的内容
@property (nonatomic,strong) UILabel *rewardsLab;//活动的奖励
@property (nonatomic,strong) UIButton *goCompleteButton;//去完成活动
@property (nonatomic,strong) UIImageView *completedImageView;//已经完成的标志
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIView *lineView;//分割线

@end
@implementation ZZIntegralNewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.eventDetailsLab];
        [self.contentView addSubview:self.rewardsLab];
        [self.contentView addSubview:self.goCompleteButton];
        [self.contentView addSubview:self.completedImageView];
        [self.contentView addSubview:self.lineView];

    }
    return self;
}

- (void)setModel:(ZZIntegralTaskModel *)model {
    if (_model != model) {
        _model = model;
        _eventDetailsLab.text = model.taskname;
        self.iconImageView.image = [UIImage imageNamed:model.imageName];
        [self updateStateWithState:[model.status intValue]];
        self.rewardsLab.text = [NSString stringWithFormat:@"+%@",model.score];
    }
}

/**
 更新状态
 */
- (void)updateStateWithState:(int) state{
    if (state ==0) {
        [self.goCompleteButton setTitle:_model.action forState:UIControlStateNormal];
        self.completedImageView.hidden = YES;
        self.goCompleteButton.hidden = NO;
    }else{
        self.completedImageView.hidden = NO;
        self.goCompleteButton.hidden = YES;
    }
}

#pragma mark - 懒加载
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    }
    return _lineView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 4;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UILabel *)eventDetailsLab {
    if (!_eventDetailsLab) {
        _eventDetailsLab = [[UILabel alloc]init];
        _eventDetailsLab.textAlignment = NSTextAlignmentLeft;
        _eventDetailsLab.font = CustomFont(15);
        _eventDetailsLab.textColor = kBlackColor;
    }
    return _eventDetailsLab;
}

- (UIButton *)goCompleteButton {
    if (!_goCompleteButton) {
        _goCompleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goCompleteButton setTitleColor:RGBCOLOR(99, 79, 35) forState:UIControlStateNormal];
        [_goCompleteButton setImage:[UIImage imageNamed:@"icTodoXsrw"] forState:UIControlStateNormal];
        _goCompleteButton.titleLabel.font = ADaptedFontMediumSize(15);
        [_goCompleteButton addTarget:self action:@selector(goCompleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _goCompleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 54, 0, 2.5);
        _goCompleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, -34, 0, 30);
        _goCompleteButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goCompleteButton;
}

- (UILabel *)rewardsLab {
    if (!_rewardsLab) {
        _rewardsLab = [[UILabel alloc]init];
        _rewardsLab.textColor = RGBCOLOR(199, 182, 108);
        
        _rewardsLab.font = ADaptedFuturaBoldSize(15);
        _rewardsLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _rewardsLab;
}

- (UIImageView *)completedImageView {
    if (!_completedImageView) {
        _completedImageView = [[UIImageView alloc]init];
        _completedImageView.image = [UIImage imageNamed:@"icCompletedXsrw"];
    }
    return _completedImageView;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.eventDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(11);
        make.top.offset(8);
        make.right.offset(-8);
        make.height.equalTo(@21);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(11);
        make.top.equalTo(self.eventDetailsLab.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [self.rewardsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(9);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.offset(-10);
    }];
    [self.goCompleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-2.5);
        make.left.offset(11);
        make.height.equalTo(@44);
        make.right.offset(-11);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goCompleteButton.mas_top).offset(-2.5);
        make.left.right.offset(0);
        make.height.equalTo(@1);
    }];
    [self.completedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-8);
        make.right.offset(-11.5);
        make.size.mas_equalTo(CGSizeMake(60, 49));
    }];
    
}
#pragma  mark - 点击事件

- (void)goCompleteButtonClick {
    if (self.goToComplete) {
        self.goToComplete(self);
    }
}
@end
