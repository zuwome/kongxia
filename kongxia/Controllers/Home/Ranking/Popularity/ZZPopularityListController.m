//
//  ZZPopularityListController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPopularityListController.h"
#import "ZZRentViewController.h"
#import "ZZChatViewController.h"
#import "ZZPopularityVC.h"

#import "ZZPopularityListHeaderView.h"
#import "ZZRankingCell.h"
#import "ZZListRankView.h"


@interface ZZPopularityListController () <UITableViewDataSource,UITableViewDelegate, ZZListRankViewDelegate, ZZRankingCellDelegate, ZZPopularityListHeaderViewDelegate>

@property (nonatomic, strong) ZZPopularityListHeaderView *headerView;

@property (nonatomic, strong) ZZBaseTableView *tableView;

@property (nonatomic, strong) ZZListRankView *myRankView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, copy) NSArray<ZZUser *> *usersList;

@end

@implementation ZZPopularityListController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isTheFirstTime = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)configureData {
    NSArray<ZZUser *> *top3;
    if (_usersList.count <= 3) {
        top3 = _usersList;
    }
    else {
        top3 = [_usersList subarrayWithRange: NSMakeRange(0, 3)];
    }
    
    [_headerView configureTop3:top3];
    [_tableView reloadData];
}

#pragma mark - ZZListRankViewDelegate
- (void)view:(ZZListRankView *)view goChat:(ZZUser *)userInfo {
    [self fetchSayHiStatus:userInfo];
}

- (void)view:(ZZListRankView *)view showUserInfo:(ZZUser *)userInfo {
    [self showUserInfo:userInfo];
}

- (void)viewShowTips:(ZZListRankView *)view {
    [self showTips];
}

- (void)viewShowMine:(ZZListRankView *)view {
    [self showMine];
}


#pragma mark - ZZPopularityListHeaderViewDelegate
- (void)headerView:(ZZPopularityListHeaderView *)view showUserInfo:(ZZUser *)userInfo {
    [self showUserInfo:userInfo];
}


#pragma mark - ZZRankingCellDelegate
- (void)cell:(ZZRankingCell *)view showUserInfo:(ZZUser *)userInfo {
    [self showUserInfo:userInfo];
}

- (void)cell:(ZZRankingCell *)view goChat:(ZZUser *)userInfo {
    [self fetchSayHiStatus:userInfo];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _usersList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRankingCell cellIdentifier] forIndexPath:indexPath];
    [cell configureData:_usersList[indexPath.row] index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.1)];
}


#pragma mark - Navigator
- (void)showUserInfo:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = isNullString(user.user) ? user.uid : user.user;
    [_parentController.navigationController pushViewController:controller animated:YES];
}

- (void)chat:(ZZUser *)user {
    if (!user) {
        return;
    }
    
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    controller.nickName = user.nickname;
    controller.uid = isNullString(user.user) ? user.uid : user.user;
    controller.portraitUrl = [user displayAvatar];
    [_parentController.navigationController pushViewController:controller animated:YES];
}

- (void)showTips {
    ZZPopularityVC *vc = [[ZZPopularityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMine {
    ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
    if (controller.selectedIndex != 3) {
        [[ZZTabBarViewController sharedInstance] setSelectIndex:3];
    }
    [_parentController.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Request
- (void)fresh {
    _isTheFirstTime = NO;
    _pageIndex = 1;
    [self requestData:_pageIndex];
}

- (void)loadMore {
    _pageIndex += 1;
    [self requestData:_pageIndex];
}

- (void)requestData:(NSInteger)pageIndex {
    [ZZRequest method:@"GET"
                 path:@"/api/getUserPriorityRank"
               params:@{
                   @"uid": [ZZUserHelper shareInstance].loginer.uid,
                   @"pageIndex": @(pageIndex)
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        if (error) {
            [ZZHUD showErrorWithStatus: error.message];
            return ;
        }
        
        // 列表数据
        NSArray<ZZUser *> *array = [ZZUser arrayOfModelsFromDictionaries:data[@"list"] error:nil];
        if (pageIndex == 1) {
            _usersList = array;
            
            if (_usersList.count >= 0) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *users = _usersList.mutableCopy;
            [users addObjectsFromArray:array];
            _usersList = users.copy;
        }
        [self configureData];
        
        ZZUser *user = [ZZUserHelper shareInstance].loginer;
        // 我的排名
        if ([data[@"my_rank_info"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *rankInfo = data[@"my_rank_info"];
            if (rankInfo[@"is_top"]) {
                user.is_top = [rankInfo[@"is_top"] intValue];
            }
            if ([rankInfo[@"total_score"] isKindOfClass:[NSNumber class]]) {
                user.total_score = [rankInfo[@"total_score"] doubleValue];
            }
        }
        
        [_myRankView configureMyRank:user rank: [data[@"my_rank"] intValue] isRookie:NO];
        
    }];
}

- (void)fetchSayHiStatus:(ZZUser *)user {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/say_hi_status",user.user] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if ([[data objectForKey:@"say_hi_status"] integerValue] == 0) {
                if (loginedUser.avatar_manual_status == 1) {
                    if (![loginedUser didHaveOldAvatar]) {
                        [self showOkAlert:@"提示" 
                                  message:@"打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼"
                             confirmTitle:@"知道了"
                           confirmHandler:nil];
                    }
                    else {
                        [self chat:user];
                    }
                }
            }
            else {
                [self chat:user];
            }
        }
    }];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myRankView];
    
    [_myRankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.height.equalTo(@(80));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(_myRankView.mas_top);
    }];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZZBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            [self fresh];
        }];
        
        _headerView = [[ZZPopularityListHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 174)];
        _headerView.delegate = self;
        _tableView.tableHeaderView = _headerView;
        
        [_tableView registerClass:[ZZRankingCell class] forCellReuseIdentifier:[ZZRankingCell cellIdentifier]];
        
    }
    return _tableView;
}

- (ZZListRankView *)myRankView {
    if (!_myRankView) {
        _myRankView = [[ZZListRankView alloc] init];
        _myRankView.delegate = self;
    }
    return _myRankView;
}
@end
