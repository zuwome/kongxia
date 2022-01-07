//
//  ZZKTVTasksController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVTasksController.h"
#import "ZZKTVTaskInfoController.h"

#import "ZZKTVTaskCell.h"
#import "ZZEmptyCell.h"

#import "ZZKTVConfig.h"

@interface ZZKTVTasksController () <UITableViewDelegate, UITableViewDataSource, ZZKTVTaskCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSArray<ZZKTVModel *> *tasksArray;

@end

@implementation ZZKTVTasksController

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

#pragma mark - ZZKTVTaskCellDelegate
- (void)cell:(ZZKTVTaskCell *)cell showDetails:(ZZKTVModel *)songModel {
    [self showTaskInfo:songModel];
}

- (void)cell:(ZZKTVTaskCell *)cell showUserInfo:(ZZUser *)userInfo {
    [self showUserInfo:userInfo];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tasksArray.count ?: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tasksArray.count == 0) {
        ZZEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZEmptyCell cellIdentifier] forIndexPath:indexPath];
        [cell configureData:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ZZKTVTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVTaskCell cellIdentifier] forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _tasksArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tasksArray.count > 0) {
        return UITableViewAutomaticDimension;
    }
    else {
        return SCREEN_HEIGHT;
    }
}


#pragma mark - Request Method
- (void)fresh {
    _pageSize = 1;
    [self fetchKTVList:_pageSize];
}

- (void)loadMore {
    _pageSize += 1;
    [self fetchKTVList:_pageSize];
}

- (void)fetchKTVList:(NSInteger)pageSize {
    [ZZKTVServer fetchKTVTasksListsWithPage:pageSize
                            completeHandler:^(BOOL isSuccess, NSArray<ZZKTVModel *> *list) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        if (!isSuccess) {
            return ;
        }
        
        if (_pageSize == 1) {
            _tasksArray = list;
            if (list.count > 0) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *arr = _tasksArray.mutableCopy;
            [arr addObjectsFromArray:list];
            _tasksArray = arr.copy;
        }
        [_tableView reloadData];
    }];
}


#pragma mark - Navigator
- (void)showTaskInfo:(ZZKTVModel *)taskModel {
    ZZKTVTaskInfoController *controller = [[ZZKTVTaskInfoController alloc] initWithTaskModel:taskModel];
    [_parentController.navigationController pushViewController:controller animated:YES];
}

- (void)showUserInfo:(ZZUser *)userInfo {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = userInfo.uid;
    [_parentController.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Layout
- (void)layout {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(245, 245, 245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 165;
    
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            [self fresh];
        }];
        
        [_tableView registerClass:[ZZKTVTaskCell class] forCellReuseIdentifier:[ZZKTVTaskCell cellIdentifier]];
        [_tableView registerClass:[ZZEmptyCell class] forCellReuseIdentifier:[ZZEmptyCell cellIdentifier]];
        
    }
    return _tableView;
}
@end
