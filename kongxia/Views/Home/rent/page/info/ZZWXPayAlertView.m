//
//  ZZWXPayAlertView.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZWXPayAlertView.h"
#import "ZZMoneyTextField.h"
#import "TTTAttributedLabel.h"
#import "Pingpp.h"

#import "ZZRechargeViewController.h"

@interface ZZWXPayAlertView () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) ZZMoneyTextField *inputTF;
@property (nonatomic, strong) UIView *payTypeBgView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) TTTAttributedLabel *changeLabel;
@property (nonatomic, assign) double price;

@end

@implementation ZZWXPayAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *coverBtn = [[UIButton alloc] init];
        coverBtn.backgroundColor = kBlackTextColor;
        coverBtn.alpha = 0.7;
        coverBtn.userInteractionEnabled = NO;
        [coverBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverBtn];
        
        [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.inputTF.text = @"30";
        _price = 30;
        self.payTypeBgView.backgroundColor = [UIColor whiteColor];
        self.payBtn.backgroundColor = kRedTextColor;
        NSString *string = @"支付红包后，TA的微信号将会发送至手机号码138XXXX666，快速更改";
        [self.changeLabel setText:@"支付红包后，TA的微信号将会发送至手机号码138XXXX666，快速更改" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:[string rangeOfString:@"快速更改"]];
            return mutableAttributedString;
        }];
        [self.changeLabel addLinkToURL:[NSURL URLWithString:@"快速更改"] withRange:[string rangeOfString:@"快速更改"]];
        
        [self addNotification];
    }
    
    return self;
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

- (void)setUser:(ZZUser *)user
{
    _user = user;
    if (user.wechat_price) {
        self.inputTF.text = [ZZUtils dealAccuracyDouble:user.wechat_price];
        _price = user.wechat_price;
    }
    if (user.phone) {
        NSString *string = [NSString stringWithFormat:@"支付红包后，TA的微信号将会发送至手机号码%@，快速更改",[ZZUtils encryptPhone:user.phone]];;
        [self.changeLabel setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:[string rangeOfString:@"快速更改"]];
            return mutableAttributedString;
        }];
        [self.changeLabel addLinkToURL:[NSURL URLWithString:@"快速更改"] withRange:[string rangeOfString:@"快速更改"]];
        [self showInfoText];
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
            self.infoLabel.text = @"使用微信支付";
            self.infoLabel.textColor = HEXCOLOR(0x72C448);
        }
            break;
        case 1:
        {
            CGFloat money = [[ZZUserHelper shareInstance].loginer.balance floatValue];
            self.infoLabel.text = [NSString stringWithFormat:@"钱包余额 ¥%.2f",money];
            self.infoLabel.textColor = kYellowColor;
        }
            break;
        case 2:
        {
            self.infoLabel.text = @"使用支付宝支付";
            self.infoLabel.textColor = HEXCOLOR(0x51B6EC);
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

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.hidden) {
        return;
    }
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

#pragma mark - 

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

- (void)payBtnClick {
    NSString *channel = [self getChannel];
    if ([channel isEqualToString:@"wallet"]) {
        if (_price > [[ZZUserHelper shareInstance].loginer.balance doubleValue]) {
            [UIAlertView showWithTitle:@"钱包当前余额不足" message:nil cancelButtonTitle:@"其他支付方式" otherButtonTitles:@[@"马上充值"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self gotoRechargeView];
                }
            }];
            return;
        }
    }
    [MobClick event:Event_click_userpage_wx_buy];
    [self endEditing:YES];
    [ZZHUD showWithStatus:@"支付中..."];
    NSDictionary *param = @{@"channel":channel,
                            @"price":[NSNumber numberWithDouble:_price],
                            @"pingxxtype": @"kxp",
                            };
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/wechat/pay",_uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if (![channel isEqualToString:@"wallet"]) {
                [ZZUserHelper shareInstance].charge_id = [data objectForKey:@"id"];
                [ZZHUD dismiss];
                WeakSelf;
                [Pingpp createPayment:data
                       viewController:_ctl
                         appURLScheme:@"kongxia"
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [weakSelf savePayMethod];
                               });
                           } else {
                               // 支付失败或取消
                               [ZZHUD showErrorWithStatus:@"支付失败"];
                               NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                           }
                       }];
            } else {
                [self savePayMethod];
            }
        }
    }];
}

- (void)savePayMethod
{
    [ZZHUD showWithStatus:@"支付成功，获取微信中..."];
    self.hidden = YES;
    if (_paySuccess) {
        _paySuccess([self getChannel]);
    }
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

- (void)cancelBtnClick
{
    [self endEditing:YES];
    self.hidden = YES;
}

- (void)gotoRechargeView
{
    [self cancelBtnClick];
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

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [self cancelBtnClick];
    if (_touchChangePhone) {
        _touchChangePhone();
    }
}

#pragma mark - lazyload

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        UIView *scrollBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.scrollView addSubview:scrollBgView];
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
        [scrollBgView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollBgView.mas_left).offset(30);
            make.right.mas_equalTo(scrollBgView.mas_right).offset(-30);
            make.centerY.mas_equalTo(scrollBgView.mas_centerY);
        }];
        
    }
    return _bgView;
}

- (ZZMoneyTextField *)inputTF
{
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.clipsToBounds = YES;
        [_bgView addSubview:_inputView];
        
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(25);
            make.left.mas_equalTo(_bgView.mas_left);
            make.right.mas_equalTo(_bgView.mas_right);
            make.height.mas_equalTo(@55);
        }];
        
        CGFloat width = [ZZUtils widthForCellWithText:@"2~2000" fontSize:30];
        
        _inputTF = [[ZZMoneyTextField alloc] init];
        _inputTF.pure = YES;
        _inputTF.textAlignment = NSTextAlignmentCenter;
        _inputTF.textColor = kBlackTextColor;
        _inputTF.font = [UIFont systemFontOfSize:30];
        _inputTF.clearButtonMode = UITextFieldViewModeNever;
        _inputTF.userInteractionEnabled = NO;
        [_inputView addSubview:_inputTF];
        
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inputView.mas_top);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(width, 55));
        }];
        
        _inputTF.valueChanged = ^{
//            [weakSelf calculatePrice];
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
    
    return _inputTF;
}

- (UIView *)payTypeBgView
{
    if (!_payTypeBgView) {
        _payTypeBgView = [[UIView alloc] init];
        _payTypeBgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_payTypeBgView];
        
        [_payTypeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left);
            make.right.mas_equalTo(_bgView.mas_right);
            make.top.mas_equalTo(self.inputView.mas_bottom).offset(30);
            make.height.mas_equalTo(@37);
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
    }
    return _payTypeBgView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_payTypeBgView.mas_bottom).offset(15);
        }];
    }
    return _infoLabel;
}

- (UIButton *)payBtn
{
    if (!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        _payBtn.layer.cornerRadius = 3;
        [_payBtn setTitle:@"发红包" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_payBtn];
        
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_infoLabel.mas_bottom).offset(25);
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.height.mas_equalTo(@44);
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
    }
    return _payBtn;
}

- (TTTAttributedLabel *)changeLabel
{
    if (!_changeLabel) {
        _changeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _changeLabel.backgroundColor = [UIColor clearColor];
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.textColor = kBlackTextColor;
        _changeLabel.font = [UIFont systemFontOfSize:12];
        _changeLabel.numberOfLines = 0;
        _changeLabel.delegate = self;
        _changeLabel.highlightedTextColor = [UIColor redColor];
        _changeLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _changeLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _changeLabel.userInteractionEnabled = YES;
        [_bgView addSubview:_changeLabel];
        
        [_changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.mas_equalTo(_payBtn.mas_bottom).offset(14);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-14);
        }];
    }
    return _changeLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
