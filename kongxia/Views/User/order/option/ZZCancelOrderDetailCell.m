//
//  ZZCancelOrderDetailCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZCancelOrderDetailCell.h"
#import "ZZDateHelper.h"
@interface ZZCancelOrderDetailCell()
/**
 邀约标题
 */
@property(nonatomic,strong) UILabel *orderTitleLab;
@property(nonatomic,strong) UIView *lineView;
/**
 订单项目名
 */
@property(nonatomic,strong) UILabel *orderNameLab;

/**
 订单时间
 */
@property(nonatomic,strong) UILabel *orderTimeLab;

/**
 订单价格
 */
@property(nonatomic,strong) UILabel *orderPriceLab;

/**
 订单地点
 */
@property(nonatomic,strong) UILabel *orderPlaceLab;

/**
 订单详情
 */
@property(nonatomic,strong) UIButton *orderInfoButton;

@end
@implementation ZZCancelOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}
- (void)setOrder:(ZZOrder *)order {
    if (_order != order ) {
        _order = order;
        /* 项目*/
        NSString *skillString = [NSString stringWithFormat:@"项目：%@",order.skill.name];
        self.orderNameLab.attributedText = [self getAttributedStringWithString:skillString range:[skillString rangeOfString:order.skill.name]];
        
        /*时间*/
        NSString *timeString = @"";
        if (isNullString(order.dated_at_text)) {
            if (order.exceed_dated_at) {
                timeString = [NSString stringWithFormat:@"时间：%@", order.exceed_dated_at_show];
                self.orderTimeLab.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[NSString stringWithFormat:@"%@",order.exceed_dated_at_show]]];
            } else if (order.dated_at_type == 1) {
                NSString *string = [[ZZDateHelper shareInstance] getQuickTimeStringWithDate:order.dated_at];
                if (isNullString(string)) {
                    string = [NSString stringWithFormat:@"%@",[[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]];
                    timeString = [NSString stringWithFormat:@"时间：%@",string];
                } else {
                    string = [NSString stringWithFormat:@"%@%@", kOrderQuickTimeString,string];
                    timeString = [NSString stringWithFormat:@"时间：%@", string];
                }
                self.orderTimeLab.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[NSString stringWithFormat:@"%@",string]]];
            } else {
                timeString = [NSString stringWithFormat:@"时间：%@",[[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]];
              self.orderTimeLab.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]]];
            }
        } else {
            timeString = [NSString stringWithFormat:@"时间：%@",order.dated_at_text];
           self.orderTimeLab.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:order.dated_at_text]];
        }
        
        /*金额 */
        double totalPrice = order.totalPrice.doubleValue;
        
//        if (order.wechat_service && [order.from.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
//            totalPrice += order.wechat_price;
//        }
//        else {
//            if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:order.from.uid]) {
//                totalPrice += order.xdf_price.doubleValue;
//            }
//        }
        
        NSString *totalPriceStr = [ZZUtils dealAccuracyNumber:[NSNumber numberWithDouble:totalPrice]];
        
        NSString *moneyStr = [NSString stringWithFormat:@"金额：%@元 / %d小时",totalPriceStr,order.hours];
        NSRange range = [moneyStr rangeOfString:[NSString stringWithFormat:@"%@元",totalPriceStr]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [string addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range];
        self.orderPriceLab.attributedText = string;
        
        /*地点*/
        NSString *cityString = @"";
        NSRange cityRange = [order.address rangeOfString:order.city.name];
        if (cityRange.location != NSNotFound) {
            cityString = [NSString stringWithFormat:@"%@",order.address];
        } else {
            cityString = [NSString stringWithFormat:@"%@%@",order.city.name,order.address];
        }
        NSString *localString = [NSString stringWithFormat:@"地点：%@",([NSString isBlank:cityString] || [cityString isEqualToString:@"(null)"]) ? @"" : cityString];
        self.orderPlaceLab.attributedText = [self getAttributedStringWithString:localString range:[localString rangeOfString:([NSString isBlank:cityString] || [cityString isEqualToString:@"(null)"]) ? @"" : cityString]];
        
    }
}

- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string range:(NSRange)range
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kBlackColor range:range];
    
    return attributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    
    [self.orderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.height.equalTo(@22);
        make.top.equalTo(@16);
        make.right.offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.equalTo(self.orderTitleLab.mas_bottom).offset(12);
        make.height.equalTo(@0.5);
    }];
    [self.orderNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.height.equalTo(@18.5);
        make.top.equalTo(self.lineView.mas_bottom).offset(8.5);
    }];
    
    [self.orderTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.equalTo(self.orderNameLab.mas_bottom).offset(8.5);
        make.height.equalTo(@18.5);
    }];
    [self.orderPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.equalTo(self.orderInfoButton.mas_left).offset(-5).priority(1000);
        make.top.equalTo(self.orderTimeLab.mas_bottom).offset(8.5);
        make.height.equalTo(@18.5);
    }];
    [self.orderPlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.equalTo(self.orderPriceLab.mas_bottom).offset(8.5);
        make.height.equalTo(@18.5);
    }];
    [self.orderInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@(-15));
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.orderPriceLab.mas_centerY);
    }];

}

/**
 设置UI
 */
- (void)setUI {
    [self addSubview:self.orderTitleLab];
    [self addSubview:self.lineView];
    [self addSubview:self.orderNameLab];
    [self addSubview:self.orderTimeLab];
    [self addSubview:self.orderPriceLab];
    [self addSubview:self.orderPlaceLab];
    [self addSubview:self.orderInfoButton];
}



- (UILabel *)orderTitleLab {
    if (!_orderTitleLab) {
        _orderTitleLab = [[UILabel alloc]init];
        _orderTitleLab.text = @"邀约信息";
        _orderTitleLab.textColor = kBlackColor;
        _orderTitleLab.font = CustomFont(15);
        _orderTitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _orderTitleLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _lineView;
}

- (UILabel *)orderNameLab {
    if (!_orderNameLab) {
        _orderNameLab = [[UILabel alloc]init];
        _orderNameLab.textAlignment = NSTextAlignmentLeft;
        _orderNameLab.textColor = kBlackColor;
        _orderNameLab.font = CustomFont(15);
    }
    return _orderNameLab;
}
- (UILabel *)orderTimeLab {
    if (!_orderTimeLab) {
        _orderTimeLab = [[UILabel alloc]init];
        _orderTimeLab.textAlignment = NSTextAlignmentLeft;
        _orderTimeLab.textColor = kBlackColor;
        _orderTimeLab.font = CustomFont(15);
    }
    return _orderTimeLab;
}
- (UILabel *)orderPriceLab {
    if (!_orderPriceLab) {
        _orderPriceLab = [[UILabel alloc]init];
        _orderPriceLab.textAlignment = NSTextAlignmentLeft;
        _orderPriceLab.textColor = kBlackColor;
        _orderPriceLab.font = CustomFont(15);
    }
    return _orderPriceLab;
}
- (UILabel *)orderPlaceLab {
    if (!_orderPlaceLab) {
        _orderPlaceLab = [[UILabel alloc]init];
        _orderPlaceLab.textAlignment = NSTextAlignmentLeft;
        _orderPlaceLab.textColor = kBlackColor;
        _orderPlaceLab.font = CustomFont(15);
    }
    return _orderPlaceLab;
}
- (UIButton *)orderInfoButton {
    if (!_orderInfoButton) {
        _orderInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderInfoButton setBackgroundImage:[UIImage imageNamed:@"icDetails"] forState:UIControlStateNormal];
        [_orderInfoButton addTarget:self action:@selector(clickOrderInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderInfoButton;
}

- (void)clickOrderInfoButton:(UIButton *)sender {
    if (self.goToOrderInfo) {
        self.goToOrderInfo();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
