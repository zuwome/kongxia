//
//  ZZNotBuyWeiChatAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "TTTAttributedLabel.h"
#import "Pingpp.h"
#import "ZZRechargeViewController.h"
#import "ZZNotBuyWeiChatAlertView.h"
#import "ZZLinkWebViewController.h"

#import "ZZMeBiCollectionViewCell.h"

#import "ZZMeBiModel.h"

#import "ZZPayHelper.h"
#import "ZZPayManager.h"

@class ShowAssistanceView;
@interface ZZNotBuyWeiChatAlertView() <TTTAttributedLabelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ZZPayHelperDelegate>

@property (nonatomic, strong) ZZWeiChatEvaluationModel *model;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImageView *lookImageView;//喜欢的❤️
@property (nonatomic,strong) UILabel *look_weiChatNum_Likelab;//喜欢的人数
@property (nonatomic,strong) UIView *lineView;//分割线

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *look_weiChatNum_moneyLab;//查看微信号的金钱

@property (nonatomic, strong) UIImageView *mebiIcon;    //么币图标
@property (nonatomic, strong) UILabel *mebiBalance; //么币余额
@property (nonatomic, strong) UILabel *mebiNotEnoughLab;    //么币不足提示栏
@property (nonatomic, strong) UIImageView *mebiEnoughIcon;  //么币足够图标

@property (nonatomic, strong) UICollectionView *mebiCollection; //么币充值栏
@property (nonatomic, strong) NSArray *mebiArray;   //么币充值项

@property (nonatomic, assign) NSInteger currentSelectRechargeType; // 充值并购买的渠道:1:微信 2:支付宝

@property (nonatomic, strong) ZZMeBiModel *currentRechargeModel;    //当前所选充值项

@property (nonatomic,strong) UILabel *pay_weiChatNum_type_lab;//支付微信号的方式

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *payButton;//支付按钮
@property (nonatomic, strong) TTTAttributedLabel *changeLabel;//支付提示
@property (nonatomic, strong) TTTAttributedLabel *readProtocol; //阅读充值协议

@property (nonatomic,assign) BOOL isHaveLike;//是否有评价
@property (assign,nonatomic) NSInteger currentTag;

@property (nonatomic, assign) double price;

@property (nonatomic, strong) UIButton *aliPayBtn;

@property (nonatomic, strong) UIButton *weChatBtn;

@property (nonatomic, strong) UILabel *paymentLabel;

@property (nonatomic, copy)void(^touchChangePhone)(void);//更换手机号
@property (nonatomic,copy )void(^payBuyWeiChat)(BOOL isSuccess,NSString *payType);//支付成功
@property (nonatomic,copy )void(^rechargeCallBack)(BOOL isRechargeCallBackSuccess);//充值成功
@property (nonatomic,strong) ZZUser *user;
@property (assign, nonatomic) BOOL fromLiveStream;//只显示底部跟她视频

@property (nonatomic, assign) BOOL isEnoughToPay;   //是否有足够余额购买微信

@property (nonatomic, weak) UIViewController *ctl;

@property (nonatomic,strong)ShowAssistanceView *assistanceView;

@end
@implementation ZZNotBuyWeiChatAlertView


/**
 购买微信号的弹窗
 
 @param view 在展示弹窗的view
 @param curentmodel 微信号评价专用model
 @param goToBuyCallBlack 购买微信号的弹窗 yes 购买成功
 @param rechargeCallBack 充值的回调 yes
 @param touchChangePhoneCallBlack 更改手机号的回调
 */
+ (void)ShowNotBuyWeiChatAlertView:(UIViewController *)viewController  model:(ZZWeiChatEvaluationModel*)curentmodel goToBuy:(void(^)(BOOL isSuccess,NSString *payType))goToBuyCallBlack recharge:(void(^)(BOOL isRechargeSuccess))rechargeCallBack touchChangePhone:(void(^)(void))touchChangePhoneCallBlack {
    //先网络请求下余额避免数据不对
    [ZZUserHelper updateTheBalanceNext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error) {
            [[[ZZNotBuyWeiChatAlertView alloc]init] ShowNotBuyWeiChatAlertView:viewController model:curentmodel goToBuy:^(BOOL isBuySuccess,NSString *payBuyType) {
                if (goToBuyCallBlack) {
                    goToBuyCallBlack(isBuySuccess,payBuyType);
                }
            } recharge:^(BOOL isCurrentRechargeSuccess) {
                if (rechargeCallBack) {
                    rechargeCallBack(isCurrentRechargeSuccess);
                }
            } touchChangePhone:^{
                if (touchChangePhoneCallBlack) {
                    touchChangePhoneCallBlack();
                }
            }];
        }
    }];
   
}

/**
 购买微信号的弹窗
 
 @param view 在展示弹窗的view
 @param curentmodel 微信号评价专用model
 @param goToBuyCallBlack 购买微信号的弹窗 yes 购买成功
 @param rechargeCallBack 充值的回调 yes
 @param touchChangePhoneCallBlack 更改手机号的回调
 */
- (void)ShowNotBuyWeiChatAlertView:(UIViewController *)viewController  model:(ZZWeiChatEvaluationModel*)curentmodel goToBuy:(void(^)(BOOL isSuccess,NSString *payType))goToBuyCallBlack recharge:(void(^)(BOOL isRechargeSuccess))rechargeCallBack touchChangePhone:(void(^)(void))touchChangePhoneCallBlack {
    self.fromLiveStream = curentmodel.fromLiveStream;
    self.user = curentmodel.user;
    self.ctl = viewController;
    self.model = curentmodel;
    //更换手机号回调
    if (touchChangePhoneCallBlack) {
        _touchChangePhone = touchChangePhoneCallBlack;
    }
    //充值回调
    if (rechargeCallBack) {
        self.rechargeCallBack = rechargeCallBack;
    }
    //购买回调
    if (goToBuyCallBlack) {
        self.payBuyWeiChat = goToBuyCallBlack;
    }
    //没有评价的
    if (curentmodel.lookNumber<=0) {
        self.isHaveLike = NO;
    } else {//有评价人数的
        self.isHaveLike = YES;
    }
    //余额是否够买微信
    if (curentmodel.mcoinForItem > [[ZZUserHelper shareInstance].loginer.mcoin doubleValue]) {
        self.isEnoughToPay = NO;
        
        _currentSelectRechargeType = 1;
    } else {
        self.isEnoughToPay = YES;
    }
  
    [self setUIWithShowViewController:viewController];
    if (curentmodel.userIphoneNumber) {
        [self changeIphoneNumber:curentmodel.userIphoneNumber];
    }
    [self setProtocolReadLabel];
    [self setLookMoneyNumWithPriceString: [NSString stringWithFormat:@"%.0f",curentmodel.mcoinForItem]];
    [self setMebiBalanceWithPrice:[NSString stringWithFormat:@"%@",[ZZUserHelper shareInstance].loginer.mcoin]];
    
    // 使用内购
    [self getIAPList];
    
    // 使用支付宝微信充值    
//    [self getPriceList];
}

/**
 *  设置查看的金钱的额度
 *  @param PriceString 用户微信查看的额度
 */
- (void)setLookMoneyNumWithPriceString:(NSString *)PriceString{
    NSString *text = [NSString stringWithFormat:@"%@么币",PriceString];
    self.look_weiChatNum_moneyLab.text = text;
}

- (void)setMebiBalanceWithPrice:(NSString *)price {
    self.mebiBalance.text = [NSString stringWithFormat:@"么币余额：%@",price];
    self.mebiEnoughIcon.hidden = self.isEnoughToPay ? NO : YES;
    self.mebiNotEnoughLab.hidden = self.isEnoughToPay ? YES : NO;
}

- (void)didSelectPayment:(UIButton *)sender {
    _currentSelectRechargeType = sender.tag;
    [_weChatBtn setSelected: _currentSelectRechargeType == 1];
    [_aliPayBtn setSelected: _currentSelectRechargeType == 2];
    if (_currentSelectRechargeType == 1) {
        _paymentLabel.text = @"使用微信支付";
        _paymentLabel.textColor = ColorHex(72c448);
    }
    else if (_currentSelectRechargeType == 2) {
        _paymentLabel.text = @"使用支付宝支付";
        _paymentLabel.textColor = ColorHex(51b6ec);
    }
}

- (void)showAssistance {
    ZZLinkWebViewController *webC = [[ZZLinkWebViewController alloc] init];
    webC.urlString = [NSString stringWithFormat:@"%@%@",kBase_URL,@"/assistInRefund"];
    webC.hidesBottomBarWhenPushed = YES;
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:webC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.ctl presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 布局UI
- (void)setUIWithShowViewController:(UIViewController *)viewController {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.closeButton];
    if (_isHaveLike) {
        [self.bgView addSubview:self.lookImageView];
        [self.bgView addSubview:self.look_weiChatNum_Likelab];
        [self.bgView addSubview:self.lineView];
        self.look_weiChatNum_Likelab.text = [NSString stringWithFormat:@"%ld",(long)_model.lookNumber];
    }
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.look_weiChatNum_moneyLab];
    [self.bgView addSubview:self.changeLabel];
    [self.bgView addSubview:self.messageLabel];
    [self.bgView addSubview:self.payButton];
    
    [self.bgView addSubview:self.mebiIcon];
    [self.bgView addSubview:self.mebiBalance];
    [self.bgView addSubview:self.mebiNotEnoughLab];
    [self.bgView addSubview:self.mebiEnoughIcon];
    
    [self.bgView addSubview:self.mebiCollection];
    [self.bgView addSubview:self.assistanceView];
    
    
    [self setUpTheConstraints];
    
    viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self showView:viewController];
    
    [self layoutIfNeeded];
}

/**
 设置约束
 */
- (void)setUpTheConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.offset(0);
        make.size.equalTo(@(CGSizeMake(49, 49)));
    }];
    
    if (_isHaveLike) {
        [self.look_weiChatNum_Likelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.lookImageView.mas_centerY);
            make.leading.mas_equalTo(self.lookImageView.mas_trailing).with.offset(3);
            make.width.mas_equalTo(40);
        }];
        
        UILabel *likeTitleLab = [[UILabel alloc]init];
        [self.bgView addSubview:likeTitleLab];
        likeTitleLab.text = @"人看过觉得好";
        likeTitleLab.textAlignment = NSTextAlignmentLeft;
        likeTitleLab.textColor = [UIColor blackColor];
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        if (fontFirst == nil) {
            fontFirst= [UIFont fontWithName:@"Helvetica-Bold" size:15];
        }
        likeTitleLab.font =fontFirst;
        [likeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.lookImageView.mas_centerY);
            make.trailing.offset(0);
            make.leading.mas_equalTo(self.look_weiChatNum_Likelab.mas_trailing).with.offset(3);
        }];
        
        [self.lookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX).multipliedBy(0.6);
            make.centerY.mas_equalTo(self.bgView.mas_centerY).multipliedBy(0.19);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY).multipliedBy(0.37);
            make.leading.trailing.offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28.0);
        make.leading.equalTo(self).offset(15.0);
        if (self.isHaveLike) {
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        } else {
            make.top.equalTo(@50.0);
        }
    }];
    
    [self.look_weiChatNum_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.height.equalTo(@22.5);
        make.right.equalTo(self).offset(-17.5);
    }];
    
    [self.mebiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(self.look_weiChatNum_moneyLab.mas_bottom).offset(35);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.mebiBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mebiIcon);
        make.height.equalTo(@24);
        make.leading.equalTo(self.mebiIcon.mas_trailing).offset(8);
    }];
    
    [self.mebiNotEnoughLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-15);
        make.height.equalTo(@24);
        make.centerY.equalTo(self.mebiIcon);
    }];
    
    [self.mebiEnoughIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-15);
        make.centerY.equalTo(self.mebiIcon);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.mebiCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mebiIcon.mas_bottom).offset(20);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        if (self.isEnoughToPay) {
            make.height.equalTo(@0);
        } else {
            make.height.equalTo(@(AdaptedHeight(90)));
        }
    }];

    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mebiCollection.mas_bottom).offset(10.0);
        make.leading.offset(15);
        make.trailing.offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_payButton.mas_bottom).offset(10);
    }];
    
    [self.assistanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_messageLabel.mas_bottom).offset(10);
        make.height.equalTo(@17);
    }];
    
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.payButton.mas_bottom).offset(8);
        make.leading.mas_equalTo(_bgView.mas_leading).offset(50);
        make.trailing.mas_equalTo(_bgView.mas_trailing).offset(-50);
        make.height.mas_equalTo(34);
        make.bottom.equalTo(@(-20 - SafeAreaBottomHeight - (self.isHaveLike ? 0 : 60)));
    }];
}

- (void)getPriceList {
    [ZZMeBiModel fetchWeChat:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *mebiDict in data) {
                ZZMeBiModel *model = [[ZZMeBiModel alloc] initWithDictionary:mebiDict error:nil];
                [array addObject:model];
            }
            self.mebiArray = [NSArray arrayWithArray:array];
            self.currentRechargeModel = [self.mebiArray firstObject];
            [self.mebiCollection reloadData];
        }
    }];
}

- (void)getIAPList {
    [ZZMeBiModel getIAPWithWechatPayList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *mebiDict in data) {
                ZZMeBiModel *model = [[ZZMeBiModel alloc] initWithDictionary:mebiDict error:nil];
                [array addObject:model];
            }
            self.mebiArray = [NSArray arrayWithArray:array];
            self.currentRechargeModel = [self.mebiArray firstObject];
            [self.mebiCollection reloadData];
        }
    }];
}

- (void)clickDissMiss {
    [self dissMiss];
}

/**
 购买微信号
 */
- (void)payBtnClick {
    self.payButton.userInteractionEnabled = NO;
    if (self.isEnoughToPay) {   //么币足够
        [self buy];
    } else {
        // 使用支付宝微信充值
//        [self rechargeByPayments];
        
        [self rechargeByIAP];
    }
}
//购买微信
- (void)buy {
    if (_model.type == PaymentTypeWX) {
        [MobClick event:Event_click_userpage_wx_buy];
    }
    else if (_model.type == PaymentTypeIDPhoto) {
        [MobClick event:Event_click_userpage_IDPhoto_buy];
    }
    
    [ZZHUD showWithStatus:@"支付中..."];
    NSString *uid = self.user.uid;
    NSString *price = [NSString stringWithFormat:@"%.0f",self.model.mcoinForItem];
    
    if (_model.type == PaymentTypeWX) {
        // 买微信
        NSString *source = nil;
        if (_model.source == SourceChat) {
            source = @"chat";
        }
        else if (_model.source == SourcePersonalInfo) {
            source = @"detail";
        }
        
        [ZZMeBiModel buyWeChat:uid byMcoin:price source:source next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                //更新用户信息
                [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id userData, NSURLSessionDataTask *task) {
                    ZZUser *user = [ZZUser yy_modelWithJSON:data];;
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                }];
                
                !self.payBuyWeiChat ? : self.payBuyWeiChat(YES,@"pay_for_wechat");
                [self dissMiss];
            }
        }];
    }
    else if (_model.type == PaymentTypeIDPhoto) {
        // 买证件照
        [ZZMeBiModel buyIDPhoto:uid byMcoin:price next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                //更新用户信息
                [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id userData, NSURLSessionDataTask *task) {
                    ZZUser *user = [ZZUser yy_modelWithJSON:data];;
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                }];
                !self.payBuyWeiChat ? : self.payBuyWeiChat(YES,@"pay_for_idphoto");
                [self dissMiss];
            }
        }];
    }
}

- (void)rechargeByPayments {
    [MobClick event:Event_click_MeBi_TopUp];
    if (self.currentRechargeModel && (_currentSelectRechargeType == 1 || _currentSelectRechargeType == 2)) {
        [_currentRechargeModel rechargeBy:_currentSelectRechargeType model:_currentRechargeModel next:^(BOOL isSuccess) {
            if (isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.payButton.userInteractionEnabled = YES;
                        [ZZHUD showWithStatus:@"充值成功"];
                        [self updateMebi];
                        if (self.isEnoughToPay) { //么币足够则去购买微信
                            [self buy];
                        }
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [ZZHUD dismiss];
                    });
                });
            }
        }];
    }
}

- (void)rechargeByIAP {
    [MobClick event:Event_click_MeBi_TopUp];
    if (self.currentRechargeModel) {
        ZZPayHelper *request =   [ZZPayHelper shared];
        request.delegate = self;
        [ZZHUD showWithStatus:@"正在购买中"];
        [ZZPayHelper requestProductWithId:self.currentRechargeModel.productId];
    }
}
#pragma mark -- ZZPayHelperDelegate 内购回调
//内购 -- 支付失败状态码
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error transactionIdentifier:(NSString *)transactionIdentifier {
    if (isNullString(transactionIdentifier)) {
        transactionIdentifier = @"";
    }
    if (isNullString(error)) {
        error = @"";
    }
    NSDictionary *dic = @{@"errorCodeType":@(errorCode), @"errorCodeString":error,@"transactionIdentifier":transactionIdentifier};
    [ZZPayManager uploadToServerData:dic];  //上传内购失败数据到服务器
    [ZZHUD dismiss];
    self.payButton.userInteractionEnabled = YES;
    [UIAlertView showWithTitle:@"温馨提示" message:error cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
    }];
}

//内购 -- 支付成功
- (void)paySuccessWithtransactionInfo:(NSDictionary *)infoDic {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.payButton.userInteractionEnabled = YES;
        if (!infoDic[@"error"]) {
            [ZZHUD showWithStatus:@"充值成功"];
            [self updateMebi];
            if (self.isEnoughToPay) { //么币足够则去购买微信
                [self buy];
            }
        } else{
            NSString *errorMessage = infoDic[@"error"][@"message"];
            [ZZHUD showWithStatus:errorMessage];
        }
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [ZZHUD dismiss];
        });
    });
}
//支付或充值后更新么币
- (void)updateMebi {
    self.mebiBalance.text = [NSString stringWithFormat:@"么币余额：%@",[ZZUserHelper shareInstance].loginer.mcoin];
    if (self.model.mcoinForItem > [[ZZUserHelper shareInstance].loginer.mcoin doubleValue]) {
        self.isEnoughToPay = NO;
        self.mebiNotEnoughLab.hidden = NO;
        self.mebiEnoughIcon.hidden = YES;
        [self.payButton setTitle:@"确认充值并购买" forState:(UIControlStateNormal)];
        [self.mebiCollection mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(AdaptedHeight(64) + 50));
        }];
    } else {
        self.isEnoughToPay = YES;
        self.mebiNotEnoughLab.hidden = YES;
        self.mebiEnoughIcon.hidden = NO;
        [self.payButton setTitle:@"购买" forState:(UIControlStateNormal)];
        [self.mebiCollection mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([label.text containsString:@"《充值协议》"]) {
        self.hidden = YES;
        ZZLinkWebViewController *webViewController = [[ZZLinkWebViewController alloc]init];
        NSString *url = H5Url.rechargeAgreement_zuwome;
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ((version && [version isEqualToString:@"3.7.5"])) {
            url = H5Url.rechargeAgreement;
        }
        webViewController.urlString = url;
        webViewController.navigationItem.title = @"充值协议";
        [self.ctl.navigationController pushViewController:webViewController animated:YES];
    } else if ([label.text containsString:@"复制"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:@"zwmapp"];
        [ZZHUD showTaskInfoWithStatus:@"复制成功，前往微信添加"];
    }
}

/**
 更换手机号
 */
- (void)gotoChangePhoneView
{
    if (self.fromLiveStream) {
        return;
    }
    WeakSelf
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeChangePhone inController:self.ctl];
    helper.user = [ZZUserHelper shareInstance].loginer;
    helper.checkSuccess = ^{
        weakSelf.hidden = NO;
        [weakSelf changeIphoneNumber:[ZZUserHelper shareInstance].loginer.phone];
    };
    [helper start];
}

- (void)changeIphoneNumber:(NSString *)iphoneNumber {
    if (iphoneNumber) {
//        NSString *string = [NSString stringWithFormat:@"充值问题，请咨询空虾官方微信公众号：zwmapp 复制"];
//        [self.changeLabel setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:[string rangeOfString:@"复制"]];
//            return mutableAttributedString;
//        }];
//        
//        [self.changeLabel addLinkToURL:[NSURL URLWithString:@"复制"] withRange:[string rangeOfString:string]];
    }
}

- (void)setProtocolReadLabel {
    NSString *string = @"付费即代表已阅读并同意《充值协议》";
    [self.readProtocol setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:[string rangeOfString:@"《充值协议》"]];
        return mutableAttributedString;
    }];
    [self.readProtocol addLinkToURL:[NSURL URLWithString:@"《充值协议》"] withRange:[string rangeOfString:@"《充值协议》"]];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mebiArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZMeBiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZMeBiCollectionViewCellID" forIndexPath:indexPath];
    [cell setMeBiModel:self.mebiArray[indexPath.item]];
    
    if ([self.currentRechargeModel isEqual:self.mebiArray[indexPath.item]]) {
        [cell setSelected:YES];
    } else {
        [cell setSelected:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger preIndex = [self.mebiArray indexOfObject:self.currentRechargeModel];
    if (preIndex >= 0 && preIndex < self.mebiArray.count) {
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preIndex inSection:0];
        ZZMeBiCollectionViewCell *preCell = (ZZMeBiCollectionViewCell *)[collectionView cellForItemAtIndexPath:preIndexPath];
        [preCell setSelected:NO];
    }
    self.currentRechargeModel = self.mebiArray[indexPath.item];
    ZZMeBiCollectionViewCell *cell = (ZZMeBiCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    /*
//    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IAPListFooter" forIndexPath:indexPath];
//        [footer addSubview:self.aliPayBtn];
//        [footer addSubview:self.weChatBtn];
//
//        [footer addSubview:self.paymentLabel];
//
//        CGFloat paymentWidth = (SCREEN_WIDTH - 30) / 2;
//
//        [_weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(footer);
//            make.top.equalTo(footer);
//            make.size.mas_equalTo(CGSizeMake(paymentWidth, 50));
//        }];
//
//        [_aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_weChatBtn.mas_right);
//            make.centerY.equalTo(_weChatBtn);
//            make.size.mas_equalTo(CGSizeMake(paymentWidth, 50));
//        }];
//
//        [_paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(footer).offset(15);
//            make.right.equalTo(footer).offset(-15);
//            make.top.equalTo(_aliPayBtn.mas_bottom);
//        }];
//
//        [footer addSubview:self.readProtocol];
//        [self.readProtocol mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_paymentLabel.mas_bottom);
//            make.height.equalTo(@30);
//            make.leading.trailing.equalTo(@0);
//            make.bottom.equalTo(footer);
//        }];
//
//        [_weChatBtn setSelected: _currentSelectRechargeType == 1];
//        [_aliPayBtn setSelected: _currentSelectRechargeType == 2];
//        if (_currentSelectRechargeType == 1) {
//            _paymentLabel.text = @"使用微信支付";
//            _paymentLabel.textColor = ColorHex(72c448);
//        }
//        else if (_currentSelectRechargeType == 2) {
//            _paymentLabel.text = @"使用支付宝支付";
//            _paymentLabel.textColor = ColorHex(51b6ec);
//        }
//
//        return footer;
//    }
//     */
//    return nil;
//}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icChatEvaluatePopClosed"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickDissMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)lookImageView {
    if (!_lookImageView) {
        _lookImageView = [[UIImageView alloc]init];
        _lookImageView.image = [UIImage imageNamed:@"icEvaluatWeixin"];
    }
    return _lookImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ADaptedFontSCBoldSize(20.0);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        
        _titleLabel.text = _model.type == PaymentTypeWX ? @"查看微信" : @"查看证件照";
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:11];
        _messageLabel.textColor = RGBCOLOR(63, 58, 58);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"达人若私自索要红包才能添加，举报核实后平台全额退款";
    }
    return _messageLabel;
}

//Helvetica-Bold
- (UILabel *)look_weiChatNum_Likelab {
    if (!_look_weiChatNum_Likelab) {
        _look_weiChatNum_Likelab  = [[UILabel alloc]init];
        _look_weiChatNum_Likelab.textAlignment = NSTextAlignmentCenter;
        _look_weiChatNum_Likelab.textColor = [UIColor blackColor];
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        if (fontFirst == nil) {
            fontFirst= [UIFont fontWithName:@"Helvetica-Bold" size:15];
        }
        _look_weiChatNum_Likelab.font = fontFirst;
    }
    return _look_weiChatNum_Likelab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(216, 216, 216);
    }
    return _lineView;
}

- (UILabel *)look_weiChatNum_moneyLab {
    if (!_look_weiChatNum_moneyLab) {
        _look_weiChatNum_moneyLab = [[UILabel alloc]init];
        _look_weiChatNum_moneyLab.textAlignment = NSTextAlignmentCenter;
        _look_weiChatNum_moneyLab.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        _look_weiChatNum_moneyLab.textColor = RGBCOLOR(63, 58, 58);
    }
    return _look_weiChatNum_moneyLab;
}

- (UIImageView *)mebiIcon {
    if (nil == _mebiIcon) {
        _mebiIcon = [[UIImageView alloc] init];
        _mebiIcon.image = [UIImage imageNamed:@"icMebi"];
    }
    return _mebiIcon;
}

- (UIImageView *)mebiEnoughIcon {
    if (nil == _mebiEnoughIcon) {
        _mebiEnoughIcon = [[UIImageView alloc] init];
        _mebiEnoughIcon.image = [UIImage imageNamed:@"iconSelectedGreen"];
    }
    return _mebiEnoughIcon;
}

- (UILabel *)mebiBalance {
    if (nil == _mebiBalance) {
        _mebiBalance = [[UILabel alloc] init];
        _mebiBalance.textColor = kBlackColor;
        _mebiBalance.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
        _mebiBalance.text = @"么币余额：";
    }
    return _mebiBalance;
}

- (UILabel *)mebiNotEnoughLab {
    if (nil == _mebiNotEnoughLab) {
        _mebiNotEnoughLab = [[UILabel alloc] init];
        _mebiNotEnoughLab.textColor = kGrayTextColor;
        _mebiNotEnoughLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _mebiNotEnoughLab.text = @"余额不足，请充值";
    }
    return _mebiNotEnoughLab;
}

- (UILabel *)pay_weiChatNum_type_lab {
    if (!_pay_weiChatNum_type_lab) {
        _pay_weiChatNum_type_lab = [[UILabel alloc]init];
        _pay_weiChatNum_type_lab.font = [UIFont systemFontOfSize:15];
        _pay_weiChatNum_type_lab.text = @"使用微信支付";
        _pay_weiChatNum_type_lab.textAlignment = NSTextAlignmentCenter;
        _pay_weiChatNum_type_lab.textColor = RGBCOLOR(114, 196, 72);
    }
    return _pay_weiChatNum_type_lab;
}

- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.backgroundColor = kGoldenRod;
        NSString *btnTitle = _isEnoughToPay ? @"购买" : @"确认充值并购买";
        [_payButton setTitle:btnTitle forState:UIControlStateNormal];
        [_payButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_payButton addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _payButton.layer.cornerRadius = 2.5;
        _payButton.clipsToBounds = YES;
    }
    return _payButton;
}

- (TTTAttributedLabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _changeLabel.backgroundColor = [UIColor clearColor];
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.textColor = kBlackTextColor;
        _changeLabel.font = [UIFont systemFontOfSize:12];
        _changeLabel.numberOfLines = 0;
        _changeLabel.delegate = self;
        _changeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _changeLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[kBlackColor CGColor]};
        _changeLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[kBlackColor CGColor]};
        _changeLabel.userInteractionEnabled = YES;
    }
    return _changeLabel;
}

- (TTTAttributedLabel *)readProtocol {
    if (nil == _readProtocol) {
        _readProtocol = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _readProtocol.backgroundColor = [UIColor clearColor];
        _readProtocol.textAlignment = NSTextAlignmentCenter;
        _readProtocol.textColor = kGrayTextColor;
        _readProtocol.font = [UIFont systemFontOfSize:12];
        _readProtocol.delegate = self;
        _readProtocol.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _readProtocol.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _readProtocol.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _readProtocol.userInteractionEnabled = YES;
    }
    return _readProtocol;
}

- (UICollectionView *)mebiCollection {
    if (nil == _mebiCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = AdaptedWidth(7);
        layout.itemSize = CGSizeMake(AdaptedWidth((375 - 30 - 2 * 8) / 3), AdaptedHeight(64));
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 15);
        _mebiCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mebiCollection.backgroundColor = [UIColor whiteColor];
        [_mebiCollection registerClass:[ZZMeBiCollectionViewCell class] forCellWithReuseIdentifier:@"ZZMeBiCollectionViewCellID"];
        [_mebiCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IAPListFooter"];
        _mebiCollection.delegate = self;
        _mebiCollection.dataSource = self;
    }
    return _mebiCollection;
}

- (NSArray *)mebiArray {
    if (nil == _mebiArray) {
        _mebiArray = [NSArray array];
    }
    return _mebiArray;
}

- (UIButton *)aliPayBtn {
    if (!_aliPayBtn) {
        _aliPayBtn = [[UIButton alloc] init];
        _aliPayBtn.normalImage = [UIImage imageNamed:@"icon_rent_pay_zfb_n"];
        _aliPayBtn.selectedImage = [UIImage imageNamed:@"icon_rent_pay_zfb_p"];
        _aliPayBtn.tag = 2;
        [_aliPayBtn addTarget:self action:@selector(didSelectPayment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aliPayBtn;
}

- (UIButton *)weChatBtn {
    if (!_weChatBtn) {
        _weChatBtn = [[UIButton alloc] init];
        _weChatBtn.normalImage = [UIImage imageNamed:@"icon_rent_pay_wx_n"];
        _weChatBtn.selectedImage = [UIImage imageNamed:@"icon_rent_pay_wx_p"];
        _weChatBtn.tag = 1;
        [_weChatBtn addTarget:self action:@selector(didSelectPayment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatBtn;
}

- (UILabel *)paymentLabel {
    if (!_paymentLabel) {
        _paymentLabel = [[UILabel alloc] init];
        _paymentLabel.font = [UIFont systemFontOfSize:12.0];
        _paymentLabel.textColor = kGrayTextColor;
        _paymentLabel.textAlignment = NSTextAlignmentCenter;
        _paymentLabel.text = @"还未选取支付方式";
    }
    return _paymentLabel;
}

- (ShowAssistanceView *)assistanceView {
    if (!_assistanceView) {
        _assistanceView = [[ShowAssistanceView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAssistance)];
        [_assistanceView addGestureRecognizer:tap];
        
    }
    return _assistanceView;
}

@end

@interface ShowAssistanceView()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) CAGradientLayer *btnGragientLayer;

@property (nonatomic, strong) UIImageView *bgImageView;


@end

@implementation ShowAssistanceView


-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImageView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.bgImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(65);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_iconImageView.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(225, 16));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_iconImageView.mas_right).offset(10);
        }];
        
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_titleLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.textColor = RGBCOLOR(252, 90, 82);
        _titleLabel.text = @"虚假微信或无法通过添加要如何退款";
    }
    return _titleLabel;
}

- (UIImageView *)bgImageView {
    if (nil == _bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"bgTkrk"];
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView {
    if (nil == _iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icBaozhang"];
    }
    return _iconImageView;
}

- (UIImageView *)rightImageView {
    if (nil == _rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"icMore_r"];
    }
    return _rightImageView;
}

@end
