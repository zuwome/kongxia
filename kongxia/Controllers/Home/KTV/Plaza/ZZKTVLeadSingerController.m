//
//  ZZLeadSingerController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVLeadSingerController.h"

#import "ZZKTVUserInfoCell.h"
#import "ZZKTVUserActionCell.h"
#import "ZZKTVlyricsCell.h"
#import "ZZEmptyCell.h"

#import "ZZKTVConfig.h"

@interface ZZKTVLeadSingerController () <UITableViewDelegate, UITableViewDataSource, ZZEmptyCellDelegate, ZZKTVUserInfoCellDelegate, ZZKTVUserActionCellDelegate, ZZKTVAudioPlayManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSArray<ZZKTVLeadSongModel *> *leadModelArray;

@property (nonatomic, strong) ZZKTVLeadSongModel *currentPlayedSongModel;

@property (nonatomic, strong) ZZKTVAudioPlayManager *audioPlayManager;

@end

@implementation ZZKTVLeadSingerController

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
        [_leadModelArray enumerateObjectsUsingBlock:^(ZZKTVLeadSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSongPlaying = NO;
        }];
        _currentPlayedSongModel = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)startPlaying:(ZZKTVLeadSongModel *)model {
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
    [_leadModelArray enumerateObjectsUsingBlock:^(ZZKTVLeadSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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


#pragma mark - ZZKTVUserInfoCellDelegate
- (void)cell:(ZZKTVUserInfoCell *)cell showUserInfo:(id)model {
    if ([model isKindOfClass:[ZZKTVLeadSongModel class]]) {
        [self showUserInfo:((ZZKTVLeadSongModel *)model).to];
    }
}

- (void)cell:(ZZKTVUserInfoCell *)cell startPlay:(id)model {
    if ([model isKindOfClass:[ZZKTVLeadSongModel class]]) {
        [self startPlaying:model];
    }
}


#pragma mark - ZZEmptyCellDelegate
- (void)cellShowAction:(ZZEmptyCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToTasks:)]) {
        [self.delegate switchToTasks:self];
    }
}


#pragma mark - ZZKTVUserActionCellDelegate
- (void)cell:(ZZKTVUserActionCell *)cell chat:(id)model {
    if ([model isKindOfClass:[ZZKTVLeadSongModel class]]) {
        [self gotoChat:((ZZKTVLeadSongModel *)model).to shouldShowGift:NO];
    }
}

- (void)cell:(ZZKTVUserActionCell *)cell sendGift:(id)model {
    if ([model isKindOfClass:[ZZKTVLeadSongModel class]]) {
        [self gotoChat:((ZZKTVLeadSongModel *)model).to shouldShowGift:YES];
    }
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _leadModelArray.count ?: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_leadModelArray.count == 0) {
        return 1;
    }
    else {
        if (_leadModelArray[section].isSongPlaying) {
            return 3;
        }
        else {
            return 2;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leadModelArray.count == 0) {
        ZZEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZEmptyCell cellIdentifier] forIndexPath:indexPath];
        [cell configureData:2];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            ZZKTVUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVUserInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.songModel = _leadModelArray[indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        else if (indexPath.row == 1) {
            if (_leadModelArray[indexPath.section].isSongPlaying) {
                ZZKTVlyricsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVlyricsCell cellIdentifier] forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.songModel = _leadModelArray[indexPath.section].song;
                return cell;
            }
            else {
                ZZKTVUserActionCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVUserActionCell cellIdentifier] forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.songModel = _leadModelArray[indexPath.section];
                cell.delegate = self;
                return cell;
            }
        }
        else {
            ZZKTVUserActionCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVUserActionCell cellIdentifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.songModel = _leadModelArray[indexPath.section];
            cell.delegate = self;
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
    if (_leadModelArray.count == 0) {
        return SCREEN_HEIGHT;
    }
    else {
        if (indexPath.row == 0) {
            return 101.0;
        }
        else if (indexPath.row == 1) {
            if (_leadModelArray[indexPath.section].isSongPlaying) {
                return UITableViewAutomaticDimension;
            }
            else {
                return 61.0;
            }
        }
        else {
            return 61.0;
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

/**
 聊天
 */
- (void)gotoChat:(ZZUser *)user shouldShowGift:(BOOL)showGift {
    ZZChatViewController *chatController = [[ZZChatViewController alloc] init];
    chatController.nickName = user.nickname;
    chatController.uid = user.uid;
    chatController.portraitUrl = user.avatar;
    chatController.shouldShowGift = showGift;
    chatController.giftEntry = GiftEntryKTV;
    [self.navigationController pushViewController:chatController animated:YES];
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
    [ZZKTVServer fetchKTVLeadSingingListWithPage:pageSize
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
            _leadModelArray = list;
            if (list.count > 0) {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self loadMore];
                }];
            }
        }
        else {
            NSMutableArray *arr = _leadModelArray.mutableCopy;
            [arr addObjectsFromArray:list];
            _leadModelArray = arr.copy;
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
        
        [_tableView registerClass:[ZZKTVUserInfoCell class]
           forCellReuseIdentifier:[ZZKTVUserInfoCell cellIdentifier]];
        [_tableView registerClass:[ZZKTVUserActionCell class]
           forCellReuseIdentifier:[ZZKTVUserActionCell cellIdentifier]];
        [_tableView registerClass:[ZZKTVlyricsCell class]
           forCellReuseIdentifier:[ZZKTVlyricsCell cellIdentifier]];
        [_tableView registerClass:[ZZEmptyCell class]
           forCellReuseIdentifier:[ZZEmptyCell cellIdentifier]];
        
    }
    return _tableView;
}

@end
