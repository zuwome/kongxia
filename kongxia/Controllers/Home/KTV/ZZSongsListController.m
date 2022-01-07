//
//  ZZSongsListController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSongsListController.h"

#import "ZZKTVSongCell.h"

@interface ZZSongsListController () <UITableViewDelegate, UITableViewDataSource, ZZKTVSongCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, copy) NSArray<ZZKTVSongModel *> *songs;

@end

@implementation ZZSongsListController

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageIndex = 1;
        _isFirstTime = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layout];
    if (_isFirstTime) {
        [self refresh];
    }
}

- (void)configureData:(NSArray<ZZKTVSongModel *> *)songs {
    _songs = songs;
    _isFirstTime = NO;
    [_tableView reloadData];
}

- (void)reloadData {
    [_tableView reloadData];
}

#pragma mark - ZZKTVSongCellDelegate
- (void)cell:(ZZKTVSongCell *)cell addSong:(ZZKTVSongModel *)songModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didSelectSong:)]) {
        [self.delegate controller:self didSelectSong:songModel];
    }
    [_tableView reloadData];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _songs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZKTVSongModel *songModel = _songs[indexPath.section];
    ZZKTVSongCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVSongCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configureSong:songModel];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block BOOL didSelected = NO;
        [_selectedSongs enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj._id isEqualToString:songModel._id]) {
                didSelected = YES;
                *stop = YES;
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setDidSelect:didSelected];
        });
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10)];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}


#pragma mark - Request
- (void)refresh {
    _pageIndex = 1;
    [self fetchData:_pageIndex];
}

- (void)loadMore {
    _pageIndex += 1;
    [self fetchData:_pageIndex];
}

- (void)fetchData:(NSInteger)pageIndex {
    [ZZKTVServer fetchSongListWithSongType:_typeModel._id
                                 pageIndex:pageIndex
                           completeHandler:^(BOOL isSuccess, ZZKTVSongListResponesModel *responseModel) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        if (!isSuccess) {
            return ;
        }
        
        if (_pageIndex == 1) {
            _songs = responseModel.songList;
        }
        else {
            NSMutableArray *songsM = _songs.mutableCopy;
            [songsM addObjectsFromArray:responseModel.songList];
            _songs = songsM.copy;
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            [self refresh];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMore];
        }];
        
        [_tableView registerClass:[ZZKTVSongCell class] forCellReuseIdentifier:[ZZKTVSongCell cellIdentifier]];
    }
    return _tableView;
}

@end
