//
//  ZZMyConmmissionInfosController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyConmmissionInfosController.h"

#import "ZZCommissionDetailCell.h"
#import "ZZCommissionEmptyCell.h"
#import "ZZCommisssionIncomCell.h"
#import "ZZCommissionInviteCell.h"
#import "ZZCommissionInfoHeaderView.h"

#import "ZZCommissionListModel.h"
#import "ZZCommissionIncomModel.h"
#import "ZZCommissionInviteUserModel.h"
#import "ZZCommissionInviteUserModel.h"

#import "ZZCommossionManager.h"

@interface ZZMyConmmissionInfosController () <UITableViewDataSource,UITableViewDelegate, ZZCommissionEmptyCellDelegate, ZZCommisstionInfoCellDelegate, ZZCommissionInviteCellDelegate, ZZCommisssionIncomCellDelegate>

@property (nonatomic, strong) ZZBaseTableView *tableView;

@property (nonatomic, assign) NSInteger rowCount;

@property (nonatomic, copy) NSArray<ZZCommissionIncomModel *> * incomeListArr;

@property (nonatomic, strong) ZZCommissionListModel *listModel;

@property (nonatomic, strong) ZZCommissionInviteUserModel *invitedUserModel;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ZZMyConmmissionInfosController

- (instancetype)initWithCommissionDetailsType:(CommissionDetailsType)type {
    self = [super init];
    if (self) {
        _type = type;
        _pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    [self addNotifications];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - PageMenuH);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public Method
- (void)configureDatas:(id)data isRefreshing:(BOOL)isRefreshing {
    if (_type == CommissionIncome) {
        NSArray<ZZCommissionIncomModel *> *list = (NSArray<ZZCommissionIncomModel *> *)data;
        
        if (isRefreshing) {
            _pageIndex = 1;
            _incomeListArr = list;
            
            if (_incomeListArr.count >= 10) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *listArr = _incomeListArr.mutableCopy;
            if (!listArr) {
                listArr = @[].mutableCopy;
            }
            [listArr addObjectsFromArray:list];
            _incomeListArr = listArr.copy;
        }
    }
    else if (_type == CommissionInvited) {
        ZZCommissionInviteUserModel *invitedUserModel = (ZZCommissionInviteUserModel *)data;
        
        if (isRefreshing) {
            _pageIndex = 1;
            _invitedUserModel = invitedUserModel;
            
            if (_incomeListArr.count >= 10) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *listArr = _invitedUserModel.allUserList.mutableCopy;
            if (!listArr) {
                listArr = @[].mutableCopy;
            }
            [listArr addObjectsFromArray:invitedUserModel.allUserList];
            invitedUserModel.allUserList = listArr.copy;
            _invitedUserModel = invitedUserModel;
        }
    }
    else {
        ZZCommissionListModel *listModel = (ZZCommissionListModel *)data;
        
        if (_type == CommissionDetails) {
            NSArray<ZZCommissionUserModel *> *listArr = listModel.allUserList;
            NSMutableArray *listM = @[].mutableCopy;
            [listArr enumerateObjectsUsingBlock:^(ZZCommissionUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.total_money != 0) {
                    [listM addObject: obj];
                }
            }];
            listModel.earnedAllUserList = listM.copy;
            [listModel configureData];
        }
        
        if (isRefreshing) {
            _pageIndex = 1;
            _listModel = listModel;
            
            if (_listModel.allUserList.count >= 10) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *listArr = _listModel.allUserList.mutableCopy;
            if (!listArr) {
                listArr = @[].mutableCopy;
            }
            [listArr addObjectsFromArray:listModel.allUserList];
            listModel.allUserList = listArr.copy;
            _listModel = listModel;
        }
    }
    
    [_tableView reloadData];
}


#pragma mark - private method
// 上拉加载
- (void)loadMore {
    if (_type == CommissionIncome) {
        [[ZZCommossionManager manager] fetchIncomesWithPageIndex:_pageIndex + 1 completBlock:^(BOOL isSuccess, NSArray<ZZCommissionIncomModel *> *incomModelsArr) {
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (!isSuccess) {
                return ;
            }
            
            NSMutableArray *listArr = _incomeListArr.mutableCopy;
            if (!listArr) {
                listArr = @[].mutableCopy;
            }
            [listArr addObjectsFromArray:incomModelsArr];
            _incomeListArr = listArr.copy;
            
            
            [_tableView reloadData];
            
            _pageIndex ++;
        }];
    }
    else if (_type == CommissionInvited) {
        [[ZZCommossionManager manager] fetchInviteWithPageIndex:_pageIndex + 1 completBlock:^(BOOL isSuccess, ZZCommissionInviteUserModel *listModel) {
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (!isSuccess) {
                return ;
            }
            
            NSMutableArray *listArr = _invitedUserModel.allUserList.mutableCopy;
            if (!listArr) {
                listArr = @[].mutableCopy;
            }
            [listArr addObjectsFromArray:listModel.allUserList];
            listModel.allUserList = listArr.copy;
            _invitedUserModel = listModel;
            
            [_tableView reloadData];
            
            _pageIndex ++;
        }];
    }
    else {
        [[ZZCommossionManager manager] fetchListsWithPageIndex:_pageIndex + 1 completBlock:^(BOOL isSuccess, ZZCommissionListModel *listModel) {
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (!isSuccess) {
                return ;
            }
            
            NSMutableArray *listArr = _listModel.allUserList.mutableCopy;
            if (!listArr) {
                listArr = @[].mutableCopy;
            }
            
            [listArr addObjectsFromArray:listModel.allUserList];
            listModel.allUserList = listArr.copy;
            
            if (_type == CommissionDetails) {
                NSArray<ZZCommissionUserModel *> *listArr = listModel.allUserList;
                NSMutableArray *listM = @[].mutableCopy;
                [listArr enumerateObjectsUsingBlock:^(ZZCommissionUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.total_money != 0) {
                        [listM addObject: obj];
                    }
                }];
                listModel.earnedAllUserList = listM.copy;
                [listModel configureData];
            }
            
            _listModel = listModel;
            
            [_tableView reloadData];
            
            _pageIndex ++;
        }];
    }
}


#pragma mark - ZZCommissionEmptyCellDelegate
- (void)cell:(ZZCommissionEmptyCell *)cell btnAction:(CommissionDetailsType)type {
    if (_type == CommissionIncome) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(controllerShowRules:)]) {
            [self.delegate controllerShowRules:self];
        }
    }
}


#pragma mark - ZZCommissionInviteCellDelegate
- (void)inviteCell:(ZZCommissionInviteCell *)cell showUserInfo:(ZZCommissionInviteUserInfoModel *)userModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:showUserInfo:)]) {
        [self.delegate controller:self showUserInfo:userModel.to];
    }
}

- (void)inviteCell:(ZZCommissionInviteCell *)cell reminder:(ZZCommissionInviteUserInfoModel *)userModel action:(NSInteger)action {
    // 0:达人 1:微信
    [[ZZCommossionManager manager] remindUser:action user:userModel.to complete:^(BOOL isComplete) {
        if (isComplete) {
            NSMutableArray *uids = [ZZUserHelper shareInstance].remindedUID.mutableCopy;
            if (!uids) {
                uids = @[].mutableCopy;
            }
            if (![uids containsObject:userModel.to.uuid]) {
                [uids addObject:userModel.to.uuid];
            }
            [ZZUserHelper shareInstance].remindedUID = uids.copy;
            [_tableView reloadData];
        }
    }];
}


#pragma mark - ZZCommisssionIncomCellDelegate
- (void)incomeCell:(ZZCommisssionIncomCell *)cell showUserInfo:(ZZUser *)user {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:showUserInfo:)]) {
        [self.delegate controller:self showUserInfo:user];
    }
}


#pragma mark - ZZCommisstionInfoCellDelegate
- (void)view:(ZZCommissionInfoHeaderView *)cell showUserInfo:(ZZUser *)user {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:showUserInfo:)]) {
        [self.delegate controller:self showUserInfo:user];
    }
}

- (void)viewShouldShowDetails:(ZZCommissionInfoHeaderView *)view {
    NSInteger i = view.tag;
    self.listModel.earnedAllUserList[i].shouldShowDetails = !self.listModel.earnedAllUserList[i].shouldShowDetails;
    [_tableView reloadData];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_type == CommissionIncome) {
        return self.incomeListArr.count == 0 ? 1 : self.incomeListArr.count;
    }
    else if (_type == CommissionDetails) {
        return self.listModel.earnedAllUserList.count == 0 ? 1 : self.listModel.earnedAllUserList.count;
    }
    else {
        return self.invitedUserModel.allUserList.count == 0 ? 1 : self.invitedUserModel.allUserList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == CommissionDetails) {
        if (self.listModel.earnedAllUserList.count == 0) {
            return 1;
        }
        else {
            if (!self.listModel.earnedAllUserList[section].shouldShowDetails) {
                return 0;
            }
            return 1;
        }
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((_type == CommissionDetails && self.listModel.earnedAllUserList.count == 0) ||
        (_type == CommissionIncome && self.incomeListArr.count == 0) ||
        (_type == CommissionInvited && self.invitedUserModel.allUserList.count == 0)) {
        ZZCommissionEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommissionEmptyCell cellIdentifier] forIndexPath:indexPath];
        cell.delegate = self;
        cell.type = _type;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        if (_type == CommissionDetails) {
            ZZCommissionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommissionDetailCell cellIdentifier] forIndexPath:indexPath];
            [cell configureUserModel:_listModel.earnedAllUserList[indexPath.section]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (_type == CommissionIncome) {
            ZZCommisssionIncomCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommisssionIncomCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.incomeModel = _incomeListArr[indexPath.section];
            cell.delegate = self;
            return cell;
        }
        else {
            ZZCommissionInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCommissionInviteCell cellIdentifier] forIndexPath:indexPath];
            cell.userModel = _invitedUserModel.allUserList[indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((_type == CommissionDetails && self.listModel.allUserList.count == 0) ||
       (_type == CommissionIncome && self.incomeListArr.count == 0) ||
       (_type == CommissionInvited && self.invitedUserModel.allUserList.count == 0)) {
       return 300;
   }
    if (_type == CommissionDetails) {
        if (self.listModel.earnedAllUserList.count == 0) {
            return 400;
        }
        else {
            return UITableViewAutomaticDimension;
        }
    }
    else {
        return 90;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_type == CommissionDetails) {
        if (_listModel.earnedAllUserList.count != 0) {
            return 90.0;
        }
        return 0.1;
    }
    else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_type == CommissionDetails) {
        if (_listModel.earnedAllUserList.count != 0) {
            ZZCommissionInfoHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZZCommisstionInfoHeaderView"];
            if (!view) {
                view = [[ZZCommissionInfoHeaderView alloc] initWithReuseIdentifier:@"ZZCommisstionInfoHeaderView"];
                view.delegate = self;
            }
            view.tag = section;
            if (_listModel && _listModel.earnedAllUserList.count > 0) {
                view.userCommissionModel = _listModel.earnedAllUserList[section];
            }
            return view;
        }
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_type == CommissionDetails) {
        return 10.0;
    }
    else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_type == CommissionDetails) {
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10.0)];
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.1)];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubTableViewDidScroll" object:scrollView];
}


#pragma mark - Notification Method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageTitleViewToTop) name:@"headerViewToTop" object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pageTitleViewToTop {
    self.tableView.contentOffset = CGPointZero;
}


#pragma mark - Layout
- (void)layout {
     [self.view addSubview:self.tableView];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZZBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - PageMenuH) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.01f)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 65 + 10)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 110;
        _tableView.estimatedSectionHeaderHeight = 90;
        _tableView.estimatedSectionFooterHeight = 0;
        
        [_tableView registerClass:[ZZCommissionDetailCell class] forCellReuseIdentifier:[ZZCommissionDetailCell cellIdentifier]];
        
        [_tableView registerClass:[ZZCommissionEmptyCell class] forCellReuseIdentifier:[ZZCommissionEmptyCell cellIdentifier]];
        
        [_tableView registerClass:[ZZCommisssionIncomCell class] forCellReuseIdentifier:[ZZCommisssionIncomCell cellIdentifier]];
        
        [_tableView registerClass:[ZZCommissionInviteCell class] forCellReuseIdentifier:[ZZCommissionInviteCell cellIdentifier]];
    }
    return _tableView;
}

@end
