//
//  ZZNewHomeViewModel.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeViewModel.h"
#import "ZZHomeNearbyViewController.h"
#import "ZZHomeTypeViewController.h"
#import "ZZHomeRefreshViewController.h"

#import "ZZNewHomeBaseCell.h"
#import "ZZNewHomePicWheelCell.h"
#import "ZZNewHomeTopicCell.h"
#import "ZZNewHomeSubjectCell.h"
#import "ZZNewHomeShanZuCell.h"
#import "ZZNewHomeServiceCell.h"
#import "ZZNewHomeContentCell.h"
#import "ZZNewHomeTaskCell.h"
#import "ZZPostTaskCell.h"
#import "ZZHomeCollectionsCell.h"
#import "ZZHomeCollectionsNewCell.h"

#import "ZZTasksServer.h"

#import "ZZNewHomeContentHeadView.h"
#import "ZZTaskModel.h"
#import "kongxia-Swift.h"

@interface ZZNewHomeViewModel () <UITableViewDelegate, UITableViewDataSource, ZZHomeCollectionsNewCellDelegate>

@property (nonatomic, weak) ZZNewHomeTableView *tableView;
@property (nonatomic, strong) ZZNewHomeContentHeadView *header;
@property (nonatomic, strong) ZZNewHomeContentCell *contentCell;
@property (nonatomic, strong) ZZNewHomeSubjectCell *subjectCell;

@property (nonatomic, strong) NSMutableArray<ZZViewController *> *ctlsArray;    //存放控制器的数组
@property (nonatomic, strong) ZZViewController *currentVC;  //当前显示的控制器（附近、推荐、新鲜）
@property (nonatomic, assign) BOOL canScroll;   //主tableView能否滚动，用于解决tableview嵌套的手势冲突
@property (nonatomic, strong) ZZHomeModel *homeModel;
@property (nonatomic, copy) NSArray *cellTypesArr;

@end

@implementation ZZNewHomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initNotification];
        [self initCellTypes];
        [self requestData];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerTableView:(ZZNewHomeTableView *)tableView {
    self.canScroll = YES;
    
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 50;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[ZZNewHomeBaseCell class] forCellReuseIdentifier:HomeBaseCellId];
    [tableView registerClass:[ZZNewHomePicWheelCell class] forCellReuseIdentifier:HomePicWheelCellId];
    [tableView registerClass:[ZZNewHomeTopicCell class] forCellReuseIdentifier:HomeTopicCellId];
    [tableView registerClass:[ZZNewHomeSubjectCell class] forCellReuseIdentifier:HomeSubjectCellId];
    [tableView registerClass:[ZZNewHomeShanZuCell class] forCellReuseIdentifier:HomeShanZuCellId];
    [tableView registerClass:[ZZNewHomeServiceCell class] forCellReuseIdentifier:HomeServiceCellId];
    [tableView registerClass:[ZZNewHomeContentCell class] forCellReuseIdentifier:HomeContentCellId];
    [tableView registerClass:[ZZNewHomeTaskCell class] forCellReuseIdentifier:HomeTaskCellId];
    [tableView registerClass:[ZZPostTaskCell class] forCellReuseIdentifier:HomePostTaskCellId];
    [tableView registerClass:[ZZHomeCollectionsCell class] forCellReuseIdentifier:ZZHomeCollectionsCellId];
    [tableView registerClass:[ZZHomeCollectionsNewCell class] forCellReuseIdentifier:ZZHomeCollectionsNewCellId];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (void)initControllers {
    if (self.ctlsArray.count > 0) {
        return ;
    }
    ZZHomeNearbyViewController *nearByCtl = [[ZZHomeNearbyViewController alloc] init];
    nearByCtl.type = @"near";
    nearByCtl.cityName = self.cityName;
    nearByCtl.filterDict = self.filterDict;
    [nearByCtl setTapCell:^(ZZHomeNearbyModel *model, UIImageView *imgView) {
        !self.gotoUserPage ? : self.gotoUserPage(model.user, imgView);
    }];
    [self.ctlsArray addObject:nearByCtl];
    
    ZZHomeTypeViewController *typeCtl = [[ZZHomeTypeViewController alloc] init];
    typeCtl.type = @"recommend";
    typeCtl.cityName = self.cityName;
    typeCtl.filterDict = self.filterDict;
    [typeCtl setTapCell:^(ZZUser *user, UIImageView *imgView) {
        !self.gotoUserPage ? : self.gotoUserPage(user, imgView);
    }];
    [typeCtl setTapShowPublish:^{
        !self.showGoPublicTaskFree ? : self.showGoPublicTaskFree();
    }];
    [typeCtl setTapShowActivity:^{
        !self.tapShowActivity ? : self.tapShowActivity();
    }];
    
    [typeCtl setGotoRefreshTab:^{   //新鲜达人按钮查看更多
        
    }];
    [typeCtl setShowRefreshInfoView:^{
        
    }];
    [typeCtl setTouchLivestream:^{
        
    }];
    [typeCtl setTouchRecordVideo:^{
        
    }];
    [typeCtl setFastChatBlock:^{    //视频咨询入口
        !self.gotoFastChat ? : self.gotoFastChat();
    }];
    
    [typeCtl setShowRent:^{
        if (_showRent) {
            _showRent();
        }
    }];
    
    [typeCtl setShowTaskFree:^{
        if (_showTaskFree) {
            _showTaskFree();
        }
    }];
    
    [typeCtl setShowGoPublicTaskFree:^{
        if (_showGoPublicTaskFree) {
            _showGoPublicTaskFree();
        }
    }];
    
    [self.ctlsArray addObject:typeCtl];
    
    ZZHomeRefreshViewController *freshCtl = [[ZZHomeRefreshViewController alloc] init];
    freshCtl.type = @"new";
    freshCtl.cityName = self.cityName;
    freshCtl.filterDict = self.filterDict;
    [freshCtl setTapCell:^(ZZHomeNearbyModel *model, UIImageView *imgView) {
        !self.gotoUserPage ? : self.gotoUserPage(model.user, imgView);
    }];
    [freshCtl setTouchCancel:^(NSString *uid) {
        [typeCtl refreshCancel:uid];
    }];
    [typeCtl setTouchCancel:^(NSString *uid) {
        [freshCtl refreshCancel:uid];
    }];
    [self.ctlsArray addObject:freshCtl];
    
    self.currentVC = typeCtl;
    //回调给主控制器进行绑定
    !self.ctlsBindBlock ? : self.ctlsBindBlock(self.ctlsArray);
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTableDidScrollToTop) name:SubTableCanNotScrollNotify object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coverWindowClick) name:@"click" object:nil];
}

- (void)coverWindowClick {
   [UIView animateWithDuration:0.5 animations:^{
       [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
   }];
}

/*
 创建首页列表所需要的cell type
 */
- (void)initCellTypes {
    NSMutableArray *arr = @[].mutableCopy;
    
    // 轮播图
    [arr addObject:@(HomeCellTypeBanner)];
    
    if (!self.homeModel.introduce.hide) {
        // 介绍
        [arr addObject:@(HomeCellTypeIntro)];
    }
    
    // 分类
    [arr addObject:@(HomeCellTypeCate)];
    
    if (self.homeModel.taskModel) {
        // 通告
        [arr addObject:@(HomeCellTypeTasks)];
    }
    
    // 发布通告
    [arr addObject:@(HomeCellTypePostTask)];
    
    // 显示土豪榜
    [arr addObject:@(HomeCellTypeChatsAndRanks)];
    
    // 列表
    [arr addObject:@(HomeCellTypeLists)];
    
    _cellTypesArr = arr.copy;
    
    [_tableView reloadData];
}

#pragma mark - ZZHomeCollectionsNewCellDelegate
- (void)showRanks {
    if (_gotoRanks) {
        _gotoRanks();
    }
}

- (void)showTasks {
    if (_gotoShanzu) {
        _gotoShanzu();
    }
}

- (void)showPopularityRanks {
    if (_gotoPopularityRanks) {
        _gotoPopularityRanks();
    }
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTypesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellType type = (HomeCellType)[_cellTypesArr[indexPath.section] intValue];
    switch (type) {
        case HomeCellTypeBanner: {
            return 220;
            break;
        }
        case HomeCellTypeIntro: {
            return 25;
            break;
        }
        case HomeCellTypeCate: {
            return 90;
            break;
        }
        case HomeCellTypeTasks: {
            return 153;
            break;
        }
        case HomeCellTypePostTask: {
            return 84;
            break;
        }
        case HomeCellTypeVideoChat: {
            return 94;
            break;
        }
        case HomeCellTypeChatsAndRanks: {
            if (self.homeModel.rankResponeModel.charisma_show) {
                return 167;
            }
            else {
                return 80;
            }
            break;
        }
        case HomeCellTypeLists: {
            return SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT - 50;
            break;
        }
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"";
    HomeCellType type = (HomeCellType)[_cellTypesArr[indexPath.section] intValue];
    switch (type) {
        case HomeCellTypeBanner:
            cellIdentifier = HomePicWheelCellId;
            break;
        case HomeCellTypeIntro:
            cellIdentifier = HomeServiceCellId;
            break;
        case HomeCellTypeCate:
            cellIdentifier = HomeTopicCellId;
            break;
        case HomeCellTypeTasks:
            cellIdentifier = HomeTaskCellId;
            break;
        case HomeCellTypePostTask:
            cellIdentifier = HomePostTaskCellId;
            break;
        case HomeCellTypeVideoChat:
            cellIdentifier = HomeShanZuCellId;
            break;
        case HomeCellTypeChatsAndRanks:
            cellIdentifier = ZZHomeCollectionsNewCellId;
            break;
        case HomeCellTypeLists:
            cellIdentifier = HomeContentCellId;
            break;
        default:
            cellIdentifier = HomeBaseCellId;
            break;
    }

    ZZNewHomeBaseCell *cell = [ZZNewHomeBaseCell dequeueReusableCellWithTableView:tableView andCellIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //picWheelCell
    if ([cellIdentifier isEqualToString:HomePicWheelCellId]) {
        cell.bannerArray = self.homeModel.banner;
        [cell setDidSelectAtIndex:^(NSInteger index) {
            !self.bannerClick ? : self.bannerClick(self.homeModel.banner[index]);
        }];
    }
    else if ([cellIdentifier isEqualToString:HomeTopicCellId]) {
        //topicCell
        cell.topics = self.homeModel.catalog;
        [cell setTopicChooseCallback:^(ZZHomeCatalogModel *topic) {
            !self.gotoTopicClassify ? : self.gotoTopicClassify(topic);
        }];
    }
    else if ([cellIdentifier isEqualToString:HomeShanZuCellId]) {
        //shanzuCell
        cell.chatOptions = self.homeModel.q_chat;
        cell.rentOptions = self.homeModel.q_rent;
        [cell setShanZuCallback:^{
            !self.gotoShanzu ? : self.gotoShanzu();
        }];
        [cell setVideoCounselCallback:^{
            !self.gotoFastChat ? : self.gotoFastChat();
        }];
    }
    else if ([cellIdentifier isEqualToString:HomeSubjectCellId]) {
        // subjectCell
        [cell setSpecialTopicArray:self.homeModel.special_topic_list];
        [cell setSpecialTopicCallback:^(ZZHomeSpecialTopicModel *model) {
            !self.gotoSpecialTopic ? : self.gotoSpecialTopic(model);
        }];
    }
    else if ([cellIdentifier isEqualToString:HomeServiceCellId]) {
        // serviceCell
        [cell setIntroduceList:self.homeModel.introduce.list];
    }
    else if ([cellIdentifier isEqualToString:HomeContentCellId]) {
        //contentCell
        self.contentCell = (ZZNewHomeContentCell *)cell;
        [self initControllers];
        [cell setCtlsArray:self.ctlsArray];
        [cell setDidScroll:^(CGPoint contentOffset) {
            NSInteger index = contentOffset.x / SCREEN_WIDTH;
            [self.header lineMoveToIndex:index animated:YES];
            [self updateDataIfNeeded:self.ctlsArray[index]];
        }];
    }
    else if ([cellIdentifier isEqualToString:HomeTaskCellId]) {
        [cell configure:self.homeModel.taskModel];
        [cell setSignupCallback:^(ZZTask *task) {
            if (_signupCallback) {
                _signupCallback(task);
            }
        }];
        
        [cell setShowLocationsCallback:^(ZZTask *task) {
            if (_showLocationsCallback) {
                _showLocationsCallback(task);
            }
        }];
    }
    else if ([cellIdentifier isEqualToString:HomePostTaskCellId]) {
        ZZPostTaskCell *postCell = (ZZPostTaskCell *)cell;
        postCell.model = _homeModel.pd_add;
        [cell setPostTaskCallback:^{
            [self uploadPostTaskClickedContent];
            if (_postTaskCallback) {
                _postTaskCallback();
            }
        }];
    }
    else if ([cellIdentifier isEqualToString:ZZHomeCollectionsCellId]) {
        ZZHomeCollectionsCell *collectionCell = (ZZHomeCollectionsCell *)cell;
        [collectionCell configureTopThree:self.homeModel.rankResponeModel];
    }
    else if ([cellIdentifier isEqualToString:ZZHomeCollectionsNewCellId]) {
        ZZHomeCollectionsNewCell *collectionCell = (ZZHomeCollectionsNewCell *)cell;
        [collectionCell configureTopThree:self.homeModel.rankResponeModel qchat:self.homeModel.q_chat];
        collectionCell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > _cellTypesArr.count - 1) {
        return 0.0;
    }
    HomeCellType type = (HomeCellType)[_cellTypesArr[section] intValue];
    if (type == HomeCellTypeLists) {
        return 50;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > _cellTypesArr.count - 1) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0)];
    }
    HomeCellType type = (HomeCellType)[_cellTypesArr[section] intValue];
    if (type == HomeCellTypeLists) {
        WeakSelf
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (nil == self.header) {
            self.header = [[ZZNewHomeContentHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        }
        [self.header setNearByCallback:^{
            ZZNewHomeContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [weakSelf updateDataIfNeeded:weakSelf.ctlsArray[0]];
        }];
        [self.header setRecommendCallback:^{
            ZZNewHomeContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            [weakSelf updateDataIfNeeded:weakSelf.ctlsArray[1]];
        }];
        [self.header setFreshCallback:^{
            ZZNewHomeContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
            [weakSelf updateDataIfNeeded:weakSelf.ctlsArray[2]];
        }];
        return self.header;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
}

- (void)subTableDidScrollToTop {
    self.canScroll = YES;
    self.contentCell.canScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat cellOffset = [_tableView rectForSection:_cellTypesArr.count - 1].origin.y - NAVIGATIONBAR_HEIGHT;
    if ((int)scrollView.contentOffset.y >= (int)cellOffset) {
        scrollView.contentOffset = CGPointMake(0, cellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.canScroll = YES;
        }
    }
    else {
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, cellOffset);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    for (ZZNewHomeBaseCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[ZZNewHomeSubjectCell class]]) {
            self.subjectCell = (ZZNewHomeSubjectCell *)cell;
            if (scrollView.contentOffset.y + NAVIGATIONBAR_HEIGHT < cell.frame.origin.y &&
                scrollView.contentOffset.y + SCREEN_HEIGHT - TABBAR_HEIGHT > cell.frame.origin.y + cell.frame.size.height) {
                //精选专题在显示范围内则播放视频
                [self.subjectCell playVideo];
            }
            else {
                [self.subjectCell stopVideo];
            }
        }
    }
}

#pragma mark -- interface
- (void)updateCityAndFilter {   //设置全部更新标识
    for (ZZViewController *ctl in self.ctlsArray) {
        if ([ctl isKindOfClass:[ZZHomeRefreshViewController class]]) {
            ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)ctl;
            controller.cityName = self.cityName;
            controller.filterDict = self.filterDict;
            controller.update = YES;
            controller.haveGetLocation = self.haveGetLocation;
            continue;
        }
        if ([ctl isKindOfClass:[ZZHomeNearbyViewController class]]) {
            ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)ctl;
            controller.cityName = self.cityName;
            controller.filterDict = self.filterDict;
            controller.haveGetLocation = self.haveGetLocation;
            controller.update = YES;
            [controller updateLocationInfoAndRefresh];
            continue;
        }
        if ([ctl isKindOfClass:[ZZHomeTypeViewController class]]) {
            ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)ctl;
            controller.cityName = self.cityName;
            controller.filterDict = self.filterDict;
            controller.update = YES;
            controller.haveGetLocation = self.haveGetLocation;
            continue;
        }
    }
    [self updateControllerData];
}

- (void)refreshControllerData {
    if ([self.currentVC isKindOfClass:[ZZHomeNearbyViewController class]]) {
        ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)self.currentVC;
        [controller refresh];
    }
    if ([self.currentVC isKindOfClass:[ZZHomeTypeViewController class]]) {
        ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)self.currentVC;
        [controller refresh];
    }
    if ([self.currentVC isKindOfClass:[ZZHomeRefreshViewController class]]) {
        ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)self.currentVC;
        [controller refresh];
    }
}

- (void)updateControllerData {  //更新数据，按需更新
    if ([self.currentVC isKindOfClass:[ZZHomeNearbyViewController class]]) {
        ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)self.currentVC;
        [controller updateData];
    }
    if ([self.currentVC isKindOfClass:[ZZHomeTypeViewController class]]) {
        ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)self.currentVC;
        [controller updateData];
    }
    if ([self.currentVC isKindOfClass:[ZZHomeRefreshViewController class]]) {
        ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)self.currentVC;
        [controller updateData];
    }
}

- (BOOL)isNeedToUpdateData {    //是否需要更新
    if ([self.currentVC isKindOfClass:[ZZHomeNearbyViewController class]]) {
        ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)self.currentVC;
        [self addEventClick:controller.type];
        return controller.update;
    }
    if ([self.currentVC isKindOfClass:[ZZHomeTypeViewController class]]) {
        ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)self.currentVC;
        [self addEventClick:controller.type];
        return controller.update;
    }
    if ([self.currentVC isKindOfClass:[ZZHomeRefreshViewController class]]) {
        ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)self.currentVC;
        [self addEventClick:controller.type];
        return controller.update;
    }
    return NO;
}

- (void)updateDataIfNeeded:(ZZViewController *)vc { //按需更新数据
    self.currentVC = vc;
    if ([self isNeedToUpdateData]) {    //滑动结束后刷新数据
        [self updateControllerData];
        return;
    }
}


#pragma mark - 自定义事件统计
- (void)addEventClick:(NSString *)event {
    [MobClick event:[NSString stringWithFormat:@"click_%@_cate",event]];
}


#pragma mark -- data request
- (void)requestData {   //请求数据：首页banner、主题列表、精选专题等
    [self getHomeData];
    [self updateCityAndFilter];
}

- (void)getHomeData {
    _canScroll = YES;
    [ZZHomeModel getIndexPageData:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if (data) {
            self.homeModel = [[ZZHomeModel alloc] initWithDictionary:data error:nil];
            [self getTask];
            [self fetchRanking];
        }
        else {
            [ZZHUD showTastInfoErrorWithString:error.message];
            [self initCellTypes];
        }
    }];
}

- (void)getTask {
    NSMutableDictionary *param = @{
                            @"lat": UserHelper.selectedLocation ? @(UserHelper.selectedLocation.coordinate.latitude) : @(UserHelper.location.coordinate.latitude),
                            @"lng": UserHelper.selectedLocation ? @(UserHelper.selectedLocation.coordinate.longitude) : @(UserHelper.location.coordinate.longitude),
                            }.mutableCopy;
    if ([UserHelper isLogin]) {
        param[@"uid"] = UserHelper.loginer.uid;
    }
    [ZZTasksServer fetchIndexTaskWithParams:param handler:^(ZZError *error, id data) {
        [self.tableView.mj_header endRefreshing];
        if (!error && [data isKindOfClass:[NSArray class]] && [(NSArray *)data count] > 0) {
            ZZTask *task = [[ZZTask alloc] initWithDictionary:data[0] error:nil];
            self.homeModel.taskModel = task;
        }
        else {
            self.homeModel.taskModel = nil;
        }
        
        [self initCellTypes];
        [self.tableView reloadData];
    }];
}

- (void)fetchRanking {
    [ZZRequest method:@"GET" path:@"/rangking/getRankTopThree" params:@{@"uid": ZZUserHelper.shareInstance.loginer.uid ?: @""} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error) {
            self.homeModel.rankResponeModel = [ZZRankResponeModel yy_modelWithDictionary:data];
        }
        [self.tableView reloadData];
    }];
}

/*
 点击立即发布上传显示的文案
 */
- (void)uploadPostTaskClickedContent {
    if (!_homeModel.pd_add) {
        return;
    }
    
    if (![UserHelper isLogin]) {
        return;
    }
    
    NSDictionary *param = @{
        @"index": @(_homeModel.pd_add.index),
    };
    [ZZRequest method:@"POST"
                 path:@"/api/onClickHomePd"
               params:param
                 next:nil];
}

#pragma mark - getters and setters
- (NSMutableArray<ZZViewController *> *)ctlsArray {
    if (nil == _ctlsArray) {
        _ctlsArray = [NSMutableArray array];
    }
    return _ctlsArray;
}

@end
