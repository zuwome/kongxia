//
//  ZZRentOrderHeaderView.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderHeaderView.h"
#import "ZZPostTaskRulesToastView.h"

@interface ZZRentOrderHeaderView ()

@end

@implementation ZZRentOrderHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)showProtocol {
    [ZZPostTaskRulesToastView showWithRulesType:RulesTypeAddSkill];
}

- (void)isPay:(BOOL)isPay {
    if (!isPay) {
        [_subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15.0);
            make.top.equalTo(_titleLabel.mas_bottom).offset(6.0);
            make.right.equalTo(self).offset(-15.0);
            make.bottom.equalTo(self).offset(-9.0);
        }];
        return;
    }
    
    //设置富文本
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:@"平台担保支付"];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName,
                                   RGBCOLOR(153, 153, 153),NSForegroundColorAttributeName,nil];
    [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
    
    //添加图片
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"icHelpYyCopy"];
    attach.bounds = CGRectMake(3, -4, 16, 16);
    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr1 appendAttributedString:attributeStr2];
    
    _subTitleLabel.attributedText = attributeStr1;
    
    [_subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(15.0);
        make.bottom.equalTo(self).offset(-15.0);
    }];
}

- (void)layout {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(_titleLabel.mas_bottom).offset(6.0);
        make.right.equalTo(self).offset(-15.0);
        make.bottom.equalTo(self).offset(-9.0);
    }];
    
}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15.0];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12.0];
        _subTitleLabel.textColor = RGBCOLOR(171, 171, 171);
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProtocol)];
        [_subTitleLabel addGestureRecognizer:tap];
    }
    return _subTitleLabel;
}

@end
