//
//  ZZOrderARPriceCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARPriceCell.h"
@interface ZZOrderARPriceCell()<UITextViewDelegate>
/**
 退款金额
 */
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UIView *lineView;
/**
 退
 */
@property(nonatomic,strong) UILabel *greatRefundLab;
@end
@implementation ZZOrderARPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self.bgView addSubview:self.priceTF];
        [self.bgView addSubview:self.priceLab];
        [self.contentView addSubview:self.greatRefundLab];
    }
    return self;
}
- (void)setOrder:(ZZOrder *)order showInputMoney:(BOOL)showInput responsible:(BOOL)responsible percent:(double)percent {
    if (showInput) {
        _priceTF.hidden = NO;
       if (responsible) {
            //已经付全款,用户的原因
           NSString *text = [NSString stringWithFormat:@"退款金额：￥"];
           NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
           NSRange range = [text rangeOfString:@"退款金额："];
           [attrString addAttribute:NSFontAttributeName
                              value:ADaptedFontBoldSize(15)
                              range:NSMakeRange(range.length, text.length - range.length)];
           [attrString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(252, 27, 87) range:NSMakeRange(range.length, text.length - range.length)];
           [self.priceLab setAttributedText:attrString];
           //不同订单类型，金额和服务费要分开计算
           //order.type    1.下单     退还金额 = 单价(price)*小时(hours)*百分比(percent)
           //              3.派单线下  退还金额 = (总价(totalPrice) - 服务费)*百分比(percent)
           double price = 0.0;
           if (order.type == 1) {
               price = [order.price doubleValue] * order.hours * percent;
               self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥%.02f(平台服务费不予退还)",price];
               self.priceTF.text = [NSString stringWithFormat:@"%.02f",price];
           }
           else {
               price = [order.price doubleValue] * percent;
               if ([order isNewTask]) {
                    self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥%.02f",price];
                    self.priceTF.text = [NSString stringWithFormat:@"%.02f",price];
               }
               else {
                   price = [order.price doubleValue] * percent;
                   self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥%.02f(发布服务费%.0f元不予退还)",price, order.totalPrice.doubleValue - order.price.doubleValue];
                   self.priceTF.text = [NSString stringWithFormat:@"%.02f",price];
               }
           }
        }
       else {
            //是达人的原因且用户付全款
            NSString *text = [NSString stringWithFormat:@"退款金额：￥"];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            NSRange range = [text rangeOfString:@"退款金额："];
            [attrString addAttribute:NSFontAttributeName
                               value:ADaptedFontBoldSize(15)
                               range:NSMakeRange(range.length, text.length - range.length)];
            [attrString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(252, 27, 87) range:NSMakeRange(range.length, text.length - range.length)];
            [self.priceLab setAttributedText:attrString];
            //不同订单类型，金额和服务费要分开计算
            //order.type    1.下单     围绕单价(price)计算，达人费用 = 单价(price)*小时(hours)*百分比(percent)， 服务费 = 总价(totalPrice)-达人费用
            //              3.派单线下  围绕总价(totalPrice)计算，服务费 = 总价(totalPrice)*佣金百分比， 达人费用 = 总价(totalPrice)-服务费
            double price = 0.0;
            double serviceFee = 0.0;
            if (order.type == 1) {  //1.下单
                price = [order.price doubleValue] * order.hours * percent;
                serviceFee = [order.totalPrice doubleValue] - price;
                if (order.wechat_service) {
                    serviceFee -= order.wechat_price;
                }
                else {
                    serviceFee -= order.xdf_price.doubleValue;
                }
                self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥%.02f元, 平台服务费￥%.2f也将退还给你",price, serviceFee];
            }
            else {
                //3.派单线下，其余情况不会进入退款流程，故不多做判断
//                double yj = [ZZUserHelper shareInstance].configModel.yj.order_from;    //订单佣金抽取百分比
                serviceFee = 0;//[order.totalPrice doubleValue] * yj;
                price = [order.price doubleValue] - serviceFee;
                self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥%.02f(发布服务费不予退还))",price];
            }
            self.priceTF.text = [NSString stringWithFormat:@"%.02f",price];
        }
        
        CGFloat width = [NSString findWidthForText:self.priceTF.text havingWidth:220 andFont:[UIFont systemFontOfSize:15]];
        width += 20;
        
        [self.priceTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
        }];
        
    }
    else {
        if (responsible &&[order.status isEqualToString:@"paying"]) {
            //是自己的原因且没有付款
            self.priceLab.text = [NSString stringWithFormat:@"退款金额：￥0"];
            self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥0"];
        } else if([order.status isEqualToString:@"paying"]) {
            //是达人的原因且用户没有付全款
            self.priceLab.text = [NSString stringWithFormat:@"退款金额：￥%.02f",order.deposit];
            self.greatRefundLab.text = [NSString stringWithFormat:@"最多￥%.02f",order.deposit];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.equalTo(@50);
    }];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.bgView);
    }];
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.priceLab.mas_right);
        make.width.equalTo(@220);
    }];
    [self.greatRefundLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom);
        make.height.equalTo(@24.5);
        make.left.offset(14.5);
        make.right.offset(-14.5);
    }];
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc]init];
        _priceLab.textColor = kBlackColor;
        _priceLab.textAlignment = NSTextAlignmentLeft;
        _priceLab.font = CustomFont(15);
        _priceLab.text = @"退款金额：￥";
    }
    return _priceLab;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UITextField *)priceTF {
    if (!_priceTF) {
        _priceTF = [[UITextField alloc]init];
        _priceTF.placeholder = @"请填写";
         _priceTF.font = CustomFont(15);
        [_priceTF setValue:RGBCOLOR(128, 128, 128) forKeyPath:@"placeholderLabel.textColor"];
        [_priceTF setValue:CustomFont(15) forKeyPath:@"placeholderLabel.font"];
        _priceTF.textColor = RGBCOLOR(252, 27, 87);
        _priceTF.textAlignment = NSTextAlignmentLeft;
        _priceTF.hidden = YES;
        _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"icon_video_edit"];
        _priceTF.rightView = imageView;
        _priceTF.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return _priceTF;
}
- (UILabel *)greatRefundLab {
    if (!_greatRefundLab) {
        _greatRefundLab = [[UILabel alloc]init];
        _greatRefundLab.textColor = RGBCOLOR(128, 128, 128);
        _greatRefundLab.textAlignment = NSTextAlignmentLeft;
        _greatRefundLab.font = CustomFont(12);
    }
    return _greatRefundLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
