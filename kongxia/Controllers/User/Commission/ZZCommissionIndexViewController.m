//
//  ZZCommissionIndexViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionIndexViewController.h"
#import "ZZMyCommissionsController.h"
#import "ZZPopularityVC.h"

#import "ZZCommissionShareView.h"
#import "ZZCommissionIndexCell.h"
#import "ZZCommissionPopulationCell.h"

#import "ZZCommissionModel.h"

@interface ZZCommissionIndexViewController ()<UITableViewDelegate, UITableViewDataSource, ZZCommissionPopulationCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *myCommissionsTopBtn;

@property (nonatomic, strong) UIButton *myCommissionsBtn;

@property (nonatomic, strong) UIButton *inviteBtn;

@property (nonatomic, copy) ZZCommissionModel *infoModel;

@end

@implementation ZZCommissionIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - response method
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMyCommissions {
    [self jumpToMyCommission];
}

- (void)invite {
    if ([ZZUtils isBan]) {
        [ZZHUD showErrorWithStatus:@"您已被封禁"];
        return;
    }
    ZZCommissionShareView *view = [[ZZCommissionShareView alloc] initWithInfoModel:_infoModel frame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT) entry:CommissionChannelEntryMyCommission];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

#pragma mark - ZZCommissionPopulationCellDelegate
- (void)cellshowInvitedView:(ZZCommissionPopulationCell *)cell {
    [self showRules];
}

#pragma mark - ZZMyCommissionViewController
- (void)showInviteView:(ZZMyCommissionsController *)controller {
    [self invite];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZZCommissionIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommissionIndexCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commissionModel = _infoModel;
        return cell;
    }
    else if (indexPath.section == 1) {
        ZZCommissionPopulationCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommissionPopulationCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.commissionModel = _infoModel;
        return cell;
    }
    else {
        ZZCommissionPopulationCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommissionPopulationCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 20.0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self showRules];
    }
    else if (indexPath.section == 2) {
        [self jumpToPopularity];
    }
}

#pragma mark - Navigator
- (void)showRules {
    if (isNullString(_infoModel.tip.url)) {
        return;
    }
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = _infoModel.tip.url;
    controller.navigationItem.title = @"收入分红规则详情";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)jumpToMyCommission {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToPopularity {
    ZZPopularityVC *vc = [[ZZPopularityVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request
- (void)fetchData {
    [ZZRequest method:@"GET" path:@"/api/getUserInviteCode" params:@{@"id": [ZZUserHelper shareInstance].loginer.uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
//            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            _infoModel = [ZZCommissionModel yy_modelWithDictionary:data];
            [_tableView reloadData];
        }
    }];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = RGBCOLOR(253, 232, 3);
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myCommissionsBtn];
    [self.view addSubview:self.inviteBtn];
    [self.view addSubview:self.myCommissionsTopBtn];
    [self.view addSubview:self.backBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_myCommissionsTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(24.5);
        }
        else {
            make.top.equalTo(self.view).offset(24.5);
        }
        make.right.equalTo(self.view).offset(8);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_myCommissionsTopBtn);
        make.left.equalTo(self.view).offset(0.0);
        make.size.mas_equalTo(CGSizeMake(44, 30));
    }];
    
    CGFloat offset = (SCREEN_WIDTH - 170 * 2 - 15) / 2 ;
    [_myCommissionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-32.5);
        } else {
            make.bottom.equalTo(self.view).offset(-32.5);
        }
        make.left.equalTo(self.view).offset(offset);
        make.size.mas_equalTo(CGSizeMake(170, 72));
    }];
    
    [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_myCommissionsBtn);
        make.left.equalTo(_myCommissionsBtn.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(170, 72));
    }];
}

- (void)createLayout {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _tableView.bounds;
        
        gradient.colors = @[(id)RGBCOLOR(255, 224, 9).CGColor, (id)RGBCOLOR(248, 205, 7).CGColor, (id)RGBCOLOR(253, 232, 3).CGColor];
        gradient.locations = @[@0.0, @0.3, @0.8];
        
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 1);
        
       
        NSMutableArray<CALayer *> *layers = _tableView.layer.sublayers.mutableCopy;
        [layers insertObject:gradient atIndex:0];
        _tableView.layer.sublayers = layers.copy;
    });
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[ZZCommissionIndexCell class] forCellReuseIdentifier:[ZZCommissionIndexCell cellIdentifier]];
        
        [_tableView registerClass:[ZZCommissionPopulationCell class] forCellReuseIdentifier:[ZZCommissionPopulationCell cellIdentifier]];
         UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 265)];
            imageView.image = [UIImage imageNamed:@"commissionIndex"];
        _tableView.tableHeaderView = imageView;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 90.0)];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

- (UIButton *)myCommissionsBtn {
    if (!_myCommissionsBtn) {
        _myCommissionsBtn = [[UIButton alloc] init];
        _myCommissionsBtn.normalImage = [UIImage imageNamed:@"btnCkwdfh"];
        [_myCommissionsBtn addTarget:self action:@selector(showMyCommissions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myCommissionsBtn;
}

- (UIButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [[UIButton alloc] init];
        _inviteBtn.normalImage = [UIImage imageNamed:@"btnQyq"];
        [_inviteBtn addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}

- (UIButton *)myCommissionsTopBtn {
    if (!_myCommissionsTopBtn) {
        _myCommissionsTopBtn = [[UIButton alloc] init];
        _myCommissionsTopBtn.normalTitle = @"我的分红";
        _myCommissionsTopBtn.normalTitleColor = RGBCOLOR(252, 108, 43);
        _myCommissionsTopBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13.0];
        _myCommissionsTopBtn.backgroundColor = RGBACOLOR(255, 255, 255, 0.62);
        // 省事
        _myCommissionsTopBtn.layer.borderColor = RGBACOLOR(255, 255, 255, 0.8).CGColor;
        _myCommissionsTopBtn.layer.borderWidth = 1;
        _myCommissionsTopBtn.layer.cornerRadius = 13;
        [_myCommissionsTopBtn addTarget:self action:@selector(showMyCommissions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myCommissionsTopBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.normalImage = [UIImage imageNamed:@"icBack_white"];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
