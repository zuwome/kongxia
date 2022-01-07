//
//  ZZTaskLikesViewModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskLikesViewModel.h"
#import "ZZTaskLikeCell.h"
#import "ZZTaskLikeModel.h"
#import "ZZTasksServer.h"

@interface ZZTaskLikesViewModel ()<UITableViewDelegate, UITableViewDataSource, ZZTaskLikeCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSString *taskID;

@property (nonatomic, copy) NSArray<ZZTaskLikeModel *> *likesArray;

@property (nonatomic, copy) NSArray<TaskLikesListItem *> *itemsArray;

@end

@implementation ZZTaskLikesViewModel

- (instancetype)initWithTaskID:(NSString *)taskID tableView:(nonnull UITableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _taskID = taskID;
        [self configureTableView];
        [self fetchTaskLikes:nil];
    }
    return self;
}

- (void)configureTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [self fetchTaskLikes:nil];
    }];
    
    [_tableView registerClass:[ZZTaskLikeCell class]
       forCellReuseIdentifier:[ZZTaskLikeCell cellIdentifier]];
}

/**
 创建视图
 */
- (void)createCells {
    __block NSMutableArray<TaskLikesListItem *> *itemsArray = @[].mutableCopy;
    [_likesArray enumerateObjectsUsingBlock:^(ZZTaskLikeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TaskLikesListItem *item = [[TaskLikesListItem alloc] initWithLikeModel:obj];
        [itemsArray addObject:item];
    }];
    _itemsArray = itemsArray.copy;
    [_tableView reloadData];
}

#pragma mark - ZZTaskLikeCellDelegate
- (void)cell:(ZZTaskLikeCell *)cell showUserInfo:(ZZTaskLikeModel *)likeModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUserInfoWith:)]) {
        [self.delegate viewModel:self showUserInfoWith:likeModel.like_user];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskLikesListItem *item = _itemsArray[indexPath.row];
    
    switch (item.type) {
        case taskLikesList: {
            ZZTaskLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskLikeCell cellIdentifier] forIndexPath:indexPath];
            cell.likeModel = item.likeModel;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        default: {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
    }
}

#pragma mark UITableViewDelegate

#pragma mark - Request
/**
 获取列表
 */
- (void)fetchTaskLikes:(NSString *)time {
    NSMutableDictionary *param = @{
                                   @"pid": _taskID,
                                   }.mutableCopy;
    if (!isNullString(time)) {
        param[@"lastTime"] = time;
    }
    
    [ZZHUD show];
    [ZZTasksServer fetchLikesListWithParame:param handler:^(ZZError *error, id data) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        if (!error) {
            [ZZHUD dismiss];
            NSMutableArray<ZZTaskLikeModel *> *array = [ZZTaskLikeModel arrayOfModelsFromDictionaries:data error:nil];
            if (!time) {
                // 下拉刷新
                if (array.count >= 10) {
                    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        ZZTaskLikeModel *lastTask = _likesArray.lastObject;
                        [self fetchTaskLikes:lastTask.created_at];
                    }];
                }
                _likesArray = array.copy;
            }
            else {
                // 上拉加载更多
                NSMutableArray<ZZTaskLikeModel *> *currentArray = _likesArray.mutableCopy;
                [currentArray addObjectsFromArray:array];
                _likesArray = currentArray.copy;
            }
            [self createCells];
        }
    }];
}

@end
