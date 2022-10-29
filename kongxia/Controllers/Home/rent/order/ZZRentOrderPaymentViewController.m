//
//  ZZRentOrderPaymentViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderPaymentViewController.h"
#import "ZZRechargeViewController.h"
#import "ZZRentOrderPayCompleteViewController.h"
#import "ZZRentOrderInfoViewController.h"

#import "ZZRentOrderHeaderView.h"
#import "ZZRentOrderPayCell.h"
#import "ZZHelpCenterVC.h"
#import "Pingpp.h"
#import "ZZRentDropdownModel.h"

@interface ZZRentOrderPaymentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,   copy) NSArray<NSArray<NSNumber *> *> *tableViewCellTypes;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) NSInteger paySelectIndex;

@property (nonatomic, assign) CGFloat price;

@end

@implementation ZZRentOrderPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchBalance];
    
    [self createOrderCellTypes];
    [self layout];
}

#pragma mark - private method
- (void)createOrderCellTypes {
    NSMutableArray *array = @[].mutableCopy;
    [array addObject:@[
        @(CellTypePayWallet),
        @(CellTypePayWechat),
        @(CellTypePayWallet)
    ]];
    self.tableViewCellTypes = array.copy;
}

- (void)managerPayMethod {
    NSString *method = [ZZUserHelper shareInstance].lastPayMethod;
    if ([method isEqualToString:@"packet"]) {
        _paySelectIndex = 0;
    }
    else if ([method isEqualToString:@"weixin"]) {
        _paySelectIndex = 1;
    }
    else if ([method isEqualToString:@"zhifubao"]) {
        _paySelectIndex = 2;
    }
    else {
        _paySelectIndex = 1;
    }
}

//保存搜索过的地址
- (void)backupLocationArray {
    if (self.addressModel) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ZZUserHelper shareInstance].locationArray];
        __block BOOL have = NO;
        [array enumerateObjectsUsingBlock:^(ZZRentDropdownModel *downModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([downModel.name isEqualToString:self.addressModel.name]) {
                have = YES;
                *stop = YES;
            }
        }];
        if (!have) {
            if (array.count == 100) {
                [array removeLastObject];
            }
            [array insertObject:self.addressModel atIndex:0];
        }
        [[ZZUserHelper shareInstance] setLocationArray:array];
    }
}

- (void)savePayMethod {
    switch (_paySelectIndex) {
        case 0: {
            [ZZUserHelper shareInstance].lastPayMethod = @"packet";
            break;
        }
        case 1: {
            [ZZUserHelper shareInstance].lastPayMethod = @"weixin";
            break;
        }
        case 2: {
            [ZZUserHelper shareInstance].lastPayMethod = @"zhifubao";
            break;
        }
        default:
            break;
    }
}

//保存订单信息
- (void)backupOrder {
    ZZCacheOrder *cacheOrder = [[ZZCacheOrder alloc] init];
    cacheOrder.hours = _order.hours;
    cacheOrder.dated_at = _order.dated_at;
    cacheOrder.address = _order.address;
    cacheOrder.currentDate = [NSDate date];
    cacheOrder.checkWeChat = _order.wechat_service;
    CGFloat lat = [_order.loc.lat floatValue];
    CGFloat lng = [_order.loc.lng floatValue];
    cacheOrder.loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    cacheOrder.city = _order.city.name;
    if (_order.dated_at_type == 1) {
        cacheOrder.isQuickTime = YES;
    } else {
        cacheOrder.isQuickTime = NO;
    }
    [ZZUserHelper shareInstance].cacheOrder = cacheOrder;
}

/**
 *  计算预付款
 */
- (NSString *)calculatePrice {
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
    
    if (_order.wechat_service) {
        totalPrice += _order.wechat_price;
        advancePrice += _order.wechat_price;
    }
    else {
        totalPrice += [_order.xdf_price doubleValue];
        advancePrice += [_order.xdf_price doubleValue];
    }

    if (isMoreAccurate) {
        return  [NSString stringWithFormat:@"确认支付 ¥%.2lf",advancePrice];
    }
    else {
        return [NSString stringWithFormat:@"确认支付 ¥%.0lf",advancePrice];
    }
}

#pragma mark - response method
- (void)navigationLeftBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你与TA的距离只差最后一步了，确认放弃支付吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"约TA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showRefundRules {
    ZZHelpCenterVC *controller = [[ZZHelpCenterVC alloc] init];
    controller.urlString = H5Url.chuliguize;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)confirm:(UIButton *)sender {
    
    if (_isEdit) {
        _price = 0;
    }
    else {
        _price = _order.advancePrice.doubleValue;
    }
    
    if (!_isEdit && _paySelectIndex == 0 && [[ZZUserHelper shareInstance].loginer.balance doubleValue] < _price) {
        [UIAlertView showWithTitle:@"钱包当前余额不足" message:nil cancelButtonTitle:@"其他支付方式" otherButtonTitles:@[@"马上充值"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self gotoRechargeView];
            }
        }];
        return;
    }
    
    [MobClick event:Event_add_order];
    WeakSelf;
    sender.enabled = NO;
    if (_isEdit) {
        [ZZHUD showWithStatus:@"正在修改.."];
        [_order update:^(ZZError *error, id data, NSURLSessionDataTask *task) {
             sender.enabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD dismiss];
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateOrder object:self userInfo:data];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OrderStatusChante object:nil];
                }];
                
                [self backupLocationArray];
            }
        }];
        
    } else {
        [ZZHUD showWithStatus:@"正在下单..."];
        [_order addDeposit:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            sender.enabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已发出邀约，请等待对方回应。详情查看我的档期"];
                ZZOrder *order = [[ZZOrder alloc] initWithDictionary:data error:nil];
                weakSelf.order.id = order.id;
                weakSelf.order.status = order.status;
                [weakSelf backupLocationArray];
                
                [weakSelf pay];
            }
        }];
    }
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewCellTypes[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCellType type = (OrderCellType)[self.tableViewCellTypes[indexPath.section][indexPath.row] integerValue];
    
    if (type == CellTypePayWallet || type == CellTypePayWechat || type == CellTypePayAliPay) {
        ZZRentOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentOrderPayCell" forIndexPath:indexPath];
        
        [cell setIndexPath:indexPath selectIndex:_paySelectIndex];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCellType type = (OrderCellType)[self.tableViewCellTypes[indexPath.section][indexPath.row] integerValue];
    if (type == CellTypePayWallet || type == CellTypePayWechat || type == CellTypePayAliPay) {
        _paySelectIndex = indexPath.row;
        [self.tableView reloadData];
    }
}

#pragma mark - Request
- (void)gotoRechargeView {
    WeakSelf;
    [MobClick event:Event_click_money_recharge];
    ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
    controller.rechargeCallBack = ^{
        [ZZHUD showWithStatus:@"充值成功，余额更新中..."];
        [weakSelf fetchBalance];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)fetchBalance {
    [[ZZUserHelper shareInstance].loginer getBalance:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD dismiss];
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            loginer.balance = data[@"balance"];
            [[ZZUserHelper shareInstance] saveLoginer:loginer postNotif:NO];
            
            [_tableView reloadData];
        }
    }];
}

- (void)pay {
    NSString *channel = @"";
    switch (_paySelectIndex) {
        case 0: {
            channel = @"wallet";
            break;
        }
        case 1:
            channel = @"wx";
            break;
        case 2: {
            channel = @"alipay";
            break;
        }
        default:
            break;
    }
    
    if (_order.dated_at_type == 1) {
        [MobClick event:Event_choose_rent_quickly];
    }
    [ZZHUD showWithStatus:@"正在准备付款"];
    [_order advancePay:channel status:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            if (_paySelectIndex == 0) {
                ZZUser *user = [ZZUserHelper shareInstance].loginer;
                user.balance = [NSNumber numberWithInt:([user.balance doubleValue] - _price)];
                [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                [MobClick event:Event_pay_deposit_success];
                
                // 目前只有当优享邀约打开之后才需要通知个人页刷洗一下下
                if (_order.wechat_service) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMsg_CreateOrderNotification object:nil];
                }
                
                if (_isFromTask && _taskType == TaskFree) {
                    // 发活动的 付完款之后要走这个回掉告诉后台 支付成功
                    [self taskPayComplete];
                }
                else {
                    [self showPayCompleteView];
                }
            } else {
                WeakSelf;
                NSDictionary *paymentData = @{@"id":data[@"id"]};
                [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                [Pingpp createPayment:data
                       viewController:self
                         appURLScheme:@"kongxia"
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               [MobClick event:Event_pay_deposit_success];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [weakSelf payComplete];
                               });
                           } else {
                               // 支付失败或取消
                               NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           }
                       }];
            }
        }
    }];
}

- (void)payComplete {
    // 目前只有当优享邀约打开之后才需要通知个人页刷洗一下下
    if (_order.wechat_service) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KMsg_CreateOrderNotification object:nil];
    }
    
    if (_isFromTask && _taskType == TaskFree) {
        // 发活动的 付完款之后要走这个回掉告诉后台 支付成功
        [self taskPayComplete];
    }
    else {
        [self showPayCompleteView];
    }
}


- (void)taskPayComplete {
    NSDictionary *params = @{
                             @"to": _order.to.uid,
                             @"from": UserHelper.loginer.uid,
                             @"pdgid": _taskModel.task._id,
                             @"orderId": _order.id,
                             };
    
    [ZZTasksServer taskFreePayCompleteWithParams:params handler:^(ZZError *error, id data) {
        if (!error) {
            [self gotoChatView];
        }
    }];
}

#pragma mark - Navigator
- (void)showPayCompleteView {
    [ZZUserHelper shareInstance].unreadModel.order_ongoing_count++;
    
    if (!(_isFromTask && _taskType == TaskFree)) {
        [self savePayMethod];
        [self backupOrder];
    }
    
    ZZRentOrderPayCompleteViewController *vc = [[ZZRentOrderPayCompleteViewController alloc] init];
    vc.order = _order;
    vc.fromChat = _fromChat;
    vc.user = _user;
    vc.addressModel = _addressModel;
    [vc setCallBack:^{
        if (_callBack) {
            _callBack();
        }
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoChatView {
    [ZZUserHelper shareInstance].unreadModel.order_ongoing_count++;
    
    if (!(_isFromTask && _taskType == TaskFree)) {
        [self savePayMethod];
        [self backupOrder];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_fromChat) {
            for (UIViewController *ctl in self.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[ZZChatViewController class]]) {
                    if (_callBack) {
                        _callBack();
                    }
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
            }
        }
        else {
            ZZChatViewController *controller = [[ZZChatViewController alloc] init];
            controller.isFromRentOrder = YES;
            [ZZRCUserInfoHelper setUserInfo:_user];
            controller.user = _user;
            controller.nickName = _user.nickname;
            controller.uid = isNullString(_user.uid) ? _user.uuid : _user.uid;
            controller.portraitUrl = _user.avatar;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
            if (_order.wechat_service) {
                controller.shouldShowWeChat = YES;
            }
            
            [[ZZTabBarViewController sharedInstance] managerAppBadge];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            NSInteger index = array.count - 2;
            if (array.count > index) {
                [array removeObjectAtIndex:(array.count - 2)];
                [array removeObjectAtIndex:(array.count - 2)];
            }
            self.navigationController.viewControllers = array;
        }
    });
}

#pragma mark - Layout
- (void)layout {
    self.navigationItem.title = @"选择支付方式";
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getters and setters
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = [self calculatePrice];
        _confirmBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _confirmBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.cornerRadius = 25.0;
    }
    return _confirmBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 61.5;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(247, 247, 247);
        
        ZZRentOrderHeaderView *headerView = [[ZZRentOrderHeaderView alloc] init];
        headerView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 87.5);
        headerView.titleLabel.text = @"预约信息";
        headerView.subTitleLabel.text = @"预约需要支付一定的意向金，对方接受后，方可支付全款。款项将由平台全程担保，预约不成功，意向金将按规则返还。";
        _tableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 200.0)];
        [footerView addSubview: self.confirmBtn];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15 * 2, 50.0));
        }];
        
        UIView *rulesView = [[UIView alloc] init];
        [footerView addSubview:rulesView];
        [rulesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(footerView);
            make.top.equalTo(_confirmBtn.mas_bottom);
            make.height.equalTo(@61);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"icYaoyueguize"];
        [rulesView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rulesView);
            make.left.equalTo(rulesView).offset(111);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"查看取消邀约退款规则";
        titleLabel.textColor = RGBCOLOR(121, 121, 121);
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        [rulesView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rulesView);
            make.left.equalTo(imageView.mas_right).offset(5);
        }];
        
        rulesView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRefundRules)];
        [rulesView addGestureRecognizer:tap];
        _tableView.tableFooterView = footerView;
        
        [_tableView registerClass:[ZZRentOrderPayCell class]
           forCellReuseIdentifier:@"ZZRentOrderPayCell"];
    }
    return _tableView;
}

@end
