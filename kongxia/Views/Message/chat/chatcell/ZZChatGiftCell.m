//
//  ZZChatGiftCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatGiftCell.h"
#import <RongIMKit/RongIMKit.h>

#import "ZZChatTimeView.h"
#import "ZZChatReadStatusView.h"
#import "ZZChatBaseModel.h"

#import "UIResponder+ZZRouter.h"
#import "ZZChatConst.h"
#import "ZZChatGiftModel.h"
#import "ZZGiftModel.h"

@interface ZZChatGiftCell ()

@property (nonatomic, strong) UIImageView *giftBgImageView;

@property (nonatomic, strong) UIImageView *giftIconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLable;

@property (nonatomic, strong) CAGradientLayer *colorLayer;

@property (nonatomic, copy) NSString *colorStr;

@end

@implementation ZZChatGiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGift)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)makeGiftColor:(BOOL)inReverse {
    
    RCMessage *message = self.dataModel.message;
    ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
    
    // 颜色
    _colorStr = giftMessage.color;
    
    NSArray<NSString *> *colorStrArr = [_colorStr componentsSeparatedByString:@","];
    
    NSMutableArray *subLayers = self.giftBgImageView.layer.sublayers.mutableCopy;
    if ([subLayers containsObject:_colorLayer]) {
        [subLayers removeObject:_colorLayer];
        _colorLayer = nil;
    }
    
    UIColor *textColor = kBlackColor;
    if (colorStrArr.count == 0) {
        self.giftBgImageView.backgroundColor = UIColor.whiteColor;
        self.giftBgImageView.layer.sublayers = subLayers.copy;
    }
    else if (colorStrArr.count == 1) {
        NSString *colorStr = [NSString stringWithFormat:@"#%@", colorStrArr.firstObject];
        self.giftBgImageView.backgroundColor = [UIColor colorUsingHexString:colorStr];
        
        self.giftBgImageView.layer.sublayers = subLayers.copy;
    }
    else {
        NSMutableArray<UIColor *> *colorsM = @[].mutableCopy;
        [colorStrArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *colorStr = [NSString stringWithFormat:@"#%@", obj];
            [colorsM addObject: [UIColor colorUsingHexString:colorStr]];
        }];
        NSArray *locationsArr = nil;
        if (colorStrArr.count == 3) {
            if (!inReverse) {
                locationsArr = @[@(0.0), @(0.8), @(1.0)];
            }
            else {
                locationsArr = @[@(0.0), @(0.2), @(1.0)];
            }
        }
        else {
            if (!inReverse) {
                locationsArr = @[@(0.0), @(0.38), @(0.68), @(1.0)];
            }
            else {
                locationsArr = @[@(0.0), @(0.38), @(0.68), @(1.0)];
            }
        }

        if (inReverse) {
            colorsM = [[colorsM reverseObjectEnumerator] allObjects].mutableCopy;
        }
        
        _colorLayer = [ZZUtils setGradientColor:colorsM.copy locations:locationsArr start:CGPointMake(0, 1) end:CGPointMake(1, 0) inView:_giftBgImageView];

        [subLayers insertObject:_colorLayer atIndex:0];
        self.giftBgImageView.layer.sublayers = subLayers.copy;
        
        textColor = UIColor.whiteColor;
    }
    
    _titleLabel.textColor = textColor;
    _subTitleLable.textColor = textColor;
}

- (void)setData:(ZZChatBaseModel *)model {
    [super setData:model];

    RCMessage *message = model.message;
    
    // 重新布局
    [self relayout:message.messageDirection == MessageDirection_SEND];
    
    ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
    
    // 礼物图片
    [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:giftMessage.icon] completed:nil];
    
    NSString *title = nil;
    NSMutableString *subTitle = nil;
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    BOOL inReverse = NO;
    if (message.messageDirection == MessageDirection_SEND) {
        title = giftMessage.from_msg_a;
        subTitle = giftMessage.from_msg_b.mutableCopy;
        NSRange range = [subTitle rangeOfString:@"$charm_num"];
        if (range.location != NSNotFound) {
            [subTitle replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%@",giftMessage.charm_num]];
        }
        corners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        
        inReverse = NO;
    }
    else {
        title = giftMessage.to_msg_a;
        subTitle = giftMessage.to_msg_b.mutableCopy;
        NSRange range = [subTitle rangeOfString:@"$charm_num"];
        if (range.location != NSNotFound) {
            [subTitle replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%@",giftMessage.charm_num]];
        }
        corners = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        
        inReverse = YES;
    }
    
    _titleLabel.text = title;
    _subTitleLable.text = subTitle;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.giftBgImageView.bounds byRoundingCorners: corners cornerRadii:CGSizeMake(10.0, 10.0)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        self.giftBgImageView.layer.mask = shape;
        
        // 渐变色
        [self makeGiftColor:inReverse];
    });
}

#pragma mark - response method
- (void)showGift {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectGift:)]) {
        
        RCMessage *message = self.dataModel.message;
        ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
        [self.delegate cell:self didSelectGift:giftMessage];
    }
}

#pragma mark - Layout
- (void)layout {
    [self.bgView addSubview:self.giftBgImageView];
    [self.bgView addSubview:self.giftIconImageView];
    [self.giftBgImageView addSubview:self.titleLabel];
    [self.giftBgImageView addSubview:self.subTitleLable];

}

- (void)relayout:(BOOL)isSend {
    self.bubbleImgView.image = nil;
    
    if (isSend) {
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLable.textAlignment = NSTextAlignmentRight;

        [_giftBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView);
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.giftBgImageView).offset(-20.0);
            make.top.equalTo(self.giftBgImageView).offset(15.0);
            make.left.equalTo(self.giftBgImageView).offset(45.5);
        }];

        [_subTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(3.0);
        }];

        [_giftIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.giftBgImageView.mas_left);
            make.centerY.equalTo(self.giftBgImageView);
            make.size.mas_equalTo(CGSizeMake(71, 71));
        }];
        
        [self.readStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_left).offset(-(8 + 71 / 2));
        }];
        
        [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_left).offset(-(8 + 71 / 2));
        }];
    }
    else {
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLable.textAlignment = NSTextAlignmentLeft;

        [_giftBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView);
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.giftBgImageView).offset(20.0);
            make.top.equalTo(self.giftBgImageView).offset(15.0);
            make.right.equalTo(self.giftBgImageView).offset(-45.5);
        }];

        [_subTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(3.0);
        }];
        
        [_giftIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.giftBgImageView.mas_right);
            make.centerY.equalTo(self.giftBgImageView);
            make.size.mas_equalTo(CGSizeMake(71, 71));
        }];
    }

}

#pragma mark - getters and setters
- (UIImageView *)giftBgImageView {
    if (!_giftBgImageView) {
        _giftBgImageView = [[UIImageView alloc] init];
        _giftBgImageView.userInteractionEnabled = YES;
    }
    return _giftBgImageView;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
        _giftIconImageView.contentMode = UIViewContentModeScaleToFill;
        _giftIconImageView.userInteractionEnabled = YES;
    }
    return _giftIconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor  = kBlackColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLable {
    if (!_subTitleLable) {
        _subTitleLable = [[UILabel alloc] init];
        _subTitleLable.textAlignment = NSTextAlignmentRight;
        _subTitleLable.textColor  = kBlackColor;
        _subTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];

    }
    return _subTitleLable;
}

@end
