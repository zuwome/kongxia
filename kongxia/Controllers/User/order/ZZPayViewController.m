//
//  ZZPayViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPayViewController.h"
#import "ZZRentViewController.h"
#import "ZZChatViewController.h"
#import "ZZRechargeViewController.h"
#import "ZZTaskSnatchListViewController.h"
#import "ZZLinkWebViewController.h"

#import "ZZPayTypeCell.h"
#import "ZZPayGuaranteeCell.h"
#import "ZZTonggaoPrepayCell.h"
#import "ZZLiveStreamEndAlert.h"
#import "ZZSkillDetailContentCell.h"
#import "ZZPayTonggaoCell.h"
#import "ZZInfoToastView.h"

#import "Pingpp.h"
#import "ZZMemedaModel.h"

@interface ZZPayViewController () <UITableViewDataSource,UITableViewDelegate, ZZTonggaoPrepayCellDelegate> {
    NSNumber                *_wallet;
    NSInteger               _selectIndex;
}

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ZZLiveStreamEndAlert *endAlert;

@property (nonatomic, strong) PaymentFooterView *footerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PaymentDetailsView *detailsView;

@property (nonatomic, copy) NSDictionary *guaranteeTexts;

@end

@implementation ZZPayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_endAlert) {
        [_endAlert removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"支付方式";
    [self createViews];
    [self managerPayMethod];
    [self loadData];
}

- (void)navigationLeftBtnClick {
    if (_type == PayTypeTask || _type == PayTypePrepayTonggao) {
        [ZZInfoToastView showWithType:ToastTaskCancelPost action:^(NSInteger actionIndex, ToastType type) {
            if (actionIndex != 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else if (_type == payTypePayTonggao) {
        [ZZInfoToastView showWithType:ToastPayTonggaoCancel action:^(NSInteger actionIndex, ToastType type) {
            if (actionIndex != 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadData {
    [[ZZUserHelper shareInstance].loginer getBalance:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _wallet = @([data[@"balance"] floatValue]);
            [_tableView reloadData];
            
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            loginer.balance = data[@"balance"];
            [[ZZUserHelper shareInstance] saveLoginer:[loginer toDictionary] postNotif:NO];
            [self fetchText];
        }
    }];
}

- (void)fetchText {
    [ZZRequest method:@"GET" path:@"/pdn/getPdPayTips" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error && [data isKindOfClass: [NSDictionary class]]) {
            _guaranteeTexts = data;
        }
        [_tableView reloadData];
    }];
}

- (void)setCount:(NSInteger)count {
    _count = count / 10;
    if (_count == 0) {
        _timeLabel.text = @"已超时，订单自动取消";
        [self.view.window addSubview:self.endAlert];
        self.endAlert.type = 5;
        self.endAlert.contentLabel.text = [NSString stringWithFormat:@"您未在%ld分钟内支付，任务已自动取消任务已取消掉任务已取消",(long)_validate_count];
    }
    else {
        NSInteger minute = _count / 60;
        NSInteger second = _count % 60;
        NSString *timeString = @"";
        if (minute < 9) {
            timeString = [NSString stringWithFormat:@"0%ld",(long)minute];
        } else {
            timeString = [NSString stringWithFormat:@"%ld",(long)minute];
        }
        if (second < 9) {
            timeString = [NSString stringWithFormat:@"%@:0%ld",timeString,(long)second];
        } else {
            timeString = [NSString stringWithFormat:@"%@:%ld",timeString,(long)second];
        }
        _timeLabel.text = [NSString stringWithFormat:@"请在%@内付款",timeString];
    }
}

- (void)showDetails {
    if (_type == PayTypeTask ) {
        [PaymentDetailsView showWithTotalPrice:_price taskAgency:UserHelper.configModel.pd_agency bottom:_footerView.top payType:_type];
    }
    else if (_type == payTypePayTonggao) {
        //        [_tonggaoAgencyPrice doubleValue]
        [PaymentDetailsView showWithTotalPrice:_price taskAgency:0.0 counts:_tonggaoSelectIDs.count bottom:_footerView.top payType:_type];
    }
}

- (void)showRules {
    [self showWeb:H5Url.chuliguize];
}

- (void)showWeb:(NSString *)url {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = url;
    controller.isShowLeftButton = YES;
    controller.isPush = YES;
    controller.isFromPay = YES;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ZZTonggaoPrepayCellDelegate
- (void)cellShowProtocol:(ZZTonggaoPrepayCell *)cell {
    [self showWeb:H5Url.tonggaoPrepayRefundRules];
}

#pragma mark - CreateViews
- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ZZPayGuaranteeCell class] forCellReuseIdentifier:[ZZPayGuaranteeCell cellIdentifier]];
    [_tableView registerClass:[ZZTonggaoPrepayCell class] forCellReuseIdentifier:[ZZTonggaoPrepayCell cellIdentifier]];
    [_tableView registerClass:[ZZSkillDetailContentCell class] forCellReuseIdentifier:@"ZZSkillDetailContentCell"];
    [_tableView registerClass:[ZZPayTonggaoCell class] forCellReuseIdentifier:[ZZPayTonggaoCell cellIdentifier]];
    [self.view addSubview:_tableView];
    
    if (_type == PayTypeTask || _type == PayTypePrepayTonggao || _type == payTypePayTonggao) {
        double totalPrice = _price;
        if (_type == payTypePayTonggao) {
            totalPrice = _price * _tonggaoSelectIDs.count;
        }
        
        _footerView = [[PaymentFooterView alloc] initWithPrice:totalPrice payType:_type];
        [_footerView.payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.showDetailsBtn addTarget:self action:@selector(showDetails) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
            make.height.equalTo(@50.0);
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.top.mas_equalTo(self.view.mas_top);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(_footerView.mas_top);
        }];
        
        if (_type == PayTypeTask) {
            UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 18.5)];
            footerBtn.normalTitle = @"查看取消规则详情";
            footerBtn.normalTitleColor = RGBCOLOR(153, 153, 153);
            footerBtn.titleLabel.font = CustomFont(13);
            footerBtn.normalImage = [UIImage imageNamed:@"icHelpYyCopy"];
            [footerBtn setImagePosition:LXMImagePositionRight spacing:6];
            [footerBtn addTarget:self action:@selector(showRules) forControlEvents:UIControlEventTouchUpInside];
            _tableView.tableFooterView = footerBtn;
        }
    }
    else {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.top.mas_equalTo(self.view.mas_top);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
        }];
        
        _tableView.tableFooterView = [self createFootView];
        [self createBottomViews];
    }
}

- (UIView *)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    footView.backgroundColor = kBGColor;
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH - 30, 50)];
    payBtn.backgroundColor = kYellowColor;
    payBtn.layer.cornerRadius = 5;
    
    if (_type == PayTypeOrder) {
        [payBtn setTitle:[NSString stringWithFormat:@"确认支付 ¥%.2f", [self calculateLeftPrice]] forState:UIControlStateNormal];
    }
    else {
        [payBtn setTitle:@"确定支付" forState:UIControlStateNormal];
    }
    
    [payBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:payBtn];
    
    if (_validate_count != 0) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kGrayTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [footView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.top.mas_equalTo(payBtn.mas_bottom).offset(8);
        }];
    }
    
    return footView;
}

- (void)createBottomViews {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kBGColor;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(_tableView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kGrayTextColor;
    [bottomView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView.mas_left).offset(15);
        make.right.mas_equalTo(bottomView.mas_right).offset(-15);
        make.top.mas_equalTo(bottomView.mas_top).offset(8);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel *firLabel = [[UILabel alloc] init];
    firLabel.textAlignment = NSTextAlignmentCenter;
    firLabel.textColor = kGrayContentColor;
    firLabel.font = [UIFont systemFontOfSize:13];
    firLabel.text = @"支付保障";
    firLabel.backgroundColor = kBGColor;
    [bottomView addSubview:firLabel];
    
    [firLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView.mas_centerY);
        make.centerX.mas_equalTo(lineView.mas_centerX);
        make.width.mas_equalTo(@75);
    }];
    
    UILabel *secLabel = [[UILabel alloc] init];
    secLabel.textAlignment = NSTextAlignmentCenter;
    secLabel.textColor = kGrayContentColor;
    secLabel.font = [UIFont systemFontOfSize:12];
    secLabel.text = @"本次交易由空虾平台提供支付担保保障";
    [bottomView addSubview:secLabel];
    
    [secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.mas_equalTo(firLabel.mas_bottom).offset(12);
    }];
    
    UILabel *thirLabel = [[UILabel alloc] init];
    thirLabel.textAlignment = NSTextAlignmentCenter;
    thirLabel.textColor = kGrayContentColor;
    thirLabel.font = [UIFont systemFontOfSize:12];
    thirLabel.text = @"如果有疑问可联系客服电话 4008-520-272";
    [bottomView addSubview:thirLabel];
    
    [thirLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.mas_equalTo(secLabel.mas_bottom).offset(5);
    }];
    
}

- (double)calculateLeftPrice {
    BOOL isMoreAccurate = NO;
    double orderPrice = [_order pureTotalPrice];
    double totalPrice = orderPrice;
    double advancePrice;
    
    if (totalPrice < 10) {
        advancePrice = totalPrice;
    }
    else {
        // 意向金采取四舍五入的形式
        advancePrice = roundf(totalPrice * 0.05);
        isMoreAccurate = YES;
    }
    
    if (_type == PayTypeOrder) {
        totalPrice += _order.wechat_price;
        advancePrice += _order.wechat_price;
    }
    else {
        totalPrice += [_order.xdf_price doubleValue];
        advancePrice += [_order.xdf_price doubleValue];
    }

    return totalPrice - advancePrice;
}


#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_type == PayTypeTask || _type == PayTypePrepayTonggao || _type == payTypePayTonggao) {
        return 2;
    }
    else {
        return  1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (_type == PayTypePrepayTonggao) {
            ZZTonggaoPrepayCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTonggaoPrepayCell cellIdentifier] forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (_type == payTypePayTonggao) {
            ZZPayTonggaoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPayTonggaoCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            ZZPayGuaranteeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPayGuaranteeCell cellIdentifier] forIndexPath:indexPath];
            cell.guaranteeTexts = _guaranteeTexts;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else {
        static NSString *identifier = @"mycell";
        
        ZZPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZPayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setDataIndexPath:indexPath selectIndex:_selectIndex];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _selectIndex = indexPath.row;
        [_tableView reloadData];
    }
    else if (indexPath.section == 1) {
        if (_type == payTypePayTonggao) {
            [self showWeb:H5Url.chuliguize];
        }
        else if (_type == PayTypePrepayTonggao) {
            [self showWeb:H5Url.tonggaoPrepayRefundRules];
        }
        else {
            [self showWeb:H5Url.tonggaoPlatformGuarantee];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    else {
        if (_type == PayTypePrepayTonggao) {
            return 116.0;
        }
        else if (_type == payTypePayTonggao) {
            return 137.5;
        }
        return 125.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10)];
}


#pragma mark - UIButtonMethod
- (void)payBtnClick {
    NSString *channel = @"";
    switch (_selectIndex) {
        case 0:
        {
            channel = @"wallet";
            if (!_wallet) {
                [ZZHUD showErrorWithStatus:@"获取余额失败!"];
                return;
            }
            
            switch (_type) {
                case PayTypeOrder:
                {            
                    if ([_wallet doubleValue] < [self calculateLeftPrice]) {
                        [self balanceInfo];
                        return;
                    }
//                    if ([_wallet doubleValue] < [_order.totalPrice doubleValue] * 0.95) {
//                        [self balanceInfo];
//                        return;
//                    }
                }
                    break;
                case PayTypeMMD:
                case PayTypeDashang:
                case PayTypeTask:
                case PayTypeTaskSum:
                case PayTypeRents:
                {
                    if ([ZZUtils compareWithValue1:_wallet value2:[NSNumber numberWithDouble:_price]] == NSOrderedAscending) {
                        [self balanceInfo];
                        return;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
            channel = @"wx";
            break;
        case 2: {
            channel = @"alipay";
        }
            break;
        default:
            break;
    }
    [ZZHUD showWithStatus:@"正在准备付款"];
    
    switch (_type) {
        case PayTypeOrder:
        {
            [self payOrderWithChannel:channel];
        }
            break;
        case PayTypeMMD:
        {
            [self payMemedaWithChannel:channel];
        }
            break;
        case PayTypeDashang:
        {
            [self payDashang:channel];
        }
            break;
        case PayTypeTask:
        {
            [self payTask:channel];
        }
            break;
        case PayTypeTaskSum:
        {
            [self payTaskSumPrice:channel];
        }
            break;
        case PayTypeRents: {
            [self payRentsPrice:channel];
        }
            break;
        case PayTypePrepayTonggao: {
            [self prepayTonggao:channel];
            break;
        }
        case payTypePayTonggao: {
            [self payTonggao:channel];
            break;
        }
        default:
            break;
    }
}

- (void)balanceInfo {
    [UIAlertView showWithTitle:@"钱包当前余额不足" message:nil cancelButtonTitle:@"其他支付方式" otherButtonTitles:@[@"马上充值"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self gotoRechargeView];
        }
    }];
}

- (void)payOrderWithChannel:(NSString *)channel {
    [_order pay:channel status:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            if (![channel isEqualToString:@"wallet"] && ![_order.totalPrice isEqualToNumber:@0]) {
                //缓存当前订单数据
                NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                [Pingpp createPayment:data
                       viewController:self
                         appURLScheme:@"kongxia"
                       withCompletion:^(NSString *result, PingppError *error) {
                           [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                           if ([result isEqualToString:@"success"]) {
                               [self payOrderSuccess];
                           } else {
                               // 支付失败或取消
                               [ZZHUD showErrorWithStatus:@"支付失败"];
                               NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           }
                       }];
            } else {
                _order.status = data[@"status"];
                [self.navigationController popViewControllerAnimated:YES];
                if (_didPay) {
                    _didPay();
                }
                [self savePayMethod];
            }
        }
    }];
}

- (void)payMemedaWithChannel:(NSString *)channel {
    ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
    [model payMemedaWithParam:@{@"channel":channel, @"pingxxtype": @"kxp",}
                          mid:_model.mid
                         next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                             if (error) {
                                 [ZZHUD showErrorWithStatus:error.message];
                             } else {
                                 [ZZHUD dismiss];
                                 if (![channel isEqualToString:@"wallet"]) {
                                     //缓存当前订单数据
                                     NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                                     [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                                     [Pingpp createPayment:data
                                            viewController:self
                                              appURLScheme:@"kongxia"
                                            withCompletion:^(NSString *result, PingppError *error) {
                                                [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                                                if ([result isEqualToString:@"success"]) {
                                                    [self payMemedaSuccess];
                                                } else {
                                                    // 支付失败或取消
                                                    [ZZHUD showErrorWithStatus:@"支付失败"];
                                                    NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                                }
                                            }];
                                 } else {
                                     [ZZUserHelper shareInstance].lastAskMoney = [NSString stringWithFormat:@"%.2f",_price];
                                     [self gotoUserCenter];
                                 }
                             }
                         }];
}

#pragma mark - Navigation
- (void)payOrderSuccess {
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        // 支付成功
        if (weakSelf.didPay) {
            weakSelf.didPay();
        }
        [weakSelf savePayMethod];
    });
}

- (void)payMemedaSuccess {
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf gotoUserCenter];
        [ZZUserHelper shareInstance].lastAskMoney = [NSString stringWithFormat:@"%.2f",weakSelf.price];
    });
}

- (void)gotoRechargeView {
    WeakSelf;
    [MobClick event:Event_click_money_recharge];
    ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
    controller.rechargeCallBack = ^{
        [ZZHUD showWithStatus:@"充值成功，重新获取余额..."];
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoUserCenter {
    [self savePayMethod];
    if (_didPay) {
        _didPay();
    }
    [ZZHUD showSuccessWithStatus:@"提交成功"];
    switch (_popIndex) {
        case 1:
        {
            for (UIViewController *ctl in self.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[ZZRentViewController class]]) {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
            }
        }
            break;
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            for (UIViewController *ctl in self.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[ZZChatViewController class]]) {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)payDashang:(NSString *)channel {
    ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
    [model dashangMememdaWithParam:@{@"channel":channel,
                                     @"tip_price":[NSNumber numberWithDouble:_price],
                                     @"pingxxtype": @"kxp",
                                     }
                               mid:_model.mid
                              next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                  
                                  if (error) {
                                      [ZZHUD showErrorWithStatus:error.message];
                                  } else {
                                      [ZZHUD dismiss];
                                      if (![channel isEqualToString:@"wallet"]) {
                                          //缓存当前订单数据
                                          NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                                          [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                                          WeakSelf;
                                          [Pingpp createPayment:data
                                                 viewController:self
                                                   appURLScheme:@"kongxia"
                                                 withCompletion:^(NSString *result, PingppError *error) {
                                                     [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                                                     if ([result isEqualToString:@"success"]) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [weakSelf dashangSuccess];
                                                         });
                                                     } else {
                                                         // 支付失败或取消
                                                         [ZZHUD showErrorWithStatus:@"支付失败"];
                                                         NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                                     }
                                                 }];
                                      } else {
                                          [self dashangSuccess];
                                      }
                                  }
                              }];
}

- (void)dashangSuccess {
    [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
    [self savePayMethod];
    [ZZHUD showSuccessWithStatus:@"谢谢您的打赏"];
    if (_didPay) {
        _didPay();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payTask:(NSString *)channel {
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd/%@/pay_deposit",_pId] params:@{@"channel":channel, @"pingxxtype": @"kxp",} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            if (![channel isEqualToString:@"wallet"]) {
                //缓存当前订单数据
                NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                WeakSelf;
                [Pingpp createPayment:data
                       viewController:self
                         appURLScheme:@"kongxia"
                       withCompletion:^(NSString *result, PingppError *error) {
                           [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                           if ([result isEqualToString:@"success"]) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [weakSelf payTaskSuccess];
                               });
                           } else {
                               // 支付失败或取消
                               [ZZHUD showErrorWithStatus:@"支付失败"];
                               NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           }
                       }];
            } else {
                [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
                [self payTaskSuccess];
            }
        }
    }];
}

- (void)payTaskSuccess {
    [self savePayMethod];
    if (_didPay) {
        _didPay();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payTaskSumPrice:(NSString *)channel {
    [ZZRequest method:@"POST"
                 path:[NSString stringWithFormat:@"/api/pd/%@/pay",_pId]
               params:@{@"channel":channel,
                        @"rids":_values,
                        @"pingxxtype": @"kxp",
                        }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (error) {
                         [ZZHUD showErrorWithStatus:error.message];
                     } else {
                         [ZZHUD dismiss];
                         if (![channel isEqualToString:@"wallet"]) {
                             //缓存当前订单数据
                             NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                             [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                             WeakSelf;
                             [Pingpp createPayment:data
                                    viewController:self
                                      appURLScheme:@"kongxia"
                                    withCompletion:^(NSString *result, PingppError *error) {
                                        [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                                        if ([result isEqualToString:@"success"]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf payTaskSumSuccess];
                                            });
                                        } else {
                                            // 支付失败或取消
                                            [ZZHUD showErrorWithStatus:@"支付失败"];
                                            NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                        }
                                    }];
                         } else {
                             [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
                             [self payTaskSumSuccess];
                         }
                     }
                 }];
}

- (void)payRentsPrice:(NSString *)channel {
    NSLog(@"%@", channel);
    NSLog(@"%@", _pId);
    
    NSDictionary *dict = @{@"channel": channel,
                           @"rid" : _pId,
                           @"pingxxtype": @"kxp",
                           };
    [ZZRequest method:@"POST"
                 path:@"/api/rent/pay"
               params:dict
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     
                     if (error) {
                         [ZZHUD showErrorWithStatus:error.message];
                     } else {
                         
                         [ZZHUD dismiss];
                         if (![channel isEqualToString:@"wallet"]) {
                             //缓存当前订单数据
                             NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                             [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                             WeakSelf;
                             [Pingpp createPayment:data
                                    viewController:self
                                      appURLScheme:@"kongxia"
                                    withCompletion:^(NSString *result, PingppError *error) {
                                        [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                                        if ([result isEqualToString:@"success"]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf payRentsPriceSuccess];
                                            });
                                        } else {
                                            // 支付失败或取消
                                            [ZZHUD showErrorWithStatus:@"支付失败"];
                                            NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                        }
                                    }];
                         } else {
                             [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
                             [self payRentsPriceSuccess];
                         }
                     }
                 }];
}

- (void)payTonggao:(NSString *)channel {
    NSDictionary *params = @{
                             @"channel": channel,
                             @"pid": _pId,
                             @"unitPrice": @(_price),
                             @"selectIds": _tonggaoSelectIDs,
                             @"pingxxtype": @"kxp",
                             };
    [ZZRequest method:@"POST"
                 path:@"/api/pd4/pdPayEndPirce"
               params: params
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (error) {
                         [ZZHUD showErrorWithStatus:error.message];
                     }
                     else {
                         [ZZHUD dismiss];
                         if (![channel isEqualToString:@"wallet"]) {
                             //缓存当前订单数据
                             NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                             [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                             WeakSelf;
                             [Pingpp createPayment:data
                                    viewController:self
                                      appURLScheme:@"kongxia"
                                    withCompletion:^(NSString *result, PingppError *error) {
                                        [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                                        if ([result isEqualToString:@"success"]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf payRentsPriceSuccess];
                                            });
                                        } else {
                                            // 支付失败或取消
                                            [ZZHUD showErrorWithStatus:@"支付失败"];
                                            NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                        }
                                    }];
                         }
                         else {
                             [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
                             [self payRentsPriceSuccess];
                         }
                     }
                 }];
}

- (void)prepayTonggao:(NSString *)channel {
    [ZZRequest method:@"POST"
                 path:[NSString stringWithFormat:@"/api/pd4/%@/pay_deposit", _pId]
               params:@{
                        @"channel": channel,
                        @"pid": _pId,
                        @"pingxxtype": @"kxp",
                        }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (error) {
                         [ZZHUD showErrorWithStatus:error.message];
                     }
                     else {
                         [ZZHUD dismiss];
                         if (![channel isEqualToString:@"wallet"]) {
                             //缓存当前订单数据
                             NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(_type)};
                             [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                             WeakSelf;
                             [Pingpp createPayment:data
                                    viewController:self
                                      appURLScheme:@"kongxia"
                                    withCompletion:^(NSString *result, PingppError *error) {
                                        [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                                        if ([result isEqualToString:@"success"]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf payRentsPriceSuccess];
                                            });
                                        } else {
                                            // 支付失败或取消
                                            [ZZHUD showErrorWithStatus:@"支付失败"];
                                            NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                                        }
                                    }];
                         }
                         else {
                             [ZZUserHelper shareInstance].lastPacketMoney = [NSString stringWithFormat:@"%.2f",_price];
                             [self payRentsPriceSuccess];
                         }
                     }
                 }];
}

- (void)payRentsPriceSuccess {
    [ZZHUD showSuccessWithStatus:@"支付成功"];
    [self savePayMethod];
    
    BLOCK_SAFE_CALLS(self.didPay);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payTaskSumSuccess {
    [ZZHUD showSuccessWithStatus:@"支付成功"];
    [self savePayMethod];
    if (_didPay) {
        _didPay();
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *ctl in array) {
        if ([ctl isKindOfClass:[ZZTaskSnatchListViewController class]]) {
            [array removeObject:ctl];
            break;
        }
    }
    self.navigationController.viewControllers = array;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 管理支付方式
- (void)managerPayMethod {
    NSString *method = [ZZUserHelper shareInstance].lastPayMethod;
    if ([method isEqualToString:@"packet"]) {
        _selectIndex = 0;
    } else if ([method isEqualToString:@"weixin"]) {
        _selectIndex = 1;
    } else if ([method isEqualToString:@"zhifubao"]) {
        _selectIndex = 2;
    } else {
        _selectIndex = 1;
    }
}

- (void)savePayMethod {
    switch (_selectIndex) {
        case 0:
        {
            [ZZUserHelper shareInstance].lastPayMethod = @"packet";
        }
            break;
        case 1:
        {
            [ZZUserHelper shareInstance].lastPayMethod = @"weixin";
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

- (void)paymentRecall:(NSDictionary *)paymentData { //没获取到支付回调时，查询支付状态后调用
    BOOL paid = [paymentData[@"paid"] boolValue];
    if (paid) {
        PayType type = [paymentData[@"type"] integerValue];
        switch (type) {
            case PayTypeOrder: {
                [self payOrderSuccess];
            } break;
            case PayTypeMMD: {
                [self payMemedaSuccess];
            } break;
            case PayTypeDashang: {
                [self dashangSuccess];
            } break;
            case PayTypeTask: {
                [self payTaskSuccess];
            } break;
            case PayTypeTaskSum: {
                [self payTaskSumSuccess];
            } break;
            case PayTypeRents: {
                [self payRentsPriceSuccess];
            } break;
            default: break;
        }
    } else {
        [ZZHUD showTastInfoErrorWithString:@"支付失败"];
    }
}

#pragma mark -
- (ZZLiveStreamEndAlert *)endAlert {
    WeakSelf;
    if (!_endAlert) {
        _endAlert = [[ZZLiveStreamEndAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _endAlert.touchSure = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _endAlert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getters and setters
@end

@interface PaymentFooterView()

@property (nonatomic, assign) double price;

@property (nonatomic, assign) PayType payType;

@end

@implementation PaymentFooterView

- (instancetype)initWithPrice:(double)price payType:(PayType)payType {
    self = [super init];
    if (self) {
        _price = price;
        _payType = payType;
        [self layout];
        [self configure];
    }
    return self;
}

#pragma mark - private method
- (void)configure {
    if (_payType == PayTypePrepayTonggao) {
        double agencyPrice = _price * UserHelper.configModel.pd_agency;
        NSString *agencyPriceStr = [NSString stringWithFormat:@"发布服务费 %.0f元", agencyPrice];
        
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:agencyPriceStr attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:RGBCOLOR(63, 58, 58)}];
        
        NSRange range = [agencyPriceStr rangeOfString:[NSString stringWithFormat:@"%.0f元", agencyPrice]];
        if (range.location != NSNotFound) {
            [nameString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(252, 47, 82) range:range];
        }
        
        _priceLabel.attributedText = nameString;
        _subPriceLabel.text = [NSString stringWithFormat:@"邀约金 ￥%.0f/人", _price];
    }
    
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    if (_payType == PayTypePrepayTonggao) {
        [self addSubview:self.payBtn];
        [self addSubview:self.priceLabel];
        [self addSubview:self.subPriceLabel];
        
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@187.5);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(5);
            make.right.equalTo(_payBtn.mas_left);
        }];
        
        [_subPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_priceLabel);
            make.top.equalTo(_priceLabel.mas_bottom).offset(2.0);
            //            make.left.right.equalTo(_priceLabel);
        }];
    }
    else {
        [self addSubview:self.payBtn];
        [self addSubview:self.showDetailsBtn];
        [self addSubview:self.priceLabel];
        
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@187.5);
        }];
        
        [_showDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(-5);
            make.bottom.equalTo(self);
            make.width.equalTo(@60.0);
            make.right.equalTo(_payBtn.mas_left);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self);
            make.right.equalTo(_showDetailsBtn.mas_left);
        }];
        
        [self layoutIfNeeded];
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_showDetailsBtn setImagePosition:LXMImagePositionTop spacing:4];
        //    });
    }
    
}

#pragma mark - getters and setters
- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        _payBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _payBtn.normalTitle = @"支付";
        _payBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _payBtn.titleFont = CustomFont(15);
    }
    return _payBtn;
}

- (UIButton *)showDetailsBtn {
    if (!_showDetailsBtn) {
        _showDetailsBtn = [[UIButton alloc] init];
        _showDetailsBtn.normalTitle = @"明细";
        _showDetailsBtn.normalTitleColor = RGBCOLOR(136, 136, 136);
        _showDetailsBtn.titleFont = CustomFont(15);
        _showDetailsBtn.normalImage = [UIImage imageNamed:@"icMingxi"];
    }
    return _showDetailsBtn;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = RGBCOLOR(252, 47, 82);
        _priceLabel.font = [UIFont boldSystemFontOfSize:15];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.text = [NSString stringWithFormat:@"¥%.2f元",_price];
    }
    return _priceLabel;
}

- (UILabel *)subPriceLabel {
    if (!_subPriceLabel) {
        _subPriceLabel = [[UILabel alloc] init];
        _subPriceLabel.textColor = RGBCOLOR(102, 102, 102);
        _subPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];;
        _subPriceLabel.textAlignment = NSTextAlignmentCenter;
        _subPriceLabel.text = [NSString stringWithFormat:@"¥%.2f元",_price];
    }
    return _subPriceLabel;
}

@end

@interface PaymentDetailsView ()

@property (nonatomic, assign) CGFloat desLocation;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) NSInteger counts;

@end

@implementation PaymentDetailsView

+ (void)showWithTotalPrice:(double)totalPrice taskAgency:(CGFloat)taskAgency bottom:(CGFloat)bottom payType:(PayType)payType {
    PaymentDetailsView *detailsView = [[PaymentDetailsView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds bottom:bottom payType:payType];
    
    [[UIApplication sharedApplication].keyWindow addSubview:detailsView];
    [detailsView setTaskTotalPrice:totalPrice taskAgency:taskAgency];
    //    [detailsView show];
}

+ (void)showWithTotalPrice:(double)totalPrice taskAgency:(CGFloat)taskAgency counts:(NSInteger)counts bottom:(CGFloat)bottom payType:(PayType)payType {
    PaymentDetailsView *detailsView = [[PaymentDetailsView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds bottom:bottom counts:counts payType:payType];
    
    [[UIApplication sharedApplication].keyWindow addSubview:detailsView];
    [detailsView setTaskTotalPrice:totalPrice taskAgency:taskAgency];
}

- (instancetype)initWithFrame:(CGRect)frame bottom:(CGFloat)bottom payType:(PayType)payType{
    self = [super initWithFrame:frame];
    if (self) {
        _type = payType;
        _bottom = bottom;
        [self layout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame desLocation:(CGFloat)desLocation bottom:(CGFloat)bottom {
    self = [super initWithFrame:frame];
    if (self) {
        _desLocation = desLocation;
        [self layout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame bottom:(CGFloat)bottom counts:(NSInteger)counts payType:(PayType)payType {
    self = [super initWithFrame:frame];
    if (self) {
        _counts = counts;
        _type = payType;
        _bottom = bottom;
        [self layout];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _infoView.top = SCREEN_HEIGHT - TABBAR_HEIGHT - _infoView.height;
    }];
}

- (void)hide {
    [_infoView removeFromSuperview];
    _infoView = nil;
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
    //    [UIView animateWithDuration:0.3 animations:^{
    //        _infoView.top = SCREEN_HEIGHT;
    //
    //    } completion:^(BOOL finished) {
    //        [self.bgView removeFromSuperview];
    //        self.bgView = nil;
    //        [self removeFromSuperview];
    //    }];
}

- (void)setTaskTotalPrice:(double)totalPrice taskAgency:(CGFloat)taskAgency {
    if (_type == PayTypeTask ) {
        _titleLabel.text = @"通告总金额明细";
        _price2Label.text = [NSString stringWithFormat:@"¥%.2f",totalPrice * taskAgency];
        _price1Label.text = [NSString stringWithFormat:@"¥%.2f",totalPrice * (1 - taskAgency)];
    }
    else if (_type == payTypePayTonggao) {
        _titleLabel.text = @"邀约金额明细";
        
        _price1DesLabel.text = @"邀约金";
        _price1Label.text = [NSString stringWithFormat:@"%ld人  ¥%.0f/人",_counts, totalPrice];
        
        _price2DesLabel.text = @"平台服务费";
        _price2Label.text = [NSString stringWithFormat:@"¥%.0f",taskAgency];
    }
}

- (void)layout {
    self.backgroundColor = ColorClear;
    [self addSubview:self.bgView];
    [self addSubview:self.infoView];
    
    [_infoView addSubview:self.titleLabel];
    [_infoView addSubview:self.hideBtn];
    [_infoView addSubview:self.price1DesLabel];
    [_infoView addSubview:self.price1Label];
    [_infoView addSubview:self.price2DesLabel];
    [_infoView addSubview:self.price2Label];
    
    _bgView.frame = self.bounds;
    _infoView.frame = CGRectMake(0.0, self.height - TABBAR_HEIGHT - 101, self.width, 101);
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoView).offset(12.0);
        make.left.equalTo(_infoView).offset(15.0);
    }];
    
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_infoView);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [_price1DesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.0);
        make.left.equalTo(_infoView).offset(15.0);
        make.height.equalTo(@(_price1DesLabel.font.lineHeight));
    }];
    
    [_price1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price1DesLabel);
        make.right.equalTo(_infoView).offset(-15.0);
        make.height.equalTo(@(_price1Label.font.lineHeight));
    }];
    
    [_price2DesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price1DesLabel.mas_bottom).offset(8.0);
        make.left.equalTo(_infoView).offset(15.0);
        make.height.equalTo(@(_price2DesLabel.font.lineHeight));
    }];
    
    [_price2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price2DesLabel);
        make.right.equalTo(_infoView).offset(-15.0);
        make.height.equalTo(@(_price2Label.font.lineHeight));
    }];
}

#pragma mark getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _titleLabel.text = @"通告总金额明细";
    }
    return _titleLabel;
}

- (UILabel *)price1DesLabel {
    if (!_price1DesLabel) {
        _price1DesLabel = [[UILabel alloc] init];
        _price1DesLabel.textColor = RGBCOLOR(171, 171, 171);
        _price1DesLabel.font = CustomFont(14.0);
        _price1DesLabel.text = @"租金";
    }
    return _price1DesLabel;
}

- (UILabel *)price1Label {
    if (!_price1Label) {
        _price1Label = [[UILabel alloc] init];
        _price1Label.textColor = RGBCOLOR(171, 171, 171);
        _price1Label.font = CustomFont(14.0);
        _price1Label.textAlignment = NSTextAlignmentRight;
        _price1Label.text = @"123";
    }
    return _price1Label;
}

- (UILabel *)price2DesLabel {
    if (!_price2DesLabel) {
        _price2DesLabel = [[UILabel alloc] init];
        _price2DesLabel.textColor = RGBCOLOR(171, 171, 171);
        _price2DesLabel.font = CustomFont(14.0);
        _price2DesLabel.text = @"通告服务费";
    }
    return _price2DesLabel;
}

- (UILabel *)price2Label {
    if (!_price2Label) {
        _price2Label = [[UILabel alloc] init];
        _price2Label.textColor = RGBCOLOR(171, 171, 171);
        _price2Label.font = CustomFont(14.0);
        _price2Label.textAlignment = NSTextAlignmentRight;
        _price2Label.text = @"123";
    }
    return _price2Label;
}

- (UIButton *)hideBtn {
    if (!_hideBtn) {
        _hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hideBtn.normalImage = [UIImage imageNamed:@"icJinemingxi"];
        [_hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = ColorClear;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = UIColor.whiteColor;
    }
    return _infoView;
}

@end
