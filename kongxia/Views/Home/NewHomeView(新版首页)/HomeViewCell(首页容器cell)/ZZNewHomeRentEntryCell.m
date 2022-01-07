//
//  ZZNewHomeRentEntryCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZNewHomeRentEntryCell.h"

@interface ZZNewHomeRentEntryCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *leftIconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation ZZNewHomeRentEntryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
        [self configure];
    }
    return self;
}

- (void)configureTitle:(NSString *)title subTitle:(NSString *)subTitle {
    if (!isNullString(title)) {
        _titleLabel.text = title;
    }
    
    if (!isNullString(subTitle)) {
        _subTitleLabel.text = subTitle;
    }
}

- (void)configure {
    _titleLabel.text = @"申请成为达人";
    _subTitleLabel.text = @"分享爱好特长，让别人发现你并获得收益";
}

#pragma mark - response method
- (void)showRent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShowRent:)]) {
        [self.delegate cellShowRent:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.bgView];
    [_bgView addSubview:self.leftIconImageView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.subTitleLabel];
    [_bgView addSubview:self.actionBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(125));
    }];
    
    [_leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(_bgView);
        make.width.equalTo(@(125));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(12);
        make.left.equalTo(_leftIconImageView.mas_right).offset(10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
        make.left.equalTo(_leftIconImageView.mas_right).offset(10);
        make.right.equalTo(_bgView).offset(-10.0);
    }];

    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView).offset(-10.0);
        make.bottom.equalTo(_bgView).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(69, 26));
    }];
    
    [_actionBtn setImagePosition:LXMImagePositionRight spacing:2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _actionBtn.bounds;
        
        gradient.colors = @[(id)RGBCOLOR(255, 200, 61).CGColor, (id)RGBCOLOR(255, 149, 49).CGColor];
        gradient.locations = @[@0.0, @1.0];
        
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        
        gradient.cornerRadius = 13.5;
        [_actionBtn.layer addSublayer:gradient];
        
        [_actionBtn bringSubviewToFront:_actionBtn.titleLabel];
        [_actionBtn bringSubviewToFront:_actionBtn.imageView];
    });
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 3;
    }
    return _bgView;
}

- (UIImageView *)leftIconImageView {
    if (!_leftIconImageView) {
        _leftIconImageView = [[UIImageView alloc] init];
        _leftIconImageView.image = [UIImage imageNamed:@"picGirl"];
    }
    return _leftIconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ADaptedFontBoldSize(21);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _subTitleLabel.numberOfLines = 2;
    }
    return _subTitleLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        _actionBtn.normalTitle = @"去申请";
        _actionBtn.normalImage = [UIImage imageNamed:@"icQushenqing"];
        _actionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _actionBtn.backgroundColor = RGBCOLOR(255, 149, 49);
        _actionBtn.layer.cornerRadius = 13.5;
        
        [_actionBtn addTarget:self action:@selector(showRent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end
