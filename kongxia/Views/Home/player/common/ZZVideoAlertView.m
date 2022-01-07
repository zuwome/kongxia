//
//  ZZVideoAlertView.m
//  zuwome
//
//  Created by angBiu on 16/8/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZVideoAlertView.h"
#import "ZZRechargeViewController.h"
#import "ZZRealNameListViewController.h"

//#import "TPKeyboardAvoidingScrollView.h"

#import "Pingpp.h"

@interface ZZVideoAlertView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *randomView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *randomBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIImageView *downImgView;
@property (nonatomic, strong) UIView *payTypeBgView;
@property (nonatomic, strong) UIView *priceBgView;
@property (nonatomic, strong) UILabel *packetPriceLabel;
@property (nonatomic, strong) UILabel *servicePriceLabel;

@end

@implementation ZZVideoAlertView
{
    UIView                  *_bgView;
    UILabel                 *_infoLabel;
    UIButton                *_tempBtn;
    ZZUser                  *_toUser;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _moneyArray = @[@"5.2",@"6.6",@"8.8",@"9.9",@"12",@"15",@"18"];
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = kBlackTextColor;
        coverView.alpha = 0.7;
        [self addSubview:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:_scrollView];
        
        UIView *scrollBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_scrollView addSubview:scrollBgView];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
        [scrollBgView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollBgView.mas_left).offset(30);
            make.right.mas_equalTo(scrollBgView.mas_right).offset(-30);
            make.centerY.mas_equalTo(scrollBgView.mas_centerY);
        }];
        
        _randomBtn = [[UIButton alloc] init];
        [_randomBtn setTitle:@"随机金额" forState:UIControlStateNormal];
        [_randomBtn setTitleColor:HEXCOLOR(0x2F86CE) forState:UIControlStateNormal];
        _randomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_randomBtn addTarget:self action:@selector(randomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_randomBtn];
        
        [_randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(15);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
//        [self.downBtn addTarget:self action:@selector(showPriceInfoView) forControlEvents:UIControlEventTouchUpInside];
        
        _payTypeBgView = [[UIView alloc] init];
        _payTypeBgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_payTypeBgView];
        
        [_payTypeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left);
            make.right.mas_equalTo(_bgView.mas_right);
            make.top.mas_equalTo(self.inputView.mas_bottom).offset(30);
            make.height.mas_equalTo(@37);
        }];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_payTypeBgView.mas_bottom).offset(15);
        }];
        
        NSArray *normalArray = @[@"icon_rent_pay_wx_n",@"icon_rent_pay_wallet_n",@"icon_rent_pay_zfb_n"];
        NSArray *selectedArray = @[@"icon_rent_pay_wx_p",@"icon_rent_pay_wallet_p",@"icon_rent_pay_zfb_p"];
        
        CGFloat typeWidth = 35;
        CGFloat typeHeight = 35;
        
        CGFloat space = ((SCREEN_WIDTH - 60)/3 - typeWidth)/2;
        
        for (int i=0; i<normalArray.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setImage:[UIImage imageNamed:normalArray[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(payTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 200+i;
            [_payTypeBgView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_payTypeBgView.mas_left).offset(space + i*(SCREEN_WIDTH - 60)/3);
                make.centerY.mas_equalTo(_payTypeBgView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(typeWidth, typeHeight));
            }];
            
            if (i == [self managerLastPayType]) {
                btn.selected = YES;
                _tempBtn = btn;
                [self showInfoText];
            }
            
            if (i != normalArray.count - 1) {
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = kLineViewColor;
                [_payTypeBgView addSubview:lineView];
                
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(btn.mas_right).offset(space);
                    make.centerY.mas_equalTo(_payTypeBgView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(1.5, 37));
                }];
            }
        }
        
        _payBtn = [[UIButton alloc] init];
        _payBtn.backgroundColor = kRedTextColor;
        _payBtn.layer.cornerRadius = 3;
        [_payBtn setTitle:@"发红包" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_payBtn];
        
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_infoLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-20);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left);
            make.top.mas_equalTo(_bgView.mas_top);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        self.randomView.hidden = YES;
        self.inputView.hidden = NO;
        
        [self addGestures];
        [self addNotification];
        
        [_bgView bringSubviewToFront:cancelBtn];
        
//        if (![ZZUserHelper shareInstance].configModel.yj) {
//            self.downBtn.userInteractionEnabled = NO;
//        }
    }
    
    return self;
}

- (void)addGestures
{
    UITapGestureRecognizer *bgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
    [self addGestureRecognizer:bgRecognizer];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)randomMoney
{
    NSInteger index = arc4random() % _moneyArray.count;
    _moneyLabel.text = _moneyArray[index];
}

- (void)randomInputText
{
    NSInteger index = arc4random() % _moneyArray.count;
    _inputTF.text = _moneyArray[index];
}

- (void)setUser:(ZZUser *)user
{
    _toUser = user;
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.hidden) {
        return;
    }
    [self hidePriceInfoView];
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = [_bgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if (ISiPhone4) {
        _scrollView.contentOffset = CGPointMake(0, (SCREEN_HEIGHT - height)/2 - 20);
    } else {
        _scrollView.contentOffset = CGPointMake(0, rect.size.height + 5 - (SCREEN_HEIGHT - height)/2);
    }
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    if (self.hidden) {
        return;
    }
    _scrollView.contentOffset = CGPointMake(0, 0);
}


#pragma mark - UIButtonMethod

- (void)tapSelf
{
    [self endEditing:YES];
}

- (void)editBtnClick
{
    [_inputTF becomeFirstResponder];
    _randomView.hidden = YES;
    _inputView.hidden = NO;
    [self calculatePrice];
}

- (void)randomBtnClick
{
    [self randomMoney];
    _randomView.hidden = NO;
    _inputView.hidden = YES;
    [self endEditing:YES];
    [self calculatePrice];
}

- (void)payTypeBtnClick:(UIButton *)sender
{
    [self endEditing:YES];
    if (sender == _tempBtn) {
        return;
    }
    
    _tempBtn.selected = NO;
    sender.selected = YES;
    _tempBtn = sender;
    [self showInfoText];
}




/**
 发送红包给对方
 */
- (void)sendRedPacket {
    if (_randomView.hidden) {
        _price = [_inputTF.text doubleValue];
    } else {
        _price = [_moneyLabel.text doubleValue];
    }
    if (!_price || _price == 0) {
        [ZZHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    if (_randomView.hidden) {
        switch (_type) {
            case AlertPayTypeDashang:
            {
                if ([ZZUserHelper shareInstance].configModel) {
                    if (_price < [[ZZUserHelper shareInstance].configModel.mmd.tip_min_price floatValue] || _price > 2000) {
                        [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"打赏金额请设置在%@～2000内",[ZZUserHelper shareInstance].configModel.mmd.tip_min_price]];
                        return;
                    }
                } else {
                    if (_price < 2 || _price > 2000) {
                        [ZZHUD showErrorWithStatus:@"打赏金额请设置在2～2000内"];
                        return;
                    }
                }
            }
                break;
            case AlertPayTypeMemeda:
            {
                if ([ZZUserHelper shareInstance].configModel) {
                    if (_price < [[ZZUserHelper shareInstance].configModel.mmd.public_min_price floatValue] || _price > 2000) {
                        [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"公开提问金额请设置在%@～2000内",[ZZUserHelper shareInstance].configModel.mmd.public_min_price]];
                        return;
                    }
                } else {
                    if (_price < 5 || _price > 2000) {
                        [ZZHUD showErrorWithStatus:@"公开提问金额请设置在5～2000内"];
                        return;
                    }
                }
            }
                break;
            case AlertPayTypePacket:
            {
                if ([ZZUserHelper shareInstance].configModel) {
                    if (_price < [[ZZUserHelper shareInstance].configModel.mmd.private_min_price floatValue] || _price > 2000) {
                        [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"红包金额请设置在%@～2000内",[ZZUserHelper shareInstance].configModel.mmd.private_min_price]];
                        return;
                    }
                } else {
                    if (_price < 6 || _price > 2000) {
                        [ZZHUD showErrorWithStatus:@"红包金额请设置在6～2000内"];
                        return;
                    }
                }
            }
                break;
            default:
                break;
        }
    }
    
    if (_tempBtn.tag - 200 == 1) {
        if (_price > [[ZZUserHelper shareInstance].loginer.balance doubleValue]) {
            [UIAlertView showWithTitle:@"钱包当前余额不足" message:nil cancelButtonTitle:@"其他支付方式" otherButtonTitles:@[@"马上充值"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self gotoRechargeView];
                }
            }];
            return;
        }
        
        BOOL isRealName = [ZZUtils isIdentifierAuthority:[ZZUserHelper shareInstance].loginer];
        if (!isRealName) {
            //没有实名认证的
            [self isRealName];
            return;
        }
    }
    

    _payBtn.userInteractionEnabled = NO;
    switch (_type) {
        case AlertPayTypeMemeda:
        {
            [self addMemeda];
        }
            break;
        case AlertPayTypePacket:
        {
            [self addPrivateMememda];
        }
            break;
        case AlertPayTypeDashang:
        {
            [self payDashang:[self getChannel]];
        }
            break;
        default:
            break;
    }
}


/**
 弹出提示去实名认证
 */
- (void)isRealName {
    self.hidden = YES;
    [UIAlertController presentAlertControllerWithTitle:@"提示" message:@"您尚未实名认证，为保障您的账户\n资金安全，需要您先去实名认证" doneTitle:@"认证" cancelTitle:@"取消" completeBlock:^(BOOL isCancelIndex) {

        if (!isCancelIndex) {
            ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.user = [ZZUserHelper shareInstance].loginer;
            controller.isRentPerfectInfo = YES;
            WS(weakSelf);
            controller.blackBlock = ^{
                weakSelf.hidden = NO;
            };
            [self.ctl.navigationController pushViewController:controller animated:YES];
        }else{
            self.hidden = NO;
        }
    }];
    
}
/**
 发红包
 */
- (void)payBtnClick
{
    [self endEditing:YES];
    
    [self sendRedPacket];
    

}

- (void)gotoRechargeView
{
    [self cancelBtnClick];
    if (_fromLiveStream) {
        return;
    }
    WeakSelf;
    [MobClick event:Event_click_money_recharge];
    ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
    controller.rechargeCallBack = ^{
        if (weakSelf.rechargeCallBack) {
            weakSelf.rechargeCallBack();
        }
    };
    controller.leftCallBack = ^{
        weakSelf.hidden = NO;
    };
    [_ctl.navigationController pushViewController:controller animated:YES];
}

- (void)cancelBtnClick
{
    _payBtn.userInteractionEnabled = YES;
    [self endEditing:YES];
    self.hidden = YES;
    if (_touchCancel) {
        _touchCancel();
    }
}

- (void)showPriceInfoView
{
    [self endEditing:YES];
    if (self.priceBgView.hidden) {
        _downImgView.transform = CGAffineTransformMakeRotation(M_PI);
        self.priceBgView.hidden = NO;
//        CGFloat height = [self.priceBgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [self.payTypeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inputView.mas_bottom).offset(20+25);
        }];
    } else {
        [self hidePriceInfoView];
    }
}

- (void)hidePriceInfoView
{
    _downImgView.transform = CGAffineTransformMakeRotation(2* M_PI);
//    self.priceBgView.hidden = YES;
    [self.payTypeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputView.mas_bottom).offset(30);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - PrivateMethod

- (void)showFirstResponder
{
    if (_randomView.hidden) {
        [_inputTF becomeFirstResponder];
    }
}

- (NSInteger)managerLastPayType
{
    NSString *method = [ZZUserHelper shareInstance].lastPayMethod;
    if ([method isEqualToString:@"packet"]) {
        return 1;
    } else if ([method isEqualToString:@"weixin"]) {
        return 0;
    } else if ([method isEqualToString:@"zhifubao"]) {
        return 2;
    } else {
        return 0;
    }
}

- (void)showInfoText
{
    switch (_tempBtn.tag - 200) {
        case 0:
        {
            _infoLabel.text = @"使用微信支付";
            _infoLabel.textColor = HEXCOLOR(0x72C448);
        }
            break;
        case 1:
        {
            CGFloat money = [[ZZUserHelper shareInstance].loginer.balance floatValue];
            _infoLabel.text = [NSString stringWithFormat:@"钱包余额 ¥%.2f",money];
            _infoLabel.textColor = kYellowColor;
        }
            break;
        case 2:
        {
            _infoLabel.text = @"使用支付宝支付";
            _infoLabel.textColor = HEXCOLOR(0x51B6EC);
        }
            break;
        default:
            break;
    }
}

- (NSString *)getChannel
{
    NSString *channel = @"";
    switch (_tempBtn.tag - 200) {
        case 0:
        {
            channel = @"wx";
        }
            break;
        case 1:
        {
            channel = @"wallet";
        }
            break;
        case 2:
        {
            channel = @"alipay";
        }
            break;
        default:
            break;
    }
    
    return channel;
}

- (void)calculatePrice
{
//    if (!_priceBgView) {
//        self.priceBgView.hidden = YES;
//    }
    double price = 0;
    if (_inputView.hidden) {
        price = [_moneyLabel.text doubleValue];
    } else {
        price = [_inputTF.text doubleValue];
    }
    _packetPriceLabel.text = [NSString stringWithFormat:@"%.2f",price*(1-_serviceScale)];
    _servicePriceLabel.text = [NSString stringWithFormat:@"%.2f",price*_serviceScale];
}

#pragma mark - pay

- (void)addMemeda
{
    [ZZHUD showWithStatus:@"正在提交..."];
    NSMutableDictionary *param = [@{@"content":_content,
                                    @"total_price":[NSNumber numberWithFloat:_price],
                                    @"type":[NSNumber numberWithInteger:1],
                                    @"is_anonymous":[NSNumber numberWithBool:_isAnonymous]} mutableCopy];
    if (_topicsArray.count) {
        [param setValue:_topicsArray forKey:@"groups"];
    }
    if (_isInYellow) {
        [param setObject:@"2" forKey:@"content_check_status"];
    } else {
        [param setObject:@"1" forKey:@"content_check_status"];
    }
    
    ZZMemedaModel *memedaModel = [[ZZMemedaModel alloc] init];
    [memedaModel addMemedaWithParam:param uid:_toUser.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            _payBtn.userInteractionEnabled = YES;
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showWithStatus:@"正在准备付款..."];
            ZZMMDModel *mmdModel = [[ZZMMDModel alloc] initWithDictionary:data error:nil];
            [self payMemedaWithChannel:[self getChannel] model:mmdModel];
        }
    }];
}

- (void)addPrivateMememda
{
    [ZZHUD showWithStatus:@"正在提交..."];
    NSMutableDictionary *param = [@{@"content":_content,
                                @"total_price":[NSNumber numberWithFloat:_price],
                                       @"type":[NSNumber numberWithInteger:2]} mutableCopy];
    if (_isInYellow) {
        [param setObject:@"2" forKey:@"content_check_status"];
    } else {
        [param setObject:@"1" forKey:@"content_check_status"];
    }
    ZZMemedaModel *memedaModel = [[ZZMemedaModel alloc] init];
    [memedaModel addMemedaWithParam:param uid:_toUser.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            _payBtn.userInteractionEnabled = YES;
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showWithStatus:@"正在准备付款..."];
            ZZMMDModel *mmdModel = [[ZZMMDModel alloc] initWithDictionary:data error:nil];
            [self payMemedaWithChannel:[self getChannel] model:mmdModel];
        }
    }];
}

- (void)payMemedaWithChannel:(NSString *)channel model:(ZZMMDModel *)model
{
    ZZMemedaModel *mmModel = [[ZZMemedaModel alloc] init];
    [mmModel payMemedaWithParam:@{@"channel":channel,@"pingxxtype": @"kxp",}
                          mid:model.mid
                         next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                             _payBtn.userInteractionEnabled = YES;
                             if (error) {
                                 [ZZHUD showErrorWithStatus:error.message];
                             } else {
                                 _mid = model.mid;
                                 if (![channel isEqualToString:@"wallet"]) {
                                     [ZZHUD dismiss];
                                     WeakSelf;
                                     // zuwome
                                     [Pingpp createPayment:data
                                            viewController:_ctl
                                              appURLScheme:@"kongxia"
                                            withCompletion:^(NSString *result, PingppError *error) {
                                                if ([result isEqualToString:@"success"]) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [weakSelf savePayMethod];
                                                        [weakSelf saveLastMemedaType];
                                                        [ZZUserHelper shareInstance].lastAskMoney = [NSString stringWithFormat:@"%.2f",weakSelf.price];
                                                    });
                                                } else {
                                                    // 支付失败或取消
                                                    [ZZHUD showErrorWithStatus:@"支付失败"];
                                                    NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                                }
                                            }];
                                 } else {
                                     [self savePayMethod];
                                     [self saveLastMemedaType];
                                     [ZZUserHelper shareInstance].lastAskMoney = [NSString stringWithFormat:@"%.2f",_price];
                                 }
                             }
                         }];
}

- (void)saveLastMemedaType
{
    if (_type == AlertPayTypePacket) {
        [ZZUserHelper shareInstance].lastAskType = @"private";
    } else {
        [ZZUserHelper shareInstance].lastAskType = @"publick";
    }
}

//打赏
- (void)payDashang:(NSString *)channel
{
    if (_mid) {
        ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
        [model dashangMememdaWithParam:@{@"channel":channel,
                                         @"tip_price":[NSNumber numberWithDouble:_price]}
                                   mid:_mid
                                  next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                      _payBtn.userInteractionEnabled = YES;
                                      if (error) {
                                          [ZZHUD showErrorWithStatus:error.message];
                                      } else {
                                          [self dashangCallBack:data channel:channel];
                                      }
                                  }];
    } else {
        [ZZSKModel dashangSkWithParam:@{@"channel":channel,
                                       @"tip_price":[NSNumber numberWithDouble:_price]}
                                 skId:_skId
                                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                     _payBtn.userInteractionEnabled = YES;
                                       if (error) {
                                           [ZZHUD showErrorWithStatus:error.message];
                                       } else {
                                           [self dashangCallBack:data channel:channel];
                                       }
                                   }];
    }
}

- (void)dashangCallBack:(id)data channel:(NSString *)channel
{
    if (![channel isEqualToString:@"wallet"]) {
        [ZZHUD dismiss];
        WeakSelf;
        
        NSMutableDictionary *muData = ((NSDictionary *)data).mutableCopy;
        muData[@"pingxxtype"] = @"kxp";
        
        [Pingpp createPayment:muData.copy
               viewController:_ctl
                 appURLScheme:@"kongxia"
               withCompletion:^(NSString *result, PingppError *error) {
                   if ([result isEqualToString:@"success"]) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [weakSelf savePayMethod];
                           [ZZHUD showSuccessWithStatus:@"谢谢您的打赏"];
                           [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",weakSelf.price];
                       });
                   } else {
                       // 支付失败或取消
                       [ZZHUD showErrorWithStatus:@"支付失败"];
                       NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                   }
               }];
    } else {
        [self savePayMethod];
        [ZZHUD showSuccessWithStatus:@"谢谢您的打赏"];
        [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
    }
}

- (void)savePayMethod
{
    if (_payCallBack) {
        _payCallBack();
    }
    [self cancelBtnClick];
    switch (_tempBtn.tag - 200) {
        case 0:
        {
            [ZZUserHelper shareInstance].lastPayMethod = @"weixin";
        }
            break;
        case 1:
        {
            [ZZUserHelper shareInstance].lastPayMethod = @"packet";
        }
            break;
        case 2:
        {
            [ZZUserHelper shareInstance].lastPayMethod = @"zhifubao";
        }
            break;
        default:
            break;
    }
}

#pragma mark - lazyload

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    return _scrollView;
}

- (UIView *)inputView
{
    WeakSelf;
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.clipsToBounds = YES;
        [_bgView addSubview:_inputView];
        
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_randomBtn.mas_bottom);
            make.left.mas_equalTo(_bgView.mas_left);
            make.right.mas_equalTo(_bgView.mas_right);
            make.height.mas_equalTo(@55);
        }];
        
        CGFloat width = [ZZUtils widthForCellWithText:@"60~2000" fontSize:30];
        
        _inputTF = [[ZZMoneyTextField alloc] init];
        _inputTF.pure = NO;
        _inputTF.textAlignment = NSTextAlignmentCenter;
        _inputTF.textColor = kBlackTextColor;
        _inputTF.font = [UIFont systemFontOfSize:30];
        _inputTF.placeholder = @"2~2000";
        _inputTF.clearButtonMode = UITextFieldViewModeNever;
        [_inputView addSubview:_inputTF];
        
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inputView.mas_top);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(width, 55));
        }];
        
        _inputTF.valueChanged = ^{
            [weakSelf calculatePrice];
        };
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.textAlignment = NSTextAlignmentRight;
        iconLabel.textColor = kBlackTextColor;
        iconLabel.font = [UIFont systemFontOfSize:25];
        iconLabel.text = @"¥";
        [_inputView addSubview:iconLabel];
        
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_inputTF.mas_left).offset(-8);
            make.centerY.mas_equalTo(_inputTF.mas_centerY);
        }];
    }
    
    return _inputView;
}

- (UIView *)randomView
{
    if (!_randomView) {
        _randomView = [[UIView alloc] init];
        _randomView.backgroundColor = [UIColor whiteColor];
        _randomView.clipsToBounds = YES;
        [_bgView addSubview:_randomView];
        
        [_randomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_inputView);
        }];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.textColor = kBlackTextColor;
        _moneyLabel.font = [UIFont systemFontOfSize:30];
        [_randomView addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_randomView.mas_centerX);
            make.centerY.mas_equalTo(_randomView.mas_centerY);
        }];
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.textAlignment = NSTextAlignmentRight;
        iconLabel.textColor = kBlackTextColor;
        iconLabel.font = [UIFont systemFontOfSize:25];
        iconLabel.text = @"¥";
        [_moneyLabel addSubview:iconLabel];
        
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_moneyLabel.mas_left).offset(-10);
            make.centerY.mas_equalTo(_moneyLabel.mas_centerY);
        }];
        
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setImage:[UIImage imageNamed:@"icon_video_alert_edit"] forState:UIControlStateNormal];
        [_randomView addSubview:editBtn];
        
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_moneyLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(_moneyLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self randomMoney];
    }
    
    return _randomView;
}

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] init];
        [_bgView addSubview:_downBtn];
        
        [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(self.inputView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(80, 15));
        }];
        
        _downImgView = [[UIImageView alloc] init];
        _downImgView.image = [UIImage imageNamed:@"icon_amountdetail_down"];
        _downImgView.userInteractionEnabled = NO;
        [_downBtn addSubview:_downImgView];
        
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_downBtn.mas_top);
            make.centerX.mas_equalTo(_downBtn.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(15.5, 8));
        }];
    }
    return _downBtn;
}

- (UIView *)priceBgView
{
    if (!_priceBgView) {
        _priceBgView = [[UIView alloc] init];
        [_bgView addSubview:_priceBgView];
        
        [_priceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bgView);
            make.top.mas_equalTo(_downBtn.mas_bottom);
        }];
        
        UILabel *packetTitleLabel = [[UILabel alloc] init];
        packetTitleLabel.textColor = kGrayTextColor;
        packetTitleLabel.font = [UIFont systemFontOfSize:12];
        packetTitleLabel.text = @"打赏金额";
        [_priceBgView addSubview:packetTitleLabel];
        
        [packetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_priceBgView.mas_left).offset((SCREEN_WIDTH - 60)/4.0);
            make.top.mas_equalTo(_priceBgView.mas_top);
        }];
        
        _packetPriceLabel = [[UILabel alloc] init];
        _packetPriceLabel.textAlignment = NSTextAlignmentCenter;
        _packetPriceLabel.textColor = kGrayTextColor;
        _packetPriceLabel.font = [UIFont systemFontOfSize:12];
        _packetPriceLabel.text = @"￥0.00";
        [_priceBgView addSubview:_packetPriceLabel];
        
        [_packetPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_priceBgView.mas_right).offset(-(SCREEN_WIDTH - 60)/4.0);
            make.centerY.mas_equalTo(packetTitleLabel.mas_centerY);
        }];
        
        UILabel *serviceTitleLabel = [[UILabel alloc] init];
        serviceTitleLabel.textColor = kGrayTextColor;
        serviceTitleLabel.font = [UIFont systemFontOfSize:12];
        serviceTitleLabel.text = @"平台服务费";
        [_priceBgView addSubview:serviceTitleLabel];
        
        [serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(packetTitleLabel.mas_left);
            make.top.mas_equalTo(packetTitleLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_priceBgView.mas_bottom);
        }];
        
        _servicePriceLabel = [[UILabel alloc] init];
        _servicePriceLabel.textAlignment = NSTextAlignmentCenter;
        _servicePriceLabel.textColor = kGrayTextColor;
        _servicePriceLabel.font = [UIFont systemFontOfSize:12];
        _servicePriceLabel.text = @"￥0.00";
        [_priceBgView addSubview:_servicePriceLabel];
        
        [_servicePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_packetPriceLabel.mas_left);
            make.centerY.mas_equalTo(serviceTitleLabel.mas_centerY);
        }];
    }
    return _priceBgView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
