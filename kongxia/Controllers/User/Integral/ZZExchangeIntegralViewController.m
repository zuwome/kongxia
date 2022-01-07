//
//  ZZExchangeIntegralViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZExchangeIntegralViewController.h"
#import "ZZIntegralNaVView.h"
#import "ZZIntegralExchangeCell.h"//积分兑换
#import "ZZIntegralHelper.h"
#import "ZZIntegralExChangeDetailModel.h"
#import "ZZIntegralExChangeModel.h"

#import "ZZHeaderIntegralExChangeView.h"//总积分
#import "ZZfootIntegralExchangeView.h"//自定义数量
#import "ZZExChangeAlertView.h"
@interface ZZExchangeIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ZZIntegralExChangeModel *exChangeModel;
@property (nonatomic,strong) ZZHeaderIntegralExChangeView *headerView;
@property (nonatomic,strong) ZZfootIntegralExchangeView *footView;
@property (nonatomic,strong) ZZExChangeAlertView *alertView;
@property (nonatomic,assign) BOOL isHideNav;//判断上个界面是否需要隐藏

/**
 积分余额
 */
@property (nonatomic,strong) UILabel *IntegralBalanceLab;


@end

@implementation ZZExchangeIntegralViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        _isHideNav = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isHideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:Event_click_myIntegral_exChange];

    [self setUI];
    [self loadData];
}


- (void)loadData {

    [ZZHUD show];
    [ZZIntegralHelper requestExChanageIntegralListSuccess:^(ZZIntegralExChangeModel *model) {
        [ZZHUD dismiss];
        self.exChangeModel = model;
        self.headerView.integral = model.integral;
        [self.tableView reloadData];
    } failure:^(ZZError *error) {
        [ZZHUD showTastInfoErrorWithString:error.message];
    }];
}
/**
 设置UI
 */
- (void)setUI {
    //导航
    ZZIntegralNaVView *view = [[ZZIntegralNaVView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) titleNavLabTitile:@"积分兑换" rightTitle:nil];
    [self.view addSubview:view];
    
    [self.view addSubview:self.tableView];
    [self setUpTheConstraints];
    WS(weakSelf);
    view.leftNavClickBlock = ^{
        [ZZHUD dismiss];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}

#pragma  mark - tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZIntegralExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZIntegralExchangeCellID"];
    cell.model = self.exChangeModel.list[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exChangeModel.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ZZIntegralExChangeDetailModel *model = self.exChangeModel.list[indexPath.row];

    self.exChangeModel.selectIntegral = [NSString stringWithFormat:@"%ld",model.integral];
    NSString *eventClick = [NSString stringWithFormat:@"click_integralExChange_%ld",model.integral];
    [MobClick event:eventClick];

    [self showAlerView];
}

/**
 弹出积分兑换的弹窗
 */
- (void)showAlerView {
    ZZExChangeAlertView *alertView = [[ZZExChangeAlertView alloc]init];
    [alertView showAlerViewwithModel:self.exChangeModel];
    __weak typeof(alertView)weakAlertView= alertView;
    WS(weakSelf);
    alertView.exChangeBlock = ^(int exChangeNumber, UIButton *sender) {
        sender.enabled = NO;
        if (exChangeNumber>self.model.integral) {
            [weakAlertView dissMiss];
            [UIAlertController presentAlertControllerWithTitle:nil message:@"积分不足,无法兑换" doneTitle:@"我知道了" cancelTitle:nil showViewController:nil completeBlock:^(BOOL index) {
            }];
            return;
        }
        
        [ZZIntegralHelper exChangeIntegralNumber:exChangeNumber success:^{
            
            [weakAlertView dissMiss];
            sender.enabled = YES;
            [ZZHUD showTaskInfoWithSuccessStatus:[NSString stringWithFormat:@"成功兑换%d么币",exChangeNumber/(int)  weakSelf.exChangeModel.scale] time:1.5];
            weakSelf.model.integral -=exChangeNumber;
            weakSelf.exChangeModel.integral =  weakSelf.model.integral;
            weakSelf.headerView.integral =weakSelf.model.integral;
            if (weakSelf.changeBlock) {
                weakSelf.changeBlock(weakSelf.model);
            }
        } failure:^(ZZError *error) {
            sender.enabled = YES;
            [ZZHUD showTastInfoErrorWithString:error.message];
        }];
    };
}

#pragma mark - 约束

- (void)setUpTheConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(NAVIGATIONBAR_HEIGHT);
        make.bottom.offset(-SafeAreaBottomHeight);
    } ];
}



/**
 懒加载

 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableHeaderView.height = 66;
        _tableView.tableFooterView = self.footView;
        _tableView.tableFooterView.height = 66.5;
        [_tableView registerClass:[ZZIntegralExchangeCell class] forCellReuseIdentifier:@"ZZIntegralExchangeCellID"];
        _tableView.rowHeight = 66.5;
    }
    return _tableView;
}
- (ZZHeaderIntegralExChangeView *)headerView {
    if (!_headerView) {
        _headerView = [[ZZHeaderIntegralExChangeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
        
    }
    return _headerView;
}

- (ZZfootIntegralExchangeView *)footView {
    if (!_footView) {
        _footView = [[ZZfootIntegralExchangeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66.5)];
        WS(weakSelf);
        _footView.exChangeBlock = ^(UIButton *sender) {
            [MobClick event:Event_click_integralExChange_customNumber];
            weakSelf.exChangeModel.selectIntegral = nil;
            [weakSelf showAlerView];
        };
    }
    return _footView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
