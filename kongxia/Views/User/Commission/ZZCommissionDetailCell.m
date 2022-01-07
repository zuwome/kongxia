//
//  ZZCommissionDetailCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionDetailCell.h"
#import "ZZCommissionListModel.h"

@interface ZZCommissionDetailCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UILabel *title1Label;

@property (nonatomic, strong) UILabel *orderCounts1Label;

@property (nonatomic, strong) UILabel *todayIncome1Label;

@property (nonatomic, strong) UILabel *title2Label;

@property (nonatomic, strong) UILabel *orderCounts2Label;

@property (nonatomic, strong) UILabel *todayIncome2Label;

@property (nonatomic, strong) UILabel *title3Label;

@property (nonatomic, strong) UILabel *orderCounts3Label;

@property (nonatomic, strong) UILabel *todayIncome3Label;

@property (nonatomic, strong) UILabel *title4Label;

@property (nonatomic, strong) UILabel *orderCounts4Label;

@property (nonatomic, strong) UILabel *todayIncome4Label;

@property (nonatomic, strong) UILabel *title5Label;

@property (nonatomic, strong) UILabel *orderCounts5Label;

@property (nonatomic, strong) UILabel *todayIncome5Label;

@property (nonatomic, strong) UILabel *title6Label;

@property (nonatomic, strong) UILabel *orderCounts6Label;

@property (nonatomic, strong) UILabel *todayIncome6Label;

@property (nonatomic, strong) UILabel *title7Label;

@property (nonatomic, strong) UILabel *orderCounts7Label;

@property (nonatomic, strong) UILabel *todayIncome7Label;

@property (nonatomic, strong) UILabel *title8Label;

@property (nonatomic, strong) UILabel *orderCounts8Label;

@property (nonatomic, strong) UILabel *todayIncome8Label;

@end

@implementation ZZCommissionDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureUserModel:(ZZCommissionUserModel *)model {
    
    if (model.to.gender == 1) {
        _title1Label.hidden = YES;
        _orderCounts1Label.hidden = YES;
        _todayIncome1Label.hidden = YES;
        [_title2Label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bgView).offset(15);
            make.left.equalTo(_bgView).offset(15);
        }];
    }
    else {
        _title1Label.hidden = NO;
        _orderCounts1Label.hidden = NO;
        _todayIncome1Label.hidden = NO;
        [_title2Label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title1Label.mas_bottom).offset(10);
            make.left.equalTo(_title1Label);
        }];
    }
    _title1Label.text = @"申请成为达人";
    _title2Label.text = @"查看微信";
    _title3Label.text = @"被查看微信";
    _title4Label.text = @"线下邀约";
    _title5Label.text = @"被线下邀约";
    _title6Label.text = @"发布通告";
    _title7Label.text = @"送出礼物";
    _title8Label.text = @"收到礼物";
    
    if (model.to.rent.status == 2) {
        _orderCounts1Label.text = @"是";
    }

    else if (model.to.rent.status == 1) {
        _orderCounts1Label.text = @"待审核";
    }
    else {
        _orderCounts1Label.text = @"否";
    }
    _orderCounts2Label.text = [NSString stringWithFormat:@"共%ld单", model.see_wechat_count];
    _orderCounts3Label.text = [NSString stringWithFormat:@"共%ld单", model.be_see_wechat_count];
    _orderCounts4Label.text = [NSString stringWithFormat:@"共%ld单", model.order_count];
    _orderCounts5Label.text = [NSString stringWithFormat:@"共%ld单", model.be_order_count];
    _orderCounts6Label.text = [NSString stringWithFormat:@"共%ld单", model.pd_count];
    _orderCounts7Label.text = [NSString stringWithFormat:@"共%ld单", model.gift_count];
    _orderCounts8Label.text = [NSString stringWithFormat:@"共%ld单", model.be_gift_count];
    
    _todayIncome1Label.text = @"";
    _todayIncome2Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_see_wechat_count, model.today_see_wechat_money];
    _todayIncome3Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_be_see_wechat_count, model.today_be_see_wechat_money];
    _todayIncome4Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_order_count, model.today_order_money];
    _todayIncome5Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_be_order_count, model.today_be_order_money];
    _todayIncome6Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_pd_count, model.today_pd_money];
    _todayIncome7Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_gift_count, model.today_gift_money];
    _todayIncome8Label.text = [NSString stringWithFormat:@"今日%ld单 ¥%.2f", model.today_be_gift_count, model.today_be_gift_money];
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [_bgView addSubview:self.seperateLine];
    [_bgView addSubview:self.title1Label];
    [_bgView addSubview:self.title2Label];
    [_bgView addSubview:self.title3Label];
    [_bgView addSubview:self.title4Label];
    [_bgView addSubview:self.title5Label];
    [_bgView addSubview:self.title6Label];
    [_bgView addSubview:self.title7Label];
    [_bgView addSubview:self.title8Label];
    
    [_bgView addSubview:self.orderCounts1Label];
    [_bgView addSubview:self.orderCounts2Label];
    [_bgView addSubview:self.orderCounts3Label];
    [_bgView addSubview:self.orderCounts4Label];
    [_bgView addSubview:self.orderCounts5Label];
    [_bgView addSubview:self.orderCounts6Label];
    [_bgView addSubview:self.orderCounts7Label];
    [_bgView addSubview:self.orderCounts8Label];
    
    [_bgView addSubview:self.todayIncome1Label];
    [_bgView addSubview:self.todayIncome2Label];
    [_bgView addSubview:self.todayIncome3Label];
    [_bgView addSubview:self.todayIncome4Label];
    [_bgView addSubview:self.todayIncome5Label];
    [_bgView addSubview:self.todayIncome6Label];
    [_bgView addSubview:self.todayIncome7Label];
    [_bgView addSubview:self.todayIncome8Label];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView);
        make.left.equalTo(_bgView).offset(15);
        make.right.equalTo(_bgView).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [_title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_bgView).offset(15);
    }];
    
    [_title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title1Label.mas_bottom).offset(10);
    }];
    
    [_title3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title2Label.mas_bottom).offset(10);
    }];
    
    [_title4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title3Label.mas_bottom).offset(10);
    }];
    
    [_title5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title4Label.mas_bottom).offset(10);
    }];
    
    [_title6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title5Label.mas_bottom).offset(10);
    }];
    
    [_title7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title6Label.mas_bottom).offset(10);
    }];
    
    [_title8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title1Label);
        make.top.equalTo(_title7Label.mas_bottom).offset(10);
        make.bottom.equalTo(_bgView).offset(-15);
    }];
    
    [_orderCounts1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title1Label);
        make.left.equalTo(_bgView).offset(135);
    }];
    
    [_orderCounts2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title2Label);
        make.left.equalTo(_orderCounts1Label);
    }];
    
    [_orderCounts3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title3Label);
        make.left.equalTo(_orderCounts2Label);
    }];
    
    [_orderCounts4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title4Label);
        make.left.equalTo(_orderCounts2Label);
    }];
    
    [_orderCounts5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title5Label);
        make.left.equalTo(_orderCounts2Label);
    }];
    
    [_orderCounts6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title6Label);
        make.left.equalTo(_orderCounts2Label);
    }];
    
    [_orderCounts7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title7Label);
        make.left.equalTo(_orderCounts2Label);
    }];
    
    [_orderCounts8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title8Label);
        make.left.equalTo(_orderCounts2Label);
    }];
    
    [_todayIncome1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title1Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title2Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title3Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title4Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title5Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title6Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title7Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    [_todayIncome8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_title8Label);
        make.right.equalTo(_bgView).offset(-15);
    }];
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _seperateLine;
}

- (UILabel *)title1Label {
    if (!_title1Label) {
        _title1Label = [[UILabel alloc] init];
        _title1Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title1Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title1Label;
}

- (UILabel *)title2Label {
    if (!_title2Label) {
        _title2Label = [[UILabel alloc] init];
        _title2Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title2Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title2Label;
}

- (UILabel *)title3Label {
    if (!_title3Label) {
        _title3Label = [[UILabel alloc] init];
        _title3Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title3Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title3Label;
}

- (UILabel *)title4Label {
    if (!_title4Label) {
        _title4Label = [[UILabel alloc] init];
        _title4Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title4Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title4Label;
}

- (UILabel *)title5Label {
    if (!_title5Label) {
        _title5Label = [[UILabel alloc] init];
        _title5Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title5Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title5Label;
}

- (UILabel *)title6Label {
    if (!_title6Label) {
        _title6Label = [[UILabel alloc] init];
        _title6Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title6Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title6Label;
}

- (UILabel *)title7Label {
    if (!_title7Label) {
        _title7Label = [[UILabel alloc] init];
        _title7Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title7Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title7Label;
}

- (UILabel *)title8Label {
    if (!_title8Label) {
        _title8Label = [[UILabel alloc] init];
        _title8Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _title8Label.textColor = RGBCOLOR(190, 190, 190);
    }
    return _title8Label;
}

- (UILabel *)orderCounts1Label {
    if (!_orderCounts1Label) {
        _orderCounts1Label = [[UILabel alloc] init];
        _orderCounts1Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts1Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts1Label;
}

- (UILabel *)orderCounts2Label {
    if (!_orderCounts2Label) {
        _orderCounts2Label = [[UILabel alloc] init];
        _orderCounts2Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts2Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts2Label;
}

- (UILabel *)orderCounts3Label {
    if (!_orderCounts3Label) {
        _orderCounts3Label = [[UILabel alloc] init];
        _orderCounts3Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts3Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts3Label;
}

- (UILabel *)orderCounts4Label {
    if (!_orderCounts4Label) {
        _orderCounts4Label = [[UILabel alloc] init];
        _orderCounts4Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts4Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts4Label;
}

- (UILabel *)orderCounts5Label {
    if (!_orderCounts5Label) {
        _orderCounts5Label = [[UILabel alloc] init];
        _orderCounts5Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts5Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts5Label;
}

- (UILabel *)orderCounts6Label {
    if (!_orderCounts6Label) {
        _orderCounts6Label = [[UILabel alloc] init];
        _orderCounts6Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts6Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts6Label;
}

- (UILabel *)orderCounts7Label {
    if (!_orderCounts7Label) {
        _orderCounts7Label = [[UILabel alloc] init];
        _orderCounts7Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts7Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts7Label;
}

- (UILabel *)orderCounts8Label {
    if (!_orderCounts8Label) {
        _orderCounts8Label = [[UILabel alloc] init];
        _orderCounts8Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _orderCounts8Label.textColor = RGBCOLOR(102, 102, 102);
    }
    return _orderCounts8Label;
}

- (UILabel *)todayIncome1Label {
    if (!_todayIncome1Label) {
        _todayIncome1Label = [[UILabel alloc] init];
        _todayIncome1Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome1Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome1Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome1Label;
}

- (UILabel *)todayIncome2Label {
    if (!_todayIncome2Label) {
        _todayIncome2Label = [[UILabel alloc] init];
        _todayIncome2Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome2Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome2Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome2Label;
}

- (UILabel *)todayIncome3Label {
    if (!_todayIncome3Label) {
        _todayIncome3Label = [[UILabel alloc] init];
        _todayIncome3Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome3Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome3Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome3Label;
}

- (UILabel *)todayIncome4Label {
    if (!_todayIncome4Label) {
        _todayIncome4Label = [[UILabel alloc] init];
        _todayIncome4Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome4Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome4Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome4Label;
}

- (UILabel *)todayIncome5Label {
    if (!_todayIncome5Label) {
        _todayIncome5Label = [[UILabel alloc] init];
        _todayIncome5Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome5Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome5Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome5Label;
}

- (UILabel *)todayIncome6Label {
    if (!_todayIncome6Label) {
        _todayIncome6Label = [[UILabel alloc] init];
        _todayIncome6Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome6Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome6Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome6Label;
}

- (UILabel *)todayIncome7Label {
    if (!_todayIncome7Label) {
        _todayIncome7Label = [[UILabel alloc] init];
        _todayIncome7Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome7Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome7Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome7Label;
}

- (UILabel *)todayIncome8Label {
    if (!_todayIncome8Label) {
        _todayIncome8Label = [[UILabel alloc] init];
        _todayIncome8Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _todayIncome8Label.textColor = RGBCOLOR(102, 102, 102);
        _todayIncome8Label.textAlignment = NSTextAlignmentRight;
    }
    return _todayIncome8Label;
}

@end
