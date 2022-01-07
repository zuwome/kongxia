//
//  ZZChatGiftTipsView.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatGiftTipsView.h"

@interface ZZChatGiftTipsView ()

@property (nonatomic, strong) UIImageView *giftIconImageView;

@property (nonatomic, strong) UILabel *giftLabel;

@end

@implementation ZZChatGiftTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 22;
    
    [self addSubview:self.giftIconImageView];
    [self addSubview:self.giftLabel];
    
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(11);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_giftIconImageView.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
        _giftIconImageView.image = [UIImage imageNamed:@"icLiwu"];
    }
    return _giftIconImageView;
}

- (UILabel *)giftLabel {
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc] init];
        _giftLabel.text = @"送TA礼物";
        _giftLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _giftLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _giftLabel;
}

@end
