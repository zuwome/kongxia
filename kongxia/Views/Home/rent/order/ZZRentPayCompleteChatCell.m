//
//  ZZRentPayCompleteChatCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentPayCompleteChatCell.h"

@interface ZZRentPayCompleteChatCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *chatBtn;

@property (nonatomic, strong) UIView *line;

@end

@implementation ZZRentPayCompleteChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configure {
    NSMutableAttributedString *attriMut = [[NSMutableAttributedString alloc] initWithString:@"已付意向金 "];
    [attriMut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:19] range:NSMakeRange(0, attriMut.length)];
    [attriMut addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(63, 58, 58) range:NSMakeRange(0, attriMut.length)];
    
    NSString *price = [NSString stringWithFormat:@"￥%@",_order.advancePrice];
    NSMutableAttributedString *priAttrMut = [[NSMutableAttributedString alloc] initWithString:price];
    [priAttrMut addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:23] range:NSMakeRange(0, price.length)];
    [priAttrMut addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(63, 58, 58) range:NSMakeRange(0, price.length)];
    [attriMut appendAttributedString:priAttrMut];
    
    _titleLabel.attributedText = attriMut;
}

#pragma mark - response method
- (void)goChat {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellGoChat:)]) {
        [self.delegate cellGoChat:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.titleLabel];
//    [self addSubview:self.priceLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.chatBtn];
    [self.contentView addSubview:self.line];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(18.0);
    }];
    
//    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(30.0);
//        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
//    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
    }];
    
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(183, 36));
    }];
    
    _line.frame = CGRectMake(15.0, 158.0, SCREEN_WIDTH - 30.0, 1);
    [self drawDashLine:_line lineLength:10 lineSpacing:5 lineColor:RGBCOLOR(216, 216, 216)];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

#pragma mark - getters and setters
- (void)setOrder:(ZZOrder *)order {
    _order = order;
    [self configure];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"已付意向金";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:34];
    }
    return _priceLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"发送邀约成功，请及时沟通并等待对方接受";
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    }
    return _subTitleLabel;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [[UIButton alloc] init];
        _chatBtn.normalTitle = @"私信TA";
        _chatBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _chatBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [_chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
        
        _chatBtn.layer.borderColor = RGBCOLOR(63, 58, 58).CGColor;
        _chatBtn.layer.borderWidth = 1;
        _chatBtn.layer.cornerRadius = 18.0;
    }
    return _chatBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
    }
    return _line;
}

@end
