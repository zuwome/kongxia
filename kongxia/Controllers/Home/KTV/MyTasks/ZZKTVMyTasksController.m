//
//  ZZMyYTasksController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVMyTasksController.h"
#import "ZZKTVTaskInfoController.h"

#import "ZZKTVMyTasksCell.h"
#import "ZZEmptyCell.h"

#import "ZZKTVConfig.h"

@interface ZZKTVMyTasksController () <UITableViewDelegate, UITableViewDataSource, ZZKTVMyTasksCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSArray<ZZKTVModel *> *tasksArray;

@end

@implementation ZZKTVMyTasksController

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


#pragma mark - ZZKTVMyTasksCellDelegate
- (void)cell:(ZZKTVMyTasksCell *)cell showDetails:(ZZKTVModel *)taskModel {
    [self showTaskInfo:taskModel];
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
        [cell configureData:3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ZZKTVMyTasksCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVMyTasksCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.taskModel = _tasksArray[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tasksArray.count > 0) {
        return UITableViewAutomaticDimension;
    }
    else {
        return SCREEN_HEIGHT;
    }
}

#pragma mark - Navigator
- (void)showTaskInfo:(ZZKTVModel *)taskModel {
    ZZKTVTaskInfoController *controller = [[ZZKTVTaskInfoController alloc] initWithTaskModel:taskModel];
    [_parentController.navigationController pushViewController:controller animated:YES];
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
    [ZZKTVServer fetchKTVMyTasksListsWithPage:pageSize
                              completeHandler:^(BOOL isSuccess, NSArray *list) {
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
        _tableView.estimatedRowHeight = 100;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            [self fresh];
        }];
        
        [_tableView registerClass:[ZZKTVMyTasksCell class] forCellReuseIdentifier:[ZZKTVMyTasksCell cellIdentifier]];
        [_tableView registerClass:[ZZEmptyCell class]
           forCellReuseIdentifier:[ZZEmptyCell cellIdentifier]];
        
    }
    return _tableView;
}

@end
