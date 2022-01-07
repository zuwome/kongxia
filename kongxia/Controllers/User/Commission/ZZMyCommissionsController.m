//
//  ZZMyCommissionsController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyCommissionsController.h"
#import "ZZRentViewController.h"
#import "ZZMyConmmissionInfosController.h"
#import "ZZCommissionIndexViewController.h"

#import "ZZMyCommissionViews.h"
#import "ZZCommissionShareView.h"
#import "ZZCommissionShareToastView.h"

#import "ZZCommissionListModel.h"
#import "ZZCommissionModel.h"
#import "ZZCommossionManager.h"

@interface ZZMyCommissionsController () <UITableViewDataSource,UITableViewDelegate, ZZMyConmmissionInfosControllerDelegate, CommissionScrollHeaderViewDelegate, MyCommissionHeaderViewDelegate>

@property (nonatomic, strong) MyTableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) MyCommissionHeaderView *headerView;

@property (nonatomic, strong) CommissionScrollHeaderView *pageMenu;

@property (nonatomic, strong) UIScrollView *childVCScrollView;

@property (nonatomic, strong) ZZCommissionModel *inviteInfoModel;

@end

@implementation ZZMyCommissionsController

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldJump = NO;
        _currentPage = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationLayout];
    [self layout];
    [self addNotifications];
    [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showDetails];
    
    [[ZZCommossionManager manager] fetchInviteCodeInfos:^(BOOL isSuccess, ZZCommissionModel *commissionModel) {
        if (isSuccess) {
            _inviteInfoModel = commissionModel;
        }
    }];
}

#pragma mark - public Method
- (void)jumpTo:(CommissionDetailsType)type {
    _shouldJump = YES;
    _jumpType = type;
    [self showDetails];
}

#pragma mark - private method
- (void)showDetails {
    if (!_shouldJump) {
        return;
    }
    
    NSInteger index = -1;
    if (_jumpType == CommissionInvited) {
        index = 2;
    }
    _shouldJump = NO;
    if (index != -1 && _currentPage != index) {
        _currentPage = index;
        [UIView animateWithDuration:0.3 animations:^{
            [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
        }];
    }
}

- (void)loadData {
    [ZZHUD show];
    [[ZZCommossionManager manager] fetchDatasWithCompletBlock:^(BOOL isSuccess, ZZCommissionListModel *listModel, NSArray<ZZCommissionIncomModel *> *incomModelsArr, ZZCommissionInviteUserModel *invitedUser) {
        [ZZHUD dismiss];
        if (!isSuccess) {
            return ;
        }
        [_headerView configureIcomes:listModel];
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof ZZMyConmmissionInfosController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
            if (controller.type == CommissionIncome) {
                [controller configureDatas:incomModelsArr isRefreshing:YES];
            }
            else if (controller.type == CommissionInvited) {
                [controller configureDatas:invitedUser isRefreshing:YES];
            }
            else {
                [controller configureDatas:listModel isRefreshing:YES];
            }
        }];
    }];
}

// 下拉刷新
- (void)refresh {
    [[ZZCommossionManager manager] fetchDatasWithCompletBlock:^(BOOL isSuccess, ZZCommissionListModel *listModel, NSArray<ZZCommissionIncomModel *> *incomModelsArr, ZZCommissionInviteUserModel *invitedUser) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if (!isSuccess) {
            return ;
        }
        [_headerView configureIcomes:listModel];
        
        if (_currentPage < 0 || _currentPage >= 3) {
            return;
        }
        
        ZZMyConmmissionInfosController *controller = self.childViewControllers[_currentPage];
        if (controller.type == CommissionIncome) {
            [controller configureDatas:incomModelsArr isRefreshing:YES];
        }
        else if (controller.type == CommissionInvited) {
            [controller configureDatas:invitedUser isRefreshing:YES];
        }
        else {
            [controller configureDatas:listModel isRefreshing:YES];
        }
    }];
}

#pragma mark - response method
- (void)share {
    [self showShareView];
}

#pragma mark - MyCommissionHeaderViewdelegate
- (void)header:(MyCommissionHeaderView *)header enablePush:(BOOL)enablePush {
    [[ZZCommossionManager manager] enablePush:enablePush];;
}


#pragma mark - CommissionScrollHeaderViewDelegate
- (void)header:(CommissionScrollHeaderView *)header select:(NSInteger)index {
   
    _currentPage = index;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
    }];
}


#pragma mark - ZZMyConmmissionInfosControllerDelegat
- (void)controller:(ZZMyConmmissionInfosController *)controller showIncoms:(ZZCommissionListModel *)listModel {
    
}

- (void)controller:(ZZMyConmmissionInfosController *)controller showUserInfo:(ZZUser *)userInfo {
    [self showUserInfo:userInfo type:controller.type];
}

- (void)controllerShowRules:(ZZMyConmmissionInfosController *)controller {
    [self showIndexView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewScrollPositionNone;
    // 添加分页菜单
    [cell.contentView addSubview:self.pageMenu];
    [cell.contentView addSubview:self.scrollView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT;
}

#pragma mark -- UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView == scrollView) {
        if ((self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) || (scrollView.contentOffset.y > HeaderViewH)) {
            self.tableView.contentOffset = CGPointMake(0, HeaderViewH);
        }
        CGFloat offSetY = scrollView.contentOffset.y;

        if (offSetY < HeaderViewH) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"headerViewToTop" object:nil];
        }
    }
    else if (scrollView == self.scrollView) {
        [_pageMenu offetSet:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        _currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    }
}

#pragma mark - Notification Method
- (void)addNotifications {
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTableViewDidScroll:) name:@"SubTableViewDidScroll" object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)subTableViewDidScroll:(NSNotification *)noti {
    UIScrollView *scrollView = noti.object;
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < HeaderViewH) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
        
    } else {
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

#pragma mark Navigator
- (void)showUserInfo:(ZZUser *)user type:(CommissionDetailsType)type {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    if (type == CommissionIncome) {
        controller.uid = user._id;
    }
    else {
        controller.uid = user.uuid;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showIndexView {
    ZZCommissionIndexViewController *shareVc = [[ZZCommissionIndexViewController alloc] init];
    [self.navigationController pushViewController:shareVc animated:YES];
}

- (void)showShareView {
    ZZCommissionShareView *view = [[ZZCommissionShareView alloc] initWithInfoModel:_inviteInfoModel frame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT) entry:CommissionChannelEntryMyCommission];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)showRules {
    [self showIndexView];
}

#pragma mark - Layout
- (void)navigationLayout {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 70, 21);
    [btn setTitle:@"规则" forState:UIControlStateNormal];
    [btn setTitle:@"规则" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(showRules) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[rightBarButon];
}

- (void)layout {
    self.title = @"已获得平台分红";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    
    // 添加子控制器
    ZZMyConmmissionInfosController *vc1 = [[ZZMyConmmissionInfosController alloc] initWithCommissionDetailsType:CommissionIncome];
    vc1.delegate = self;
    vc1.view.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - insert);
    
    ZZMyConmmissionInfosController *vc2 = [[ZZMyConmmissionInfosController alloc] initWithCommissionDetailsType:CommissionDetails];
    vc2.delegate = self;
    vc2.view.frame = CGRectMake(SCREEN_WIDTH, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - insert);

    ZZMyConmmissionInfosController *vc3 = [[ZZMyConmmissionInfosController alloc] initWithCommissionDetailsType:CommissionInvited];
    vc3.delegate = self;
    vc3.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - insert);
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    [self.scrollView addSubview:self.childViewControllers[1].view];
    [self.scrollView addSubview:self.childViewControllers[2].view];
    
    // 添加头部视图
    self.tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15.0);
        make.right.equalTo(self.view).offset(-15.0);
        make.height.equalTo(@50.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-30.0);
        } else {
            make.bottom.equalTo(self.view).offset(-15.0);
        }
    }];
}

#pragma mark - getters and setters
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.normalTitle = @"邀请好友";
        _shareBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _shareBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.backgroundColor = kGoldenRod;
        _shareBtn.layer.cornerRadius = 24.5;
    }
    return _shareBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, PageMenuH, SCREEN_WIDTH, SCREEN_HEIGHT-insert);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}

- (MyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MyTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            [self refresh];
        }];
    }
    return _tableView;
}


- (MyCommissionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MyCommissionHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeaderViewH);
        _headerView.layer.masksToBounds = NO;
        _headerView.delegate = self;
    }
    return _headerView;
}

- (CommissionScrollHeaderView *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [[CommissionScrollHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, PageMenuH)];
        _pageMenu.delegate = self;
    }
    return _pageMenu;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
