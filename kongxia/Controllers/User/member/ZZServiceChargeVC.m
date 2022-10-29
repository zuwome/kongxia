//
//  ZZServiceChargeVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/13.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZServiceChargeVC.h"
#import "ZZServiceChargeCell.h"
#import "ZZAuditFeeModel.h"

#import "ZZPayViewController.h"
#import "ZZOpenSuccessVC.h"
#import "ZZLinkWebViewController.h"
#import "ZZChatServerViewController.h"

@interface ZZServiceChargeVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZZAuditFeeModel *> *dataSource;
@property (nonatomic, strong) UIButton *selectIconButton;

@end

@implementation ZZServiceChargeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!_user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self defaultSelectCell];
}

#pragma mark - Getter

- (NSMutableArray<ZZAuditFeeModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark - Private methods

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"平台审核服务费";
    
    UIView *bottomView = [self createBottomView];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(isIPhoneX ? (-34) : 0));
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@120);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[ZZServiceChargeCell class] forCellReuseIdentifier:[ZZServiceChargeCell reuseIdentifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(bottomView.mas_top).offset(-10);
    }];
    
    [self asyncFetchRentPayPrice];
}

- (void)asyncFetchRentPayPrice {
    
    WEAK_SELF();
    [ZZHUD showWithStatus:nil];
    [_user getRentPayPriceListNext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            
            _dataSource = [ZZAuditFeeModel arrayOfModelsFromDictionaries:data error:nil];
            NSLog(@"%@", _dataSource);
            [weakSelf.tableView reloadData];
        }
    }];
}

// 温馨提示
- (UIView *)createBottomView {
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100);
    
    UILabel *warmTips = [UILabel new];
    warmTips.text = @"温馨提示";
    warmTips.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    warmTips.textColor = kBlackColor;
    
    UILabel *tip1 = [UILabel new];
    tip1.text = @"出租服务将于在线支付成功后自动开通";
    tip1.textColor = kGrayTextColor;
    tip1.font = [UIFont systemFontOfSize:14];

    NSString *btnString = @"对出租服务有任何疑问或出现使用问题，请咨询在线客服";
    NSRange range = [btnString rangeOfString:@"在线客服"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:kGrayTextColor forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(onlineServiceClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:btnString];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [content addAttribute:NSForegroundColorAttributeName value:kGrayTextColor range:NSMakeRange(0, [btnString length])];
    [content addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(74, 144, 226) range:range];
    [content addAttribute:NSUnderlineColorAttributeName value:RGBCOLOR(74, 144, 226) range:range];
    [button setAttributedTitle:content forState:UIControlStateNormal];
    
    UILabel *tip3 = [UILabel new];
    tip3.text = @"服务一经开通，不予退款，敬请谅解";
    tip3.textColor = kGrayTextColor;
    tip3.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:warmTips];
    [view addSubview:tip1];
    [view addSubview:button];
//    [view addSubview:tip3];

    [warmTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
        make.height.equalTo(@20);
    }];
    
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warmTips.mas_bottom).offset(5);
        make.leading.equalTo(warmTips.mas_leading);
        make.height.equalTo(@20);
        make.trailing.equalTo(@(-15));
    }];
    
    CGFloat height = [ZZUtils heightForCellWithText:btnString fontSize:14 labelWidth:SCREEN_WIDTH - 26];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1.mas_bottom).offset(5);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@(height));
    }];
    
//    [tip3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(button.mas_bottom).offset(5);
//        make.leading.equalTo(@15);
//        make.height.equalTo(@20);
//        make.trailing.equalTo(@(-15));
//    }];
    return view;
}

- (void)navigationLeftBtnClick {
    WEAK_SELF();
    [UIAlertController presentAlertControllerWithTitle:@"温馨提示" message:@"放弃支付后，您将错过邀约机会，是否确认放弃支付？" doneTitle:@"我再想想" cancelTitle:@"残忍放弃" completeBlock:^(BOOL isCancelled) {
        if (isCancelled) {
            
            if (weakSelf.isSaveUser) {  // 如果是没有出租过的信息，第一次填写，返回的话需要保存信息
                [[NSUserDefaults standardUserDefaults] setObject:[_user toDictionary] forKey:SAVE_RENTINFO_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if (weakSelf.isBackRoot) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } else {
        }
    }];
}

- (IBAction)onlineServiceClick:(UIButton *)sender {
    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = kCustomerServiceId;
    chatService.title = @"客服";
    chatService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :chatService animated:YES];
}

- (void)defaultSelectCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self updateUIWithIndePath:indexPath];
}

- (void)updateUIWithIndePath:(NSIndexPath *)indexPath {
    
    WEAK_SELF();
    [self.dataSource enumerateObjectsUsingBlock:^(ZZAuditFeeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        ZZServiceChargeCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.selectCurrent = NO;
    }];
    ZZServiceChargeCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
    cell.selectCurrent = YES;
}

// 是否打钩
- (IBAction)selectIconClick:(UIButton *)sender {
    sender.selected = sender.isSelected ? NO : YES;
}

- (IBAction)seeProtocolClick:(UIButton *)sender {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.rentalAuditServiceAgreement;
    controller.hidesBottomBarWhenPushed = YES;
    controller.navigationItem.title = @"出租审核服务协议";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoPayPriceWithIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:Event_click_ServiceCharge_Open];
    WEAK_SELF();
    ZZAuditFeeModel *model = _dataSource[indexPath.row];

    ZZPayViewController *vc = [ZZPayViewController new];
    vc.type = PayTypeRents;
    vc.price = [model.price intValue];
    vc.pId = model.id;
    [vc setDidPay:^{
        [weakSelf uploadRentInfo];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadRentInfo {
    
    [MobClick event:Event_chuzu_apply];
    [ZZHUD showWithStatus:@"正在提交..."];
    WeakSelf;
    [ZZUser rent:[_user toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            weakSelf.user.rent = user.rent;
//            [self managerStatusImage];
            [[ZZUserHelper shareInstance] saveLoginer:weakSelf.user postNotif:NO];
            
//            [self createShareView];
//            if (weakSelf.user.rent.status == 2 || weakSelf.user.rent.status == 3) {
//                weakSelf.shareView.applyLabel.text = @"修改成功";
//            } else {
//                weakSelf.shareView.applyLabel.text = @"申请成功";
//            }
            [NSObject asyncWaitingWithTime:0.5f completeBlock:^{
                [weakSelf gotoOpenSuccessVC];
            }];
        }
    }];
}

- (void)gotoOpenSuccessVC {
    
    NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    if (vcs.count >= 1) {
        [vcs removeObjectsInRange:NSMakeRange(1, vcs.count - 1)];
    }
    
    ZZOpenSuccessVC *vc = [ZZOpenSuccessVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.titleString = @"恭喜您开通成功";
    if (self.isRenew) {
        vc.titleString = @"恭喜您续费成功";
    }
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WEAK_SELF();
    ZZServiceChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZServiceChargeCell reuseIdentifier] forIndexPath:indexPath];
    [cell setupWithModel:self.dataSource[indexPath.row]];
    [cell setOpenBlock:^{
        [weakSelf gotoPayPriceWithIndexPath:indexPath];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self updateUIWithIndePath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);

    UILabel *label = [UILabel new];
    label.text = @"点击开通即表示您已阅读并同意";
    label.textColor = kBlackColor;
    label.font = [UIFont systemFontOfSize:14];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"《出租审核服务协议》" forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(seeProtocolClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.hidden = YES;
    [view addSubview:label];
    [view addSubview:button];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.leading.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.leading.equalTo(label.mas_trailing);
        make.top.bottom.equalTo(@0);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}


@end
