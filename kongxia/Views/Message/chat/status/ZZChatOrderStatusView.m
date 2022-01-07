//
//  ZZChatOrderStatusView.m
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatOrderStatusView.h"

#import "ZZDateHelper.h"
#import "ZZViewHelper.h"

@implementation ZZChatOrderStatusView
{
    ZZOrder                             *_order;
    UIImageView                         *_moreImgView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _skillLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
        [self addSubview:_skillLabel];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(8);
        }];
        
        _timeLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_skillLabel.mas_left);
            make.top.mas_equalTo(_skillLabel.mas_bottom).offset(5);
        }];
        
        _locationLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
        [self addSubview:_locationLabel];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_skillLabel.mas_left);
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(5);
        }];
        
        _moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
        [self addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_skillLabel.mas_left);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(_locationLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        }];
        
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.width.mas_equalTo(@45);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        _countDownView = [[ZZChatStatusCountDownView alloc] init];
        _countDownView.hidden = YES;
        [self addSubview:_countDownView];
        
        [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_moreBtn.mas_left).offset(-10);
            make.bottom.mas_equalTo(_locationLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(82, 39));
        }];
        
        _btnView = [[ZZChatStatusBtnView alloc] init];
        _btnView.hidden = YES;
        [self addSubview:_btnView];
        
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_countDownView.mas_right);
            make.bottom.mas_equalTo(_locationLabel.mas_bottom);
        }];
        
        _moreImgView = [[UIImageView alloc] init];
        _moreImgView.image = [UIImage imageNamed:@"icon_chat_status_more"];
        _moreImgView.userInteractionEnabled = NO;
        [self addSubview:_moreImgView];
        
        self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 1;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        recognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:recognizer];
        
        _coverBtn = [[UIButton alloc] init];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_coverBtn];
        
        [_coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_btnView.mas_left);
            make.right.mas_equalTo(_btnView.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.top.mas_equalTo(self.mas_top);
        }];
    }
    
    return self;
}

- (void)setData:(ZZOrder *)order
{
    _order = order;
    BOOL isFrom = [[ZZUserHelper shareInstance].loginer.uid isEqualToString:order.from.uid];
    
    [self managerStatus];
    NSString *skillString = [NSString stringWithFormat:@"项目：%@",order.skill.name];
    _skillLabel.attributedText = [self getAttributedStringWithString:skillString range:[skillString rangeOfString:order.skill.name]];
    NSString *timeString = @"";
    if (isNullString(order.dated_at_text)) {
        if (order.exceed_dated_at) {
            timeString = [NSString stringWithFormat:@"时间：%@", order.exceed_dated_at_show];
            _timeLabel.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[NSString stringWithFormat:@"%@",order.exceed_dated_at_show]]];
        } else if (order.dated_at_type == 1) {
            NSString *string = [[ZZDateHelper shareInstance] getQuickTimeStringWithDate:order.dated_at];
            if (isNullString(string)) {
                string = [NSString stringWithFormat:@"%@",[[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]];
                timeString = [NSString stringWithFormat:@"时间：%@",string];
            } else {
                string = [NSString stringWithFormat:@"%@%@", kOrderQuickTimeString,string];
                timeString = [NSString stringWithFormat:@"时间：%@", string];
            }
            _timeLabel.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[NSString stringWithFormat:@"%@",string]]];
        } else {
            timeString = [NSString stringWithFormat:@"时间：%@",[[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]];
            _timeLabel.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]]];
        }
    } else {
        timeString = [NSString stringWithFormat:@"时间：%@",order.dated_at_text];
        _timeLabel.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:order.dated_at_text]];
    }
    NSString *cityString = @"";
    NSRange cityRange = [order.address rangeOfString:order.city.name];
    if (cityRange.location != NSNotFound) {
        cityString = [NSString stringWithFormat:@"%@",order.address];
    } else {
        cityString = [NSString stringWithFormat:@"%@%@",order.city.name,order.address];
    }
    NSString *localString = [NSString stringWithFormat:@"地点：%@",([NSString isBlank:cityString] || [cityString isEqualToString:@"(null)"]) ? @"" : cityString];
    _locationLabel.attributedText = [self getAttributedStringWithString:localString range:[localString rangeOfString:([NSString isBlank:cityString] || [cityString isEqualToString:@"(null)"]) ? @"" : cityString]];
    
    double totalPriceD = order.totalPrice.doubleValue;
    
//    NSNumber *totalPrice = [NSNumber numberWithDouble:totalPriceD];
    NSString *payStatusString = _order.status_desc;
    NSString *moneyStr = [NSString stringWithFormat:@"金额：%d小时 共%.2f元（%@）",order.hours, totalPriceD, payStatusString];
    NSRange range = [moneyStr rangeOfString:[NSString stringWithFormat:@"%.2f元",totalPriceD]];
    NSRange range1 = [moneyStr rangeOfString:payStatusString];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [string addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range];
    [string addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range1];
    _moneyLabel.attributedText = string;
    
    CGFloat maxWidth = SCREEN_WIDTH - 45 - 10 - 15 - 5 - 10;
    CGFloat localWith = [ZZUtils widthForCellWithText:_locationLabel.text fontSize:12];
    NSString *widthString = @"哈哈哈哈";
    if (!isFrom && _detailType == OrderDetailTypePending) {
        _moreBtn.hidden = YES;
        _moreImgView.hidden = YES;
        widthString = @"哈哈哈哈哈";
    } else {
        _moreBtn.hidden = NO;
        _moreImgView.hidden = NO;
    }
    
    if (isFrom && _detailType == OrderDetailTypePaying) {
        _countDownView.hidden = NO;
        _btnView.hidden = YES;
        _coverBtn.hidden = YES;
        [_countDownView setData:_order type:_detailType];
        
        [_moreImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_countDownView.mas_centerY);
            make.left.mas_equalTo(_moreBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(35.5, 37.5));
        }];
        
        maxWidth = maxWidth - 82;
        if (localWith > maxWidth) {
            [_locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(maxWidth);
            }];
        } else {
            [_locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(localWith);
            }];
        }
    } else {
        CGFloat width = [ZZUtils widthForCellWithText:widthString fontSize:14] + 12;
        [_btnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        maxWidth = maxWidth - width;
        
        if (localWith > maxWidth) {
            [_locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(maxWidth);
            }];
        } else {
            [_locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(localWith);
            }];
        }
        
        _countDownView.hidden = YES;
        _btnView.hidden = NO;
        _coverBtn.hidden = NO;
        [_btnView setData:_order detaiType:_detailType];
        
        [_moreImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btnView.mas_centerY);
            make.left.mas_equalTo(_moreBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(35.5, 37.5));
        }];
    }
}

- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string range:(NSRange)range
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kGrayContentColor range:range];
    
    return attributedString;
}

#pragma mark - UIButtonMethod

- (void)moreBtnClick
{
    if (_touchMoreBtn) {
        _touchMoreBtn();
    }
}

- (void)tapSelf
{
    if (_touchStatusView) {
        _touchStatusView();
    }
}

- (void)coverBtnClick
{
    if (_btnView.userInteractionEnabled == NO) {
        [self tapSelf];
    } else {
        if (_touchStatusBtn) {
            _touchStatusBtn();
        }
    }
}

#pragma mark -

- (void)managerStatus {
    if ([_order.status isEqualToString:@"pending"]) {
        _detailType = OrderDetailTypePending;
    }
    if ([_order.status isEqualToString:@"cancel"]) {
        _detailType = OrderDetailTypeCancel;
    }
    if ([_order.status isEqualToString:@"refused"]) {
        _detailType = OrderDetailTypeRefused;
    }
    if ([_order.status isEqualToString:@"paying"]) {
        _detailType = OrderDetailTypePaying;
    }
    if ([_order.status isEqualToString:@"meeting"]) {
        _detailType = OrderDetailTypeMeeting;
    }
    if ([_order.status isEqualToString:@"commenting"]) {
        _detailType = OrderDetailTypeCommenting;
    }
    if ([_order.status isEqualToString:@"commented"]) {
        _detailType = OrderDetailTypeCommented;
    }
    if ([_order.status isEqualToString:@"appealing"]) {
        _detailType = OrderDetailTypeAppealing;
    }
    if ([_order.status isEqualToString:@"refunding"]) {
        _detailType = OrderDetailTypeRefunding;
    }
    if ([_order.status isEqualToString:@"refundHanding"]) {
        _detailType = OrderDetailTypeRefundHanding;
    }
    if ([_order.status isEqualToString:@"refusedRefund"]) {
        _detailType = OrderDetailTypeRefusedRefund;
    }
    if ([_order.status isEqualToString:@"refunded"]) {
        _detailType = OrderDetailTypeRefunded;
    }
}

@end
