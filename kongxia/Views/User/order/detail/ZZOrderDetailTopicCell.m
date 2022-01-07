//
//  ZZOrderDetailTopicCell.m
//  zuwome
//
//  Created by angBiu on 16/7/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderDetailTopicCell.h"
#import "ZZDateHelper.h"
@interface ZZOrderDetailTopicCell()
@property (nonatomic, strong) UIView *bgView;//头像
@property (nonatomic,strong) UILabel *refundResponsibilityLab;//退款责任
@end
@implementation ZZOrderDetailTopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
  
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
   
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8).priority(1000);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8).priority(1000);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
      
        [self.bgView addSubview:self.headImgView];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.identifierImgView];
        [self.bgView addSubview:self.infoLabel];
        [self.bgView addSubview:self.moneyLabel];
        [self.bgView addSubview:self.skillLabel];
        [self.bgView addSubview:self.capitalFlowsLabel];
        [self.bgView addSubview:self.lineView];
//        [self.bgView addSubview:self.vLabel];
        [self.bgView addSubview:self.hourLabel];
        [self.bgView addSubview:self.dayLabel];
        [self.bgView addSubview:self.locationLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.textColor = kBlackColor;
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        [self.bgView addSubview:_distanceLabel];
        
        _locationBtn = [[UIButton alloc] init];
        [_locationBtn setImage:[UIImage imageNamed:@"rentDiDian"] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"rentDiDian"] forState:UIControlStateHighlighted];
        [_locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_locationBtn];
        
        [self.bgView addSubview:self.refundResponsibilityLab];
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.textAlignment = NSTextAlignmentLeft;
        _reasonLabel.textColor = kBlackColor;
        _reasonLabel.font = [UIFont systemFontOfSize:13];
        _reasonLabel.numberOfLines = 0;
        [self.bgView addSubview:_reasonLabel];
        
        _refundMoneyLabel = [[UILabel alloc] init];
        _refundMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _refundMoneyLabel.textColor = kBlackColor;
        _refundMoneyLabel.font = [UIFont systemFontOfSize:13];
        [self.bgView addSubview:_refundMoneyLabel];
        [self.bgView addSubview:self.responsibilityLabel];
        [self.bgView addSubview:self.responsibilityDetailLabel];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(7);
            make.top.mas_equalTo(self.bgView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(10);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
//        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_headImgView.mas_bottom).offset(-5);
//            make.left.equalTo(_nameLabel.mas_left);
//        }];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImgView.mas_bottom).offset(10);
            make.left.equalTo(_headImgView);
        }];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_skillLabel.mas_bottom).offset(10);
            make.left.equalTo(_headImgView);
        }];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_moneyLabel.mas_right).offset(7);
            make.centerY.equalTo(_moneyLabel);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [_capitalFlowsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_moneyLabel);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
        }];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(7);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-7);
            make.top.equalTo(_moneyLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(0.5);
        }];
        
        [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lineView.mas_bottom).offset(15);
            make.left.mas_equalTo(_lineView.mas_left);
            make.height.equalTo(@21);
        }];
        
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_lineView.mas_right);
            make.centerY.mas_equalTo(_hourLabel.mas_centerY);
        }];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hourLabel.mas_left);
            make.top.mas_equalTo(_hourLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-10).priority(10);//
            make.height.equalTo(@21);
        }];
        
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_dayLabel.mas_right);
            make.top.mas_equalTo(_locationLabel.mas_top);
        }];
        
        [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_distanceLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(_distanceLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
      
        [self.refundResponsibilityLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_lineView.mas_left);
            make.right.mas_equalTo(_lineView.mas_right);
            make.top.mas_equalTo(_locationLabel.mas_bottom).offset(10);
        }];
       
        [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_lineView.mas_left);
            make.right.mas_equalTo(_lineView.mas_right);
            make.top.mas_equalTo(self.refundResponsibilityLab.mas_bottom).offset(10).priority(600);
            make.top.mas_equalTo(_locationLabel.mas_bottom).offset(10).priority(300);;
        }];

        [_refundMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_reasonLabel.mas_left);
            make.right.mas_equalTo(_reasonLabel.mas_right);
            make.top.mas_equalTo(_reasonLabel.mas_bottom).offset(10);
            make.top.equalTo(self.refundResponsibilityLab.mas_bottom).offset(10).priority(50);
        }];
        
        [self.responsibilityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_left);
            make.right.equalTo(self.responsibilityDetailLabel.mas_left);
            make.top.equalTo(self.refundMoneyLabel.mas_bottom).offset(13);
            make.width.equalTo(@65);
        }];
        
        [self.responsibilityDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.distanceLabel.mas_right);
            make.top.equalTo(self.refundMoneyLabel.mas_bottom).offset(13);
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

#pragma mark - UIButtonMethod

- (void)locationBtnClick {
    if (_locationClick) {
        _locationClick();
    }
}

- (void)headImgViewClick {
    if (_tapAvatarClick) {
        _tapAvatarClick();
    }
}

- (void)capitalFlowAction:(UITapGestureRecognizer *)recognizer {
    if (recognizer.view.tag == 1) {
        if (_capitalFlowProtocolClick) {
            _capitalFlowProtocolClick();
        }
    }
}

#pragma mark - PrivateMethod
- (void)setOrder:(ZZOrder *)order type:(OrderDetailType)type moneyFlowDescript:(NSString *)moneyFlowDescript from:(BOOL)from {
    _skillLabel.text = [NSString stringWithFormat:@"主题：%@/%d小时", order.skill.name,order.hours];
    
    double totalPrice = order.totalPrice.doubleValue;
    
//    if (order.wechat_service && [order.from.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
//        totalPrice += order.wechat_price;
//    }
//    else {
//        if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:order.from.uid]) {
//            totalPrice += order.xdf_price.doubleValue;
//        }
//    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",[ZZUtils dealAccuracyNumber:[NSNumber numberWithDouble:totalPrice]]];
    _distanceLabel.text = order.distance?order.distance:@" ";
    CGFloat width = [ZZUtils widthForCellWithText:order.distance fontSize:12];

    [_locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH - width - 30 - 5 - 30);
    }];

    if (from) {
        [_headImgView setUser:order.to width:50 vWidth:12];
        _nameLabel.text = order.to.nickname;
        if ([ZZUtils isIdentifierAuthority:order.to]) {
            _identifierImgView.hidden = NO;
        }
        else {
            _identifierImgView.hidden = YES;
        }
        
        if (order.to.weibo.verified) {
            _vLabel.hidden = NO;
            _vLabel.text = [NSString stringWithFormat:@"认证: %@",order.to.weibo.verified_reason];
        }
        else {
            _vLabel.hidden = YES;
        }
        
        ZZOrderRefundDepositModel *modelInfo = order.refund.refund_text.refund_from_text;
        if (modelInfo.explain_title && order.accepted_at) {
            self.responsibilityDetailLabel.text = modelInfo.explain_detail;
            self.responsibilityLabel.text = [NSString stringWithFormat:@"%@:",modelInfo.explain_title];
            [UILabel changeLineSpaceForLabel:_responsibilityDetailLabel WithSpace:5];
        }
    }
    else {
        [_headImgView setUser:order.from width:50 vWidth:12];
        _nameLabel.text = order.from.nickname;
        if ([ZZUtils isIdentifierAuthority:order.from]) {
            _identifierImgView.hidden = NO;
        }
        else {
            _identifierImgView.hidden = YES;
        }
        
        if (order.from.weibo.verified) {
            _vLabel.hidden = NO;
            _vLabel.text = [NSString stringWithFormat:@"认证: %@",order.from.weibo.verified_reason];
        }
        else {
            _vLabel.hidden = YES;
        }
        
        ZZOrderRefundDepositModel *modelInfo = order.refund.refund_text.refund_to_text;
         if (modelInfo.explain_title&&order.accepted_at) {
             self.responsibilityDetailLabel.text = modelInfo.explain_detail;
             self.responsibilityLabel.text =  [NSString stringWithFormat:@"%@:",modelInfo.explain_title];
             [UILabel changeLineSpaceForLabel:_responsibilityDetailLabel WithSpace:5];
         }
    }
 
    if (order) {
        if (isNullString(order.dated_at_text2)) {
            if (order.exceed_dated_at) {
                _hourLabel.text = [NSString stringWithFormat:@"时间：%@", order.exceed_dated_at_show];
                _dayLabel.text = nil;
            }
            else if (order.dated_at_type == 1) {
                NSString *string = [[ZZDateHelper shareInstance] getQuickTimeStringWithDate:order.dated_at];
                if (isNullString(string)) {
                    _hourLabel.text = [NSString stringWithFormat:@"时间：%@", [[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]];
                }
                else {
                    _hourLabel.text = [NSString stringWithFormat:@"时间：%@%@", kOrderQuickTimeString,string];
                }
                _dayLabel.text = [[ZZDateHelper shareInstance] getOrderTimeStringWithDateString:order.dated_at_string];
            }
            else {
                _hourLabel.text = [NSString stringWithFormat:@"时间：%@", [[ZZDateHelper shareInstance] getOrderDetailTimeStringWithDateString:order.dated_at_string]];
                _dayLabel.text = [[ZZDateHelper shareInstance] getOrderTimeStringWithDateString:order.dated_at_string];
            }
        }
        else {
            _hourLabel.text = [NSString stringWithFormat:@"时间：%@", order.dated_at_text2];
            _dayLabel.text = [[ZZDateHelper shareInstance] getOrderTimeStringWithDateString:order.dated_at_string];
        }
    }
    
    NSString *cityString = nil;
    NSRange cityRange = [order.address rangeOfString:order.city.name];
    if (cityRange.location != NSNotFound) {
        cityString = [NSString stringWithFormat:@"%@",order.address];
    }
    else {
        cityString = [NSString stringWithFormat:@"%@%@",order.city.name,order.address];
    }
    NSString *localString = [NSString stringWithFormat:@"地点：%@",cityString];
    _locationLabel.text = localString;
    
    [_refundMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_reasonLabel.mas_bottom).offset(10);
    }];
    
//    if (isNullString(moneyFlowDescript)) {
//        if (type == OrderDetailTypeRefunded) {
//            if ([order.refund.refund_text.refund_from_text.responsibility isEqual:@"你选择自己责任退款"]) {
//                // 用户自己的责任
//                NSString *des = [NSString stringWithFormat:@"%@%@", [ZZUtils dealAccuracyNumber:order.refund.amount], from ? @"元已退回钱包" : @"元已退回对方钱包"];
//                _capitalFlowsLabel.text = des;
//            }
//            else {
//                // 达人的责任
//                _capitalFlowsLabel.text = [NSString stringWithFormat:@"%@元%@",order.refund.amount, from ? @"已退回您的钱包" : @"已退回对方的钱包"];//;
//            }
//        }
//        else if (type == OrderDetailTypeCommenting || type == OrderDetailTypeCommented || type == OrderDetailTypeRefusedRefund) {
//            _capitalFlowsLabel.text = !from ? @"已转入您的钱包" : @"已转入对方钱包";
//        }
//        else if (type == OrderDetailTypeCancel) {
////            NSString *des = [NSString stringWithFormat:@"%@%@", [ZZUtils dealAccuracyNumber:@(order.deposit)], from ? @"元已退回钱包" : @"元已退回对方钱包"];
////            _capitalFlowsLabel.text = des;
//        }
//        else {
//            NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:@"平台担保支付中"];
//            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName,
//                                           RGBCOLOR(63, 58, 58),NSForegroundColorAttributeName,nil];
//            [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
//
//            //添加图片
//            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//            attach.image = [UIImage imageNamed:@"rectangle896"];
//            attach.bounds = CGRectMake(5, -2, 6, 12);
//            NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
//            [attributeStr1 appendAttributedString:attributeStr2];
//            _capitalFlowsLabel.attributedText = attributeStr1;
//
//            _capitalFlowsLabel.tag = 1;
//        }
//    }
//    else {
//        if ([moneyFlowDescript isEqualToString:@"平台担保支付中"]) {
//            NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:moneyFlowDescript];
//            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName,
//                                           RGBCOLOR(63, 58, 58),NSForegroundColorAttributeName,nil];
//            [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
//
//            //添加图片
//            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//            attach.image = [UIImage imageNamed:@"rectangle896"];
//            attach.bounds = CGRectMake(5, -2, 6, 12);
//            NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
//            [attributeStr1 appendAttributedString:attributeStr2];
//            _capitalFlowsLabel.attributedText = attributeStr1;
//
//            _capitalFlowsLabel.tag = 1;
//        }
//        else {
//            if (type != OrderDetailTypeCancel) {
//                _capitalFlowsLabel.text = moneyFlowDescript;
//            }
//
//        }
//    }
    
    switch (type) {
        case OrderDetailTypeRefunding:
        case OrderDetailTypeRefundHanding:
        case OrderDetailTypeRefusedRefund: {
            if (order.refund.remarks) {
                _reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.refund.remarks];
            } else {
                _reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.reason];
            }
            if (isNullString(order.refund.remarks)&&isNullString(order.reason)) {
                _reasonLabel.text = @"退款理由：无";
            }
            [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];
            _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：%@元", [ZZUtils dealAccuracyNumber:order.refund.price]];
            if (from) {
                ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_from_text;
                if (!isNullString(depositModel.responsibility)) {
                    self.refundResponsibilityLab.text =
                    [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
                }
            }
            else{
                ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_to_text;
                if (!isNullString(depositModel.responsibility)) {
                    self.refundResponsibilityLab.text =
                    [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
                    [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];
                }
            }
            break;
        }
        case OrderDetailTypeAppealing: {
            _reasonLabel.text = nil;
            _refundMoneyLabel.text = nil;
            if (from&&order.accepted_at) {
//                //是订单的发起方
                ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_from_text;
                if (!isNullString(depositModel.responsibility)) {
                    self.refundResponsibilityLab.text =
                    [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
                    [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];
                }
                _reasonLabel.text = [NSString stringWithFormat:@"申诉理由：%@",order.reason];
                [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];
            }
            else if(order.accepted_at) {
                //达人看退意向金
                ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_to_text;
                _reasonLabel.text = [NSString stringWithFormat:@"申诉理由：%@",order.refund.refuse_reason];
                [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];

                if (!isNullString(depositModel.responsibility)) {
                    self.refundResponsibilityLab.text =
                    [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
                    [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];
                }
            }
            _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：%@元", [ZZUtils dealAccuracyNumber:order.refund.price]];
            break;
        }
        case OrderDetailTypeRefunded: {
            if (from&&order.accepted_at) {
                //是订单的发起方
                ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_from_text;
                if (!isNullString(depositModel.responsibility)) {
                    self.refundResponsibilityLab.text =
                    [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
                    [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];
                }
                _reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.refund.remarks];
                [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];

            }
            else if(order.accepted_at) {
                //达人看退意向金
                ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_to_text;
                if (!isNullString(depositModel.responsibility)) {
                    self.refundResponsibilityLab.text =
                    [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
                    [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];
                }
                if (!isNullString(order.reason)) {
                    _reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.reason];
                    [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];
                }
            }

            if (isNullString(order.appeal.remarks)&&isNullString(order.refund.remarks)) {
                _reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.reason?order.reason:@"无"];
                [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];
            }
            _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：%@元", order.appeal.amount?[ZZUtils dealAccuracyNumber:order.appeal.amount]:[ZZUtils dealAccuracyNumber:order.refund.amount]];
            break;
        }
        case OrderDetailTypeCancel: {
            [self isfrom:from order:order];
            break;
        }
        default: {
            [_refundMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_reasonLabel.mas_bottom).offset(-10);
            }];

            _reasonLabel.text = @"";
            _refundMoneyLabel.text = @"";
            break;
        }
    }
   
    CGFloat height =  [ZZUtils heightForCellWithText:_reasonLabel.text fontSize:13 labelWidth:SCREEN_WIDTH -14];
    [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    
//    //后台客服目前没有统一的  文案  就先隐藏了
//    if (!isNullString(order.refund.appeal_result)) {
//        _appealResultLabel.text = [NSString stringWithFormat:@"平台处理结果: %@", order.refund.appeal_result];
//    }
}

/**
 @param from 是否是订单发起方
 */
- (void)isfrom:(BOOL)from order:(ZZOrder *)order{
    _reasonLabel.text = @"";
    _refundMoneyLabel.text = @"";
    if (from&&order.accepted_at) {
        //是订单的发起方
        ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_from_text;
        if (!isNullString(order.reason)) {
            self.reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.reason];
            [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];

        }
        if (!isNullString(depositModel.responsibility)) {
            self.refundResponsibilityLab.text =
            [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
            [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];

        }
        if (order.paid_at) {
            _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：%@元",[ZZUtils dealAccuracyNumber:order.refund.amount]];
        }else{
            if (order.isFromCancel) {
                //用户原因取消的退意向金
                _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：0元"];
            }
            else{
                _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：%.02f元",order.deposit];
            }
        }
        
        
    }else if(order.accepted_at){
        //达人看退意向金
        ZZOrderRefundDepositModel *depositModel = order.refund.refund_text.refund_to_text;
        if (!isNullString(order.reason)) {
            self.reasonLabel.text = [NSString stringWithFormat:@"退款理由：%@",order.reason];
            [UILabel changeLineSpaceForLabel:_reasonLabel WithSpace:5];
        }
        if (!isNullString(depositModel.responsibility)) {
            self.refundResponsibilityLab.text =
            [NSString stringWithFormat:@"退款责任：%@",depositModel.responsibility];
            [UILabel changeLineSpaceForLabel:_refundResponsibilityLab WithSpace:5];
        }
         _refundMoneyLabel.text = [NSString stringWithFormat:@"退款金额：%@元",[ZZUtils dealAccuracyNumber:order.refund.amount]];
    }
    else{
        [_refundMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_reasonLabel.mas_bottom).offset(-10);
        }];
    }
}
- (UIView *)bgView {
    if (!_bgView ) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);
        _bgView.layer.shadowOpacity = 0.9;
        _bgView.layer.shadowRadius = 1;
    }
    return _bgView;
}

- (UIImageView *)identifierImgView {
    if (!_identifierImgView) {
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
    }
    return _identifierImgView;
}
/**
 责任说明
 */
- (UILabel *)responsibilityLabel {
    if (!_responsibilityLabel) {
        _responsibilityLabel = [[UILabel alloc]init];
        _responsibilityLabel.textColor = kBlackColor;
        _responsibilityLabel.font = CustomFont(13);
        _responsibilityLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _responsibilityLabel;
}

/**
 责任说明
 */
- (UILabel *)responsibilityDetailLabel {
    if (!_responsibilityDetailLabel) {
        _responsibilityDetailLabel = [[UILabel alloc]init];
        _responsibilityDetailLabel.textColor = kBlackColor;
        _responsibilityDetailLabel.font = CustomFont(13);
        _responsibilityDetailLabel.numberOfLines = 0;
        _responsibilityDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _responsibilityDetailLabel;
}

/**
 只有退款的时候才有  退款责任
 */
- (UILabel *)refundResponsibilityLab {
    if (!_refundResponsibilityLab) {
        _refundResponsibilityLab = [[UILabel alloc]init];
        _refundResponsibilityLab.font = CustomFont(13);
        _refundResponsibilityLab.textColor = kBlackColor;
        _refundResponsibilityLab.textAlignment = NSTextAlignmentLeft;
    }
    return _refundResponsibilityLab;
}
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.text = @"?";
        _infoLabel.layer.cornerRadius = 8;
        _infoLabel.backgroundColor = HEXCOLOR(0xd8d8d8);
        _infoLabel.clipsToBounds = YES;
    }
    return _infoLabel;
}

/**
 用户的名字
 */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackColor;
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

/**
 分割线
 */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kGrayTextColor;
    }
    return _lineView;
}
/**
 主题,出租的技能

 */
- (UILabel *)skillLabel {
    if (!_skillLabel) {
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textAlignment = NSTextAlignmentLeft;
        _skillLabel.textColor = kGrayTextColor;
        _skillLabel.font = [UIFont systemFontOfSize:13];
    }
    return _skillLabel;
}
/**
 订单的金额
 */
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.font = [UIFont systemFontOfSize:16];
    }
    return _moneyLabel;
}

- (UILabel *)vLabel {
    if (!_vLabel) {
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.textColor = kBlackColor;
        _vLabel.font = [UIFont systemFontOfSize:12];
        _vLabel.numberOfLines = 0;
    }
    return _vLabel;
}

/**
 邀约时间
 */
- (UILabel *)hourLabel {
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentLeft;
        _hourLabel.textColor = kBlackColor;
        _hourLabel.font = [UIFont systemFontOfSize:13];
    }
    return _hourLabel;
}

/**
 地理位置
 */
- (UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.textColor = kBlackColor;
        _locationLabel.font = [UIFont systemFontOfSize:13];
        _locationLabel.numberOfLines = 0;
    }
    return _locationLabel;
}

/**
 邀约天数
 */
-(UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentRight;
        _dayLabel.textColor = kBlackColor;
        _dayLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dayLabel;
}

/**
 用户的头像
 */
- (ZZHeadImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgViewClick)];
        recognizer.numberOfTapsRequired = 1;
        [_headImgView addGestureRecognizer:recognizer];
    }
    return _headImgView;
}

- (UILabel *)capitalFlowsLabel {
    if (!_capitalFlowsLabel) {
        _capitalFlowsLabel = [[UILabel alloc] init];
        _capitalFlowsLabel.textAlignment = NSTextAlignmentLeft;
        _capitalFlowsLabel.textColor = kBlackColor;
        _capitalFlowsLabel.font = [UIFont systemFontOfSize:13];
        _capitalFlowsLabel.numberOfLines = 0;
        _capitalFlowsLabel.hidden = YES;
//        _capitalFlowsLabel.text = @"平台担保";
        _capitalFlowsLabel.userInteractionEnabled = YES;
        _capitalFlowsLabel.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(capitalFlowAction:)];
        [_capitalFlowsLabel addGestureRecognizer:tap];
        
    }
    return _capitalFlowsLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
