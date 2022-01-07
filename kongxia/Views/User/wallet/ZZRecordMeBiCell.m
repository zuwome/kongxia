//
//  ZZRecordMeBiCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRecordMeBiCell.h"

@implementation ZZRecordMeBiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            _timeLabel = [[UILabel alloc] init];
            _timeLabel.textAlignment = NSTextAlignmentLeft;
            _timeLabel.textColor = kGrayContentColor;
            _timeLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_timeLabel];
          
            _recordTitleLab = [[UILabel alloc] init];
            _recordTitleLab.textColor = [UIColor blackColor];
            _recordTitleLab.textAlignment = NSTextAlignmentLeft;
            _recordTitleLab.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_recordTitleLab];
            
            _moneyLabel = [[UILabel alloc] init];
            _moneyLabel.textAlignment = NSTextAlignmentRight;
            _moneyLabel.textColor = [UIColor blackColor];
            _moneyLabel.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_moneyLabel];
        
            
            _imgView = [[UIImageView alloc] init];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:_imgView];
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_right).offset(AdaptedWidth(9));
                make.top.mas_equalTo(self.contentView.mas_centerY);
                make.bottom.mas_equalTo(_imgView.mas_bottom);
            }];
            [_recordTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_timeLabel.mas_left);
                make.top.mas_equalTo(_imgView.mas_top);
                make.bottom.mas_equalTo(self.contentView.mas_centerY);
            }];
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            }];
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(15);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(AdaptedWidth(40), AdaptedWidth(40)));
            }];
            
            UIView *view = [[UIView alloc]init];
            [self.contentView addSubview:view];
            view.backgroundColor = RGBCOLOR(237, 237, 237);
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.right.offset(-15);
                make.bottom.mas_equalTo(self.contentView.mas_bottom);
                make.height.mas_equalTo(0.5);
            }];
        }
    return self;
}

/**
 么币记录
 */
- (void)setRecordModel:(ZZMeBiRecordModel *)recordModel {
    _recordModel = recordModel;
    if ([recordModel.mcoin_record[@"type"] isEqualToString:@"qchat"]) {
        //视频消费
        self.imgView.image = [UIImage imageNamed:@"icShipin"];
    } else if ([recordModel.mcoin_record[@"type"]  isEqualToString:@"chatcharge"]) {
        self.imgView.image = [UIImage imageNamed:@"icSixinZhangdanMebijilu"];
    } else if ([recordModel.mcoin_record[@"type"] isEqualToString:@"systemSend"]) {
        self.imgView.image = [UIImage imageNamed:@"icXitongZhangdanMebijilu"];
    } else if ([recordModel.mcoin_record[@"type"] isEqualToString: @"integralExchange"]) {
        self.imgView.image = [UIImage imageNamed:@"icJifenWalletMbjl"];
    }
    else if ([recordModel.mcoin_record[@"type"] isEqualToString: @"get_from_wechat_voucher"]) {
        self.imgView.image = [UIImage imageNamed:@"wechatC"];
    }
    
    else {
        if ([recordModel.mcoin_record[@"channel"] isEqualToString:@"in_app_purchase"]) {
            //内购
            self.imgView.image = [UIImage imageNamed:@"icApplePay"];
        } else if ([recordModel.mcoin_record[@"channel"] isEqualToString:@"wx_pub"]||[recordModel.mcoin_record[@"channel"] isEqualToString:@"wx"]) {
            //微信公众号 或者 微信支付
            self.imgView.image = [UIImage imageNamed:@"wechatC"];
        } else if ([recordModel.mcoin_record[@"channel"] isEqualToString:@"alipay"]) {
            //支付宝
            self.imgView.image = [UIImage imageNamed:@"alipayC"];
        } else if ([recordModel.mcoin_record[@"type"] isEqualToString:@"pay_for_wechat"]) {
            //么币购买微信号（iOS 3.4.4走内购）
            self.imgView.image = [UIImage imageNamed:@"wechatC"];
        }
        else if ([recordModel.mcoin_record[@"type"] isEqualToString:@"pay_for_idphoto"]) {
            // 么币购买查看微信
            self.imgView.image = [UIImage imageNamed:@"icCkzjz"];
        }
        else if ([recordModel.mcoin_record[@"type"] isEqualToString:@"song_gift"]) {
            // 点唱
            self.imgView.image = [UIImage imageNamed:@"icDianchangrenwu"];
        }
        else {
            //我的钱包
            self.imgView.image = [UIImage imageNamed:@"icDefault"];
        }
        
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@么币",recordModel.mcoin_record[@"amount"]];
    self.recordTitleLab.text = [NSString stringWithFormat:@"%@",recordModel.mcoin_record[@"type_text"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",recordModel.mcoin_record[@"created_at_text"]];
    if ([recordModel.mcoin_record[@"type"] isEqualToString: @"get_from_wechat_voucher"]) {
        self.moneyLabel.text = @"抵用卷";
    }
}


/**
 余额记录
 */
- (void)setRecordMoneyModel:(ZZRecord *)recordMoneyModel {
    
    _recordMoneyModel = recordMoneyModel;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",recordMoneyModel.amount];
    self.recordTitleLab.text = [NSString stringWithFormat:@"%@",recordMoneyModel.content];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",recordMoneyModel.created_at];
    if ([recordMoneyModel.type isEqualToString:@"order"]||[recordMoneyModel.type isEqualToString:@"pd_pay_deposit_refund"]||[recordMoneyModel.type isEqualToString:@"pd_pay_deposit"]||[recordMoneyModel.type isEqualToString:@"transfer"]) {
        //订单    派单退预付款 派单预付款
        self.imgView.image = [UIImage imageNamed:@"icDate"];

    }
    else if ([recordMoneyModel.type isEqualToString:@"recharge"]) {
       //充值
       if ([recordMoneyModel.channel isEqualToString:@"wx"]) {
           //微信
           self.imgView.image = [UIImage imageNamed:@"wechatC"];
       }
       else {
           self.imgView.image = [UIImage imageNamed:@"alipayC"];
       }
   }
   else if ([recordMoneyModel.type isEqualToString:@"private_mmd_refund"]||[recordMoneyModel.type isEqualToString:@"private_mmd_pay"]||[recordMoneyModel.type isEqualToString:@"private_mmd_answer"]||[recordMoneyModel.type isEqualToString:@"mmd_tip_jl"]||[recordMoneyModel.type isEqualToString:@"mmd_refund"]||[recordMoneyModel.type isEqualToString:@"mmd_answer"]||[recordMoneyModel.type isEqualToString:@"mmd_tip_to"]||[recordMoneyModel.type isEqualToString:@"mmd_tip"]||[recordMoneyModel.type isEqualToString:@"mmd_pay"]||[recordMoneyModel.type isEqualToString:@"sk_tip"]||[recordMoneyModel.type isEqualToString:@"sk_tip_to"]||[recordMoneyModel.type isEqualToString:@"rp_pay"]||[recordMoneyModel.type isEqualToString:@"rp_take"]||[recordMoneyModel.type isEqualToString:@"sys_rp_refund"]||[recordMoneyModel.type isEqualToString:@"rp_refund"]) {
       //私信红包退款   //私信红包   //私信红包
            self.imgView.image = [UIImage imageNamed:@"icRedPackets"];
   }
   else if ([recordMoneyModel.type isEqualToString:@"pay_for_wechat"]||[recordMoneyModel.type isEqualToString:@"get_from_wechat"]) {
       //查看微信号
       self.imgView.image = [UIImage imageNamed:@"wechatC"];

   }
   else if ([recordMoneyModel.type isEqualToString:@"qchat"]){
       self.imgView.image = [UIImage imageNamed:@"Chat_icShipinChat"];
   }
   else if ([recordMoneyModel.type isEqualToString:@"chatcharge"]) {
       self.imgView.image = [UIImage imageNamed:@"icSixinZhangdanMebijilu"];
   }
   else if ([recordMoneyModel.type isEqualToString:@"get_from_id_photo"]) {
       if ([recordMoneyModel.channel isEqualToString:@"pay_for_idphoto"]) {
           // 么币购买查看微信
           self.imgView.image = [UIImage imageNamed:@"icCkzjz"];
       }
   }
   else if ([recordMoneyModel.type isEqualToString:@"invite_price"]) {
       self.imgView.image = [UIImage imageNamed:@"icHhrfh"];
   }
   else {
       self.imgView.image = [UIImage imageNamed:@"icDefault"];
   }
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
