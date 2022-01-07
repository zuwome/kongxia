//
//  ZZUserRegistedGuidView.m
//  kongxia
//
//  Created by qiming xiao on 2019/9/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZUserRegistedGuidView.h"

@interface ZZUserRegistedGuidView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) NSArray<UILabel *> *infoLabelArray;

@end

@implementation ZZUserRegistedGuidView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureInfos:(NSDictionary *)infosDic {
    _titleLabel.text = infosDic[@"title"];
    
    if ([infosDic[@"tipArr"] isKindOfClass:[NSArray class]]) {
        NSArray *tipsArr = infosDic[@"tipArr"];
        
        [_infoLabelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tipsArr.count == 0) {
                obj.hidden = YES;
            }
            else {
                if (idx >= tipsArr.count) {
                    obj.hidden = YES;
                }
                else {
                    obj.hidden = NO;
                    UIImage *coloredImage = [UIImage imageFromColor:RGBCOLOR(102, 102, 102)];
                    UIImage *cornerdImage = [coloredImage imageAddCornerWithRadius:2.5 andSize:CGSizeMake(5, 5)];
                    
                    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",tipsArr[idx]]];
                    
                    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Medium" size:14],NSFontAttributeName,
                                                   RGBCOLOR(102, 102, 102),NSForegroundColorAttributeName,nil];
                    
                    [attributeStr addAttributes:attributeDict range:NSMakeRange(0, attributeStr.length)];
                    
                    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                    attach.image = cornerdImage;
                    attach.bounds = CGRectMake(0, 2, 5, 5);
                    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
                    [attributeStr insertAttributedString:attributeStr2 atIndex:0];
                    obj.attributedText = attributeStr;
                }
            }
        }];
    }
}

#pragma mark - response method
- (void)dismiss {
    [self removeFromSuperview];
}

- (void)confirm {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidConfirm:)]) {
        [self.delegate viewDidConfirm:self];
    }
}

#pragma mark - Layout
- (void)layout {
    
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.layer.cornerRadius = 6;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(292, 335));
    }];
    
    [contentView addSubview:self.iconImageView];
    [contentView addSubview:self.cancelBtn];
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.confirmBtn];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(143, 104));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(_iconImageView.mas_bottom);
        make.left.equalTo(contentView).offset(42);
        make.right.equalTo(contentView).offset(-42);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(-24);
        make.size.mas_equalTo(CGSizeMake(202, 44));
    }];
    
    UIView *bottomView = _titleLabel;
    NSMutableArray *labelsMArr = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"成为达人分享爱好特长，空暇时间也能赚钱";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        label.textColor = RGBCOLOR(102, 102, 102);
        label.hidden = YES;
        [self addSubview:label];
        [labelsMArr addObject:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(111);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(bottomView.mas_bottom).offset(i == 0 ? 19 : 5);
        }];
        bottomView = label;
    }
    _infoLabelArray = labelsMArr.copy;
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.5;
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"picTanchuangSqdr"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"成为达人分享爱好特长，空暇时间也能赚钱";
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];//[UIFont fontWithName:@"PingFangSC-Heavy" size:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"申请达人";
        _confirmBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _confirmBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _confirmBtn.layer.cornerRadius = 22;
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setImage:[UIImage imageNamed:@"icGbTc"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
