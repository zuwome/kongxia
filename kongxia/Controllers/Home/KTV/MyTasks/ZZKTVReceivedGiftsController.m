//
//  ZZRecivedGiftsController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVReceivedGiftsController.h"

#import "ZZKTVMyGiftUserInfoCell.h"
#import "ZZKTVMyGiftlyricsCell.h"
#import "ZZEmptyCell.h"

#import "ZZKTVConfig.h"

@interface ZZKTVReceivedGiftsController () <UITableViewDelegate, UITableViewDataSource, ZZEmptyCellDelegate, ZZKTVMyGiftUserInfoCellDelegate, ZZKTVAudioPlayManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) ZZKTVRecievedGiftResponseModel *responseModel;

@property (nonatomic, strong) ZZKTVReceivedGiftModel *currentPlayedSongModel;

@property (nonatomic, strong) ZZKTVAudioPlayManager *audioPlayManager;

@end

@implementation ZZKTVReceivedGiftsController

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self releaseAudioManager];
}

- (void)releaseAudioManager {
    [self stopPlaying];
    [self.audioPlayManager releasePlayer];
    _audioPlayManager = nil;
}

- (void)stopPlaying {
    [self.audioPlayManager stop];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_responseModel.songList enumerateObjectsUsingBlock:^(ZZKTVReceivedGiftModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSongPlaying = NO;
        }];
        _currentPlayedSongModel = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)startPlaying:(ZZKTVReceivedGiftModel *)model {
    if (model == _currentPlayedSongModel) {
        if (self.audioPlayManager.isPlaying) {
            [self.audioPlayManager pause];
            model.isSongPlaying = NO;
        }
//        else {
//            [self.audioPlayManager play];
//            model.isSongPlaying = YES;
//        }
        _currentPlayedSongModel = nil;
        [_tableView reloadData];
        return;
    }
    
    _currentPlayedSongModel = model;
    [_responseModel.songList enumerateObjectsUsingBlock:^(ZZKTVReceivedGiftModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == model) {
            obj.isSongPlaying = YES;
        }
        else {
            obj.isSongPlaying = NO;
        }
    }];

    [self.audioPlayManager playAudio:model.content];
    
    [_tableView reloadData];
}


#pragma mark - ZZKTVAudioPlayManagerDelegate
- (void)managerDidFinish:(ZZKTVAudioPlayManager *)manager {
    [self stopPlaying];
}


#pragma mark - ZZKTVMyGiftUserInfoCellDelegate
- (void)cell:(ZZKTVMyGiftUserInfoCell *)cell showUserInfo:(ZZKTVReceivedGiftModel *)model {
    [self showUserInfo:model.from];
}

- (void)cell:(ZZKTVMyGiftUserInfoCell *)cell startPlay:(ZZKTVReceivedGiftModel *)model {
    [self startPlaying:model];
}


#pragma mark - ZZEmptyCellDelegate
- (void)cellShowAction:(ZZEmptyCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToTasks:)]) {
        [self.delegate switchToTasks:self];
    }
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_responseModel.songList.count == 0) {
        return 1;
    }
    else {
        return  _responseModel.songList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_responseModel.songList.count == 0) {
        return 1;
    }
    else {
        return  2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_responseModel.songList.count == 0) {
        ZZEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZEmptyCell cellIdentifier] forIndexPath:indexPath];
        [cell configureData:4];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            ZZKTVMyGiftUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVMyGiftUserInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.giftModel = _responseModel.songList[indexPath.section];
            cell.profite_rate = _responseModel.gift_rate;
            cell.delegate = self;
            return cell;
        }
        else {
            ZZKTVMyGiftlyricsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVMyGiftlyricsCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.giftModel = _responseModel.songList[indexPath.section];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_responseModel.songList.count == 0) {
        return SCREEN_HEIGHT;
    }
    else {
        if (indexPath.row == 0) {
            return 141;
        }
        else {
            return UITableViewAutomaticDimension;
        }
    }
    
}


#pragma mark - Navigator
/**
 用户信息
 */
- (void)showUserInfo:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = user.uid;
    [self.navigationController pushViewController:controller animated:YES];
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
    [ZZKTVServer fetchKTVReceivedGiftsListWithPage:pageSize
                                   completeHandler:^(BOOL isSuccess, ZZKTVRecievedGiftResponseModel *responeModel) {
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
            _responseModel = responeModel;
            if (responeModel.songList.count > 0) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *arrM = _responseModel.songList.mutableCopy;
            [arrM addObjectsFromArray:responeModel.songList];
            _responseModel.songList = arrM.copy;
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
- (ZZKTVAudioPlayManager *)audioPlayManager {
    if (!_audioPlayManager) {
        _audioPlayManager = [[ZZKTVAudioPlayManager alloc] init];
        _audioPlayManager.delegate = self;
    }
    return _audioPlayManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 90;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 下拉刷新
            [self fresh];
        }];
        
        [_tableView registerClass:[ZZEmptyCell class]
           forCellReuseIdentifier:[ZZEmptyCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVMyGiftUserInfoCell class]
           forCellReuseIdentifier:[ZZKTVMyGiftUserInfoCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVMyGiftlyricsCell class]
           forCellReuseIdentifier:[ZZKTVMyGiftlyricsCell cellIdentifier]];
    }
    return _tableView;
}
@end
