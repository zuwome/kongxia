//
//  ZZRechargeViewController.m
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRechargeViewController.h"

#import "ZZWalletHeadView.h"
#import "ZZWalletInputCell.h"
#import "ZZWalletTypeCell.h"
#import "ZZTransfer.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZZNewTiXianViewController.h"//新版的提现

#import "ZZRealNameListViewController.h"

#import "Pingpp.h"

@interface ZZRechargeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) ZZWalletHeadView *headView;
@property (nonatomic, assign) NSInteger selecteIndex;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) NSNumber *amount;

/**
 底部的提示
 */
@property (nonatomic, strong) UILabel *boomLab;
@end

@implementation ZZRechargeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"账户余额";
    [self creatRightBarButtonUI];
    _selecteIndex = 2;
    if (_balance) {
        [self createViews];
    } else {
        [self loadDataWithRechargeStyle:NO];
    }
}

- (void)creatRightBarButtonUI {
    UIButton  *rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarItem addTarget:self action:@selector(rightBarbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    rightBarItem.frame = CGRectMake(0, 0, 60, 44);
    [rightBarItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarItem setTitle:@"提现" forState:UIControlStateNormal];
    rightBarItem.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
    self.navigationItem.rightBarButtonItems = @[rightBarButon];
}

- (void)rightBarbuttonAction {
    if ([self canTixian:YES]) {
        [self gotoTixian];
    }
}

- (BOOL)canTixian:(BOOL)shouldShowAlert {
    if ([ZZUtils isConnecting]) {
        return NO;
    }
    
    ZZUser *user = [ZZUserHelper shareInstance].loginer;
    
    if (!shouldShowAlert) {
        if (user.faces.count == 0) {
            [self gotoLiveCheck];
        }
        else {
            [self gotoRealName];
            
        }
        return NO;
    }
    else if (![ZZUtils isIdentifierAuthority:user]) {
        [UIAlertView showWithTitle:@"提示" message:@"为保障您的资金安全，提现需要实名认证，是否去认证？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"认证"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"认证"]) {
                if (user.faces.count == 0) {
                    [self gotoLiveCheck];
                }
                else {
                    [self gotoRealName];
                    
                }
            }
        }];
        return NO;
    }
    
    return YES;
}

- (void)gotoTixian
{
    [MobClick event:Event_click_money_transfer];
    
    ZZNewTiXianViewController *controller = [[ZZNewTiXianViewController alloc] init];
    controller.isTiXian = YES;
    controller.user = [ZZUserHelper shareInstance].loginer;
    WS(weakSelf);
    controller.tiXianBlock = ^{
       NSLog(@"PY_提现成功刷新数据");
        [weakSelf loadDataWithRechargeStyle:YES];
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoLiveCheck
{
    ZZUser * user = [ZZUserHelper shareInstance].loginer;
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeCashWithdrawal inController:self];
    helper.user = user;
    [helper setCheckSuccess:^{
        if ([self canTixian:NO]) {
            [self gotoTixian];
        }
    }];
    [helper start];
}

- (void)gotoRealName
{
    ZZUser * user = [ZZUserHelper shareInstance].loginer;
    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
    controller.user = user;
    controller.isTiXian = YES;
    [controller setSuccessCallBack:^{
        if ([self canTixian:NO]) {
            [self gotoTixian];
        }
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navigationLeftBtnClick {
    [super navigationLeftBtnClick];
    [self leftBtnClick];
}

- (void)leftBtnClick
{
    
    if (_leftCallBack) {
        _leftCallBack();
    }
}


/**
 更新余额是否是充值完成的

 @param isRecharge yes 是  No首次进入
 */
- (void)loadDataWithRechargeStyle:(BOOL)isRecharge
{
    [ZZUserHelper getUserBalanceRecordWithParam:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _balance = data[@"balance"];
            _forzen = [NSString stringWithFormat:@"锁定余额（元）：%.2f",[data[@"frozen"] doubleValue]];
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            loginer.balance = data[@"balance"];
            loginer.forzen = _forzen;
            [[ZZUserHelper shareInstance] saveLoginer:[loginer toDictionary] postNotif:NO];
            if (isRecharge) {
                if (self.rechargeCallBack) {
                    self.rechargeCallBack();
                }
                _headView.balanceLabel.text = [NSString stringWithFormat:@"%.2f", [_balance doubleValue]];
                _headView.lockMoneyLabel.text = _forzen;
                return ;
            }
            [self createViews];
        }
    }];
}

- (void)createViews
{
    _tableView = [[TPKeyboardAvoidingTableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = kBGColor;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _headView = [[ZZWalletHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    _tableView.tableHeaderView = _headView;
    _tableView.tableFooterView = [self createFootView];
    
    _headView.balanceLabel.text = [NSString stringWithFormat:@"%.2f", [_balance doubleValue]];
    _headView.lockMoneyLabel.text = _forzen;
    
    _amount = [NSNumber numberWithDouble:10];
    [self.doneBtn setTitle:[NSString stringWithFormat:@"确认充值10元"] forState:UIControlStateNormal];
    [self setUpTheConstraints];

}

- (UIView *)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 50)];
    [_doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.layer.cornerRadius = 5;
    _doneBtn.backgroundColor = kYellowColor;
    [footView addSubview:_doneBtn];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = kGrayContentColor;
//    label.font = [UIFont systemFontOfSize:12];
//    label.text = @"充值金额可提现";
//    [footView addSubview:label];
//
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(footView.mas_centerX);
//        make.top.mas_equalTo(_doneBtn.mas_bottom).offset(8);
//    }];
    
    return footView;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    if (indexPath.row == 0) {
        static NSString *identifier = @"inputcell";
        
        ZZWalletInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZWalletInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textField.placeholder = @"请输入充值金额（元）";
        cell.moneyChanged = ^(NSString *money) {
            if (isNullString(money)) {
                weakSelf.amount = nil;
                [weakSelf.doneBtn setTitle:@"确认充值0元" forState:UIControlStateNormal];
            } else {
                weakSelf.amount = [NSNumber numberWithDouble:[money doubleValue]];
                [weakSelf.doneBtn setTitle:[NSString stringWithFormat:@"确认充值%@元",money] forState:UIControlStateNormal];
            }
        };
        
        return cell;
    } else {
        static NSString *identifier = @"typecell";
        
        ZZWalletTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZWalletTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell setViewToRight];
        cell.titleLabel.text = @"充值方式";
        cell.wxBtn.selected = YES;
        cell.zfbBtn.hidden = YES;
        _selecteIndex = 1;
        WeakSelf;
        cell.selectedIndex = ^(NSInteger index){
            weakSelf.selecteIndex = index;
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 175:50;
}

#pragma mark - UIButtonMethod

- (void)doneBtnClick
{
    if (!_amount) {
        [ZZHUD showErrorWithStatus:@"请输入充值金额"];
        return;
    }
    if ([_amount doubleValue] == 0) {
        [ZZHUD showErrorWithStatus:@"充值不能为空"];
        return;
    }
    if ([ZZUtils compareWithValue1:_amount value2:[NSNumber numberWithInteger:5]] == NSOrderedAscending || [ZZUtils compareWithValue1:_amount value2:[NSNumber numberWithInteger:5000]] == NSOrderedDescending) {
        [ZZHUD showErrorWithStatus:@"充值额度请控制在5~5000内"];
        return;
    }
    
    NSString *channel = @"alipay";
    if (_selecteIndex == 1) {
        channel = @"wx";
    }
    
    NSDictionary *param = @{@"channel":channel,
                            @"amount":_amount,
                            @"pingxxtype": @"kxp",
                            };
    ZZTransfer *model = [[ZZTransfer alloc] init];
    [model rechargeWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            WeakSelf;
            [Pingpp createPayment:data
                   viewController:self
                     appURLScheme:@"kongxia"
                   withCompletion:^(NSString *result, PingppError *error) {
                       if ([result isEqualToString:@"success"]) {
                         
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf loadDataWithRechargeStyle:YES];
                               [ZZHUD showSuccessWithStatus:@"充值成功"];
                           });
                       } else {
                           // 支付失败或取消
                           [ZZHUD showErrorWithStatus:@"支付失败"];
                           NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                       }
                   }];
        }
    }];
}

- (void)setUpTheConstraints {
    
    [self.view addSubview:self.boomLab];
    [self.boomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(_doneBtn.mas_bottom).with.offset(25);
    }];
}
/**
 底部的提示

 */
- (UILabel *)boomLab {
    if (!_boomLab) {
        _boomLab = [[UILabel alloc]init];
        _boomLab.text = @"充值金额可提现";
        _boomLab.textColor = RGBCOLOR(102, 102, 102);
        _boomLab.textAlignment = NSTextAlignmentCenter;
        _boomLab.font = [UIFont systemFontOfSize:13.0];
//        NSString *boomString = @"平台保障\n* 充值的资金仅用于平台内使用\n* 充值成功后，资金将进入您的钱包余额，由平台统一监管\n* 充值的资金可随时提取";
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:boomString];
//        _boomLab.textAlignment = NSTextAlignmentLeft;
//        _boomLab.font = [UIFont systemFontOfSize:13];
//        _boomLab.numberOfLines = 0;
//        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//
//         [paragraphStyle1 setLineSpacing:5.f];
//        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [boomString length])];
//
//        NSRange range_pingTai = [boomString rangeOfString:@"平台保障"];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:[UIColor blackColor]
//                           range:NSMakeRange(0,range_pingTai.length)];
//
//
//        NSRange range_first = [boomString rangeOfString:@"* 充值的资金仅用于平台内使用"];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:RGBCOLOR(244, 203, 7)
//                           range:NSMakeRange(range_first.location,1)];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:kGrayContentColor
//                           range:NSMakeRange(range_first.location+1,range_first.length-1)];
//
//
//        NSRange range_second = [boomString rangeOfString:@"* 充值成功后，资金将进入您的钱包余额，由平台统一监管"];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:RGBCOLOR(244, 203, 7)
//                           range:NSMakeRange(range_second.location,1)];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:kGrayContentColor
//                           range:NSMakeRange(range_second.location+1,range_second.length-1)];
//
//
//
//        NSRange range_thrid = [boomString rangeOfString:@"* 充值的资金可随时提取"];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:RGBCOLOR(244, 203, 7)
//                           range:NSMakeRange(range_thrid.location,1)];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:kGrayContentColor
//                           range:NSMakeRange(range_thrid.location+1,range_thrid.length-1)];
//
//        [_boomLab setAttributedText:attrString];

    }
    return _boomLab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
