//
//  ZZTonggaoPrepayCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/7/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTonggaoPrepayCell.h"

@interface ZZTonggaoPrepayCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UIButton *showBtn;

@end

@implementation ZZTonggaoPrepayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - response method
- (void)showProtocol {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShowProtocol:)]) {
        [self.delegate cellShowProtocol:self];
    }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.showBtn];
    [self addSubview:self.subtitleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.0);
        make.left.equalTo(self).offset(15.0);
    }];
    
    [_showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.equalTo(_titleLabel.mas_right).offset(10.0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.0);
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
//        make.left.equalTo(self).offset(15.0);
    }];
}

#pragma mark - getters and setters
- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [[UIButton alloc] init];
        _showBtn.normalImage = [UIImage imageNamed:@"icHelpYyCopy"];
        [_showBtn addTarget:self action:@selector(showProtocol) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
        _titleLabel.text = @"服务费退款规则";
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProtocol)];
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = RGBCOLOR(102, 102, 102);
        _subtitleLabel.font = [UIFont systemFontOfSize:13];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.text = @"发布通告需支付发布服务费，发布服务费为通告金额*30%，发布成功30分钟后且无人报名的情况下，您取消发布或通告自动过期后，发布服务费将全额退回。";
    }
    return _subtitleLabel;
}

@end
