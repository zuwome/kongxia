//
//  ZZHomeTypeViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeTypeViewController.h"
#import "ZZRecommendVideoViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZTopicDetailViewController.h"
#import "ZZRecordViewController.h"
#import "ZZUserChuzuViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZHomeUserCell.h"
#import "ZZActivityCollectionCell.h"

#import "ZZSelfIntroduceVC.h"
#import "ZZPublishOrderView.h"
#import "ZZChatVideoPlayerController.h"
#import "ZZHomeHelper.h"
#import "ZZFindVideoModel.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZRegisterRentViewController.h"

#import "XRWaterfallLayout.h"
#import <Underscore.h>
//网络占位图
#import "ZZNotNetEmptyView.h"
#import "ZZAlertNotNetEmptyView.h"
#import "ZZHomeNewRecommendCell.h"
#import "ZZNewHomeTaskFreeCell.h"
#import "ZZNewHomeRentEntryCell.h"

#import "HttpDNS.h"

#import "ZZNewHomeViewController.h"

@interface ZZHomeTypeViewController () <XRWaterfallLayoutDelegate,UITableViewDelegate, UITableViewDataSource, ZZNewHomeRentEntryCellDelegate, ZZNewHomeTaskFreeCellDelegate, UIScrollViewDelegate, ZZHomeNewRecommendCellDelegate>

@property (nonatomic, strong) NSMutableArray<ZZHomeRecommendDetailModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *skillIntroHArray;
@property (nonatomic, assign) BOOL isRecommend;//是否是推荐页面
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, assign) BOOL viewDidAppear;
@property (nonatomic, strong) ZZHomeRecommendModel *recommendModel;
@property (nonatomic, assign) BOOL hideRefresh;//隐藏新鲜
@property (nonatomic, assign) BOOL isShowGuide;
//网络占位图
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ZZHomeTypeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewDidAppear = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _viewDidAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    
    [self createViews];
    [self sendRequest];
    _haveLoad = YES;
    _update = NO;
    if ([_type isEqualToString:@"recommend"]) {
        _isRecommend = YES;
    }
    
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf reloadInfo];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidUpdate) name:kMsg_LocationDidChange object:nil];
}

- (void)locationDidUpdate {
    [self reloadInfo];
}

- (void)createViews {
    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _emptyView =  [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:self.view.frame viewController:self];
}

- (void)reloadInfo {
    [_tableview.mj_header beginRefreshing];
}

/**
 * 是否需要显示活动的入口
 * 从未申请过出租的女性用户除外
 */
- (BOOL)shouldShowTaskFree {
    BOOL shouldShow = YES;
//    if (![[ZZUserHelper shareInstance] isLogin]) {
//        shouldShow = NO;
//    }
    
    if (_activitityDic && ![_activitityDic[@"pdgWgShow"] boolValue]) {
        shouldShow = NO;
    }
    
    else if ([[ZZUserHelper shareInstance] isLogin] && [ZZUserHelper shareInstance].loginer.gender == 2 && [ZZUserHelper shareInstance].loginer.rent.status == 0) {
        shouldShow = NO;
    }

    return shouldShow;
}

/**
 * 是否需要显示快捷出租的入口
 * 从未申请过出租的女性用户
 */
- (BOOL)shouldShowRentEntry {
    
    BOOL shouldShow = YES;
    if (![[ZZUserHelper shareInstance] isLogin]) {
        shouldShow = NO;
    }
    else if ([ZZUserHelper shareInstance].loginer.gender == 2 && [ZZUserHelper shareInstance].loginer.rent.status == 0) {
        shouldShow = YES;
    }
    else {
        shouldShow = NO;
    }
    
    return shouldShow;
}

- (void)configureTaskFreeOrRentEntry {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self shouldShowRentEntry]) {
            
            // 显示快捷出租的入口
            ZZHomeRecommendDetailModel *model = [[ZZHomeRecommendDetailModel alloc] init];
            model.modelType = 2;
            
            __block BOOL didHave = NO;
            [_dataArray enumerateObjectsUsingBlock:^(ZZHomeRecommendDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.modelType == 2) {
                    *stop = YES;
                    didHave = YES;
                }
            }];
            
            if (!didHave) {
                NSInteger index = 7;
                if (index < self.dataArray.count) {
                    [self.dataArray insertObject:model atIndex:index];
                }
                else {
                    [self.dataArray addObject:model];
                }
            }
        }
        else if ([self shouldShowTaskFree]) {
            // 显示活动的入口
            ZZHomeRecommendDetailModel *model = [[ZZHomeRecommendDetailModel alloc] init];
            model.modelType = 1;
            __block BOOL didHave = NO;
            [_dataArray enumerateObjectsUsingBlock:^(ZZHomeRecommendDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.modelType == 1) {
                    *stop = YES;
                    didHave = YES;
                }
            }];
            
            if (!didHave) {
                NSInteger index = arc4random() % 10;
                if (index < self.dataArray.count) {
                    [self.dataArray insertObject:model atIndex:index];
                }
                else {
                    [self.dataArray addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
        });
    });
}

#pragma mark - SendRequest
- (void)sendRequest {
    WeakSelf;
    _tableview.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        if (![ZZUserHelper shareInstance].isLogin) {
            weakSelf.pageIndex = 1;
            [weakSelf fetchDataWithPageIndex:weakSelf.pageIndex];
        }
        else {
            [weakSelf getHeadData];
        }
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![ZZUserHelper shareInstance].isLogin) {
            [weakSelf fetchDataWithPageIndex:weakSelf.pageIndex + 1];
        }
        else {
            [weakSelf getFootData];
        }
    }];
    [_tableview.mj_header beginRefreshing];
}

/*
 这个接口..未登录和登录不一样的接口,不一样的数据格式
 */
- (void)fetchDataWithPageIndex:(NSInteger)pageIndex {
    [self.tableview.mj_footer resetNoMoreData];
    
    NSMutableDictionary *aDcit = @{
                                   @"cate": self.type
                                   }.mutableCopy;
    
    if (self.cityName) {
        [aDcit setObject:self.cityName forKey:@"cityName"];
    }
    
    if (self.filterDict) {
        aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(self.filterDict, aDcit)];
    }
    
    // 推荐登陆和未登录分别调用不同接口
    if ([ZZUserHelper shareInstance].isLogin && self.isRecommend) {
        if ([[ZZUserHelper shareInstance].cityName isEqualToString:self.cityName] && _haveGetLocation) {
            // FIXME:新定位
            if ([[ZZUserDefaultsHelper objectForDestKey:@"NewLocation"] isEqualToString:@"1"]) {
                [aDcit setObject:@"gps" forKey:@"city_choose_by"];
            }
            else {
                [aDcit setObject:@"" forKey:@"city_choose_by"];
            }
        }
    }
    
    aDcit[@"pageIndex"] = @(pageIndex);
    
    NSLog(@"*************************************\n \
          type aDict is %@ \n\
          *************************************",aDcit);
    
    [self fetchDataWithoutLoginWithParam:aDcit.copy];
}

- (void)fetchDataWithoutLoginWithParam:(NSDictionary *)param {
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    [helper fetchHomeListRecommendListWithoutLoginWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (self.dataArray.count>0&&error.code==1111) {
                NSInteger pageIndex = [param[@"pageIndex"] intValue];
                if (pageIndex == 1) {
                    [self.alertEmptyView showView:self];
                }
            }
            else if(error.code==1111){
                if (self.dataArray.count<=0) {
                    self.emptyView.hidden = NO;
                    self.update = YES;
                }
                else{
                    self.emptyView.hidden = YES;
                }
            }
            else{
                [ZZHUD showErrorWithStatus:error.message];
            }
        }
        else {
            self.emptyView.hidden = YES;
            if ([_tableview.mj_header isRefreshing]) {
                [_tableview.mj_header endRefreshing];
            }
            else if ([_tableview.mj_footer isRefreshing]) {
                [_tableview.mj_footer endRefreshing];
            }
            
            if (![data isKindOfClass:[NSArray class]]) {
                [self getActivitis];
                return ;
            }
            
            NSArray *rowDataArray = (NSArray *)data;
            
            NSMutableArray<ZZHomeRecommendDetailModel *> *detailsArray = @[].mutableCopy;
            [rowDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    ZZUser *user = [ZZUser yy_modelWithDictionary:obj];
                    ZZHomeRecommendDetailModel *model = [ZZHomeRecommendDetailModel new];
                    model.user = user;
                    [detailsArray addObject:model];
                }
            }];
            
            NSInteger pageIndex = [param[@"pageIndex"] intValue];
            NSMutableArray<ZZHomeRecommendDetailModel *> *dataArray = self.dataArray.mutableCopy;
            if (pageIndex == 1) {
                // 下拉刷新
                dataArray = detailsArray.mutableCopy;
            }
            else {
                // 上啦加载更多
                if (detailsArray.count == 0) {
                    [_tableview.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [dataArray addObjectsFromArray:detailsArray];
                    self.pageIndex++;
                }
            }
            
            self.dataArray = dataArray;
            for (ZZHomeRecommendDetailModel *model in self.dataArray) {
                NSNumber *hNumber = [NSNumber numberWithFloat:[self calSkillIntroHeight:model.user.rent.topics]];
                [self.skillIntroHArray addObject:hNumber];
            }
           
            [self getActivitis];
            [_tableview reloadData];
        }
    }];
}

- (void)getHeadData {
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    [self.tableview.mj_footer resetNoMoreData];
    NSMutableDictionary *aDcit = [@{@"cate":self.type} mutableCopy];
    if (self.cityName) {
        [aDcit setObject:self.cityName forKey:@"cityName"];
    }
    if (self.filterDict) {
        aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(self.filterDict, aDcit)];
    }
    
    if (![ZZUserHelper shareInstance].isLogin) {
        aDcit[@"pageIndex"] = @(self.pageIndex);
    }
    
    //推荐登陆和未登录分别调用不同接口
    if ([ZZUserHelper shareInstance].isLogin && self.isRecommend) {
        if ([[ZZUserHelper shareInstance].cityName isEqualToString:self.cityName] && _haveGetLocation) {
            // FIXME:新定位
            if ([[ZZUserDefaultsHelper objectForDestKey:@"NewLocation"] isEqualToString:@"1"]) {
                [aDcit setObject:@"gps" forKey:@"city_choose_by"];
            }
            else {
                [aDcit setObject:@"" forKey:@"city_choose_by"];
            }
        }
    }
    [helper getHomeListWithParam:aDcit next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self headerCallBack:error data:data task:task];
    }];
}

- (void)getFootData {
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    if (_dataArray.count) {
        ZZHomeRecommendDetailModel *model = [self.dataArray lastObject];
        if (isNullString(model.sortValue)) {
            [self.tableview.mj_footer endRefreshing];
            return;
        }
        NSMutableDictionary *aDcit = [@{@"cate":self.type,
                                        @"sortValue":model.sortValue} mutableCopy];
        
        if (model.current_star) {
            [aDcit setObject:model.current_star forKey:@"current_star"];
        }
        if (self.cityName) {
            [aDcit setObject:self.cityName forKey:@"cityName"];
        }
        if (self.filterDict) {
            aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(self.filterDict, aDcit)];
        }
        
        if ([ZZUserHelper shareInstance].isLogin && self.isRecommend) {
            if ([[ZZUserHelper shareInstance].cityName isEqualToString:self.cityName]) {
                // FIXME:新定位
                if ([[ZZUserDefaultsHelper objectForDestKey:@"NewLocation"] isEqualToString:@"1"]) {
                    [aDcit setObject:@"gps" forKey:@"city_choose_by"];
                }
                else {
                    [aDcit setObject:@"" forKey:@"city_choose_by"];
                }
            }
        }
        [helper getHomeListWithParam:aDcit
                                next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                    [self footerCallBack:error data:data task:task];
                                }];
    }
    else {
        [self.tableview.mj_footer endRefreshing];
    }
}

/*
 获取活动
 */
- (void)getActivitis {
    NSMutableDictionary *param = @{
                                   @"lat": UserHelper.selectedLocation ? @(UserHelper.selectedLocation.coordinate.latitude) : @(UserHelper.location.coordinate.latitude),
                                   @"lng": UserHelper.selectedLocation ? @(UserHelper.selectedLocation.coordinate.longitude) : @(UserHelper.location.coordinate.longitude),
                                   }.mutableCopy;
    if ([[ZZUserHelper shareInstance] isLogin]) {
        param[@"uid"] = [ZZUserHelper shareInstance].loginer.uid;
    }
    
    [ZZTasksServer fetchIndexActivitiesWithParams:param handler:^(ZZError *error, id data) {
        [_tableview.mj_header endRefreshing];
        if (!error && [data isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = [data mutableCopy];
            NSError *aerror = nil;
            NSArray<ZZTask *> *tasks = [ZZTask arrayOfModelsFromDictionaries:data[@"data"] error:&aerror];
            if (tasks) {
                dic[@"tasks"] = tasks;
            }
            _activitityDic = dic.copy;
        }
        [self.tableview reloadData];
        [self configureTaskFreeOrRentEntry];
    }];
}

- (void)headerCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task {
    
    if (error) {
        if (self.dataArray.count>0&&error.code==1111) {
            [self.alertEmptyView showView:self];
        }else if(error.code==1111){
            if (self.dataArray.count<=0) {
                self.emptyView.hidden = NO;
                self.update = YES;
            }else{
                self.emptyView.hidden = YES;
            }
        }else{
            [ZZHUD showErrorWithStatus:error.message];
        }
    } else {
        self.emptyView.hidden = YES;
        _recommendModel = [[ZZHomeRecommendModel alloc] initWithDictionary:data error:nil];

        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:_recommendModel.hot];
        [self.dataArray addObjectsFromArray:_recommendModel.recommend];
        [self.skillIntroHArray removeAllObjects];
        
        if (_dataArray.count == 0) {
            [_tableview.mj_footer endRefreshingWithNoMoreData];
        }
        
        NSArray *array = self.dataArray.copy;
        for (ZZHomeRecommendDetailModel *model in array) {
            NSNumber *hNumber = [NSNumber numberWithFloat:[self calSkillIntroHeight:model.user.rent.topics]];
            [self.skillIntroHArray addObject:hNumber];
        }
        
        [self getActivitis];
        [_tableview reloadData];
    }
}

- (void)footerCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task {
    [_tableview.mj_footer endRefreshing];
    if (error) {
        if (error.code ==1111) {
            if (self.dataArray.count<=0) {
                self.emptyView.hidden = NO;
                self.update = YES;
            }else{
                self.emptyView.hidden = YES;
                [self.alertEmptyView showView:self];
            }
        }else{
            [ZZHUD showErrorWithStatus:error.message];
        }
    } else {
        self.emptyView.hidden = YES;
        ZZHomeRecommendModel *model = [[ZZHomeRecommendModel alloc] initWithDictionary:data error:nil];
        
        if (model.recommend.count == 0) {
            [_tableview.mj_footer endRefreshingWithNoMoreData];
        } else {
            [_dataArray addObjectsFromArray:model.recommend];
            for (ZZHomeRecommendDetailModel *detail in model.recommend) {
                NSNumber *hNumber = [NSNumber numberWithFloat:[self calSkillIntroHeight:detail.user.rent.topics]];
                [self.skillIntroHArray addObject:hNumber];
            }
            [_tableview reloadData];
            self.pageIndex ++;
        }
    }
}

- (float)calSkillIntroHeight:(NSArray<ZZTopic *> *)topics {  //计算最便宜的技能介绍的高度
    ZZSkill *cheapSkill = [ZZHomeModel getMostCheapSkill:topics];
    NSString *skillIntro = cheapSkill.detail.content;
    float introHeight = [ZZUtils heightForCellWithText:skillIntro fontSize:16 labelWidth:(SCREEN_WIDTH - 5) / 2 - 20];
    return introHeight > 60 ? 60 : introHeight; //限定3行最大高度60
}

- (void)updateData {    //更新数据，供外部调用
    if (_haveLoad) {
        if ([_tableview.mj_header isRefreshing]) {
            if (![ZZUserHelper shareInstance].isLogin) {
                self.pageIndex = 1;
                [self fetchDataWithPageIndex:self.pageIndex];
            }
            else {
                [self getHeadData];
            }
        }
        else {
            [_tableview.mj_header beginRefreshing];
        }
        _update = NO;
    }
}

/**
 获取新鲜数据
 */
- (void)getRefreshData {
    if (_hideRefresh) {
        return;
    }
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    NSMutableDictionary *aDcit = [@{@"cate":@"new"} mutableCopy];
    if (self.cityName) {
        [aDcit setObject:self.cityName forKey:@"cityName"];
    }
    if (self.filterDict) {
        aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(self.filterDict, aDcit)];
    }
    //推荐登陆和未登录分别调用不同接口
    if ([ZZUserHelper shareInstance].isLogin) {
        if ([[ZZUserHelper shareInstance].cityName isEqualToString:self.cityName] && _haveGetLocation) {
            // FIXME:新定位
            if ([[ZZUserDefaultsHelper objectForDestKey:@"NewLocation"] isEqualToString:@"1"]) {
                [aDcit setObject:@"gps" forKey:@"city_choose_by"];
            }
            else {
                [aDcit setObject:@"" forKey:@"city_choose_by"];
            }
        }
    }
    [helper getHomeListWithParam:aDcit next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableview reloadData];
    }];
}

- (void)refreshCancel:(NSString *)uid {
//    [_headView refreshCancelWithUid:uid];
}

- (void)refresh {
    [_tableview.mj_header beginRefreshing];
}

#pragma mark - ZZHomeNewRecommendCell
-(void)cellTapped:(ZZHomeNewRecommendCell *)cell model:(ZZHomeRecommendDetailModel *)model{
    if (model.modelType == 0) {
        if (_isShowGuide) {
            [self.tableview reloadData];
        }
        if (_tapCell) {
            _tapCell(model.user,cell.imgView);
        }
    }
    else if (model.modelType == 1) {
        if (_showTaskFree) {
            _showTaskFree();
        }
    }
    else if (model.modelType == 2) {
        if (_showRent) {
            _showRent();
        }
    }
}

#pragma mark - ZZNewHomeRentEntryCellDelegate
/**
 *  快捷出租
 */
- (void)cellShowRent:(ZZNewHomeRentEntryCell *)cell {
    if (_showRent) {
        _showRent();
    }
}

#pragma mark - ZZNewHomeRentEntryCellDelegate
- (void)cellGoPostTaskFree:(ZZNewHomeTaskFreeCell *)cell {
    if (_showGoPublicTaskFree) {
        _showGoPublicTaskFree();
    }
}

- (void)cellTaskFree:(ZZNewHomeTaskFreeCell *)cell {
    
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    ZZHomeRecommendDetailModel *model = _dataArray[index];
    if (model.modelType == 1) {
        // 活动的入口
        ZZNewHomeTaskFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZNewHomeTaskFreeCell cellIdentifier] forIndexPath:indexPath];
        cell.activitityDic = _activitityDic;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (model.modelType == 2) {
        // 快捷出租的入口
        ZZNewHomeRentEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZNewHomeRentEntryCell cellIdentifier] forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureTitle:_activitityDic[@"rent_title"] subTitle:_activitityDic[@"rent_tip"]];
        return cell;
    }
    else {
        ZZHomeNewRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZHomeNewRecommendCell cellIdentifier] forIndexPath:indexPath];
        cell.delegate = self;
        [cell setModel:_dataArray[index]];
        if (model.user.have_wechat_no && ![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstHomeWxGuide]) {
            cell.firstWxGuideView.hidden = NO;
            [ZZKeyValueStore saveValue:@"firstHomeWxGuide" key:[ZZStoreKey sharedInstance].firstHomeWxGuide];
            _isShowGuide = YES;
        } else {
            cell.firstWxGuideView.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZHomeRecommendDetailModel *model = _dataArray[indexPath.row];
    if (model.modelType == 1) {
        // 活动的入口
        return 100;
    }
    else if (model.modelType == 2) {
        // 快捷出租的入口
        return 135;
    }
    else {
        return 135;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview) { //滚动到顶部通知supertable可滚动
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.canScroll = NO;
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:SubTableCanNotScrollNotify object:nil];
        }
        
    }
    
}

- (void)managerScheme:(NSString *)url { //TODO -- banner点击逻辑，猜的
    NSString *jsonString = [url stringByReplacingOccurrencesOfString:@"zwmscheme://" withString:@""];
    NSDictionary *dictionary = [ZZUtils dictionaryWithJsonString:jsonString];
    NSDictionary *aDict = [dictionary objectForKey:@"iOS"];
    
    if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"push"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];
    } else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"present"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:NO];
    } else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"livestream"]) {
        if (_touchLivestream) {
            _touchLivestream();
        }
    }
}

- (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic push:(BOOL)push {
    //类名(对象名)
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    id instance = [[newClass alloc] init];
    //下面是传值－－－－－－－－－－－－－－
    if (dic == nil || [dic isKindOfClass:[NSString class]]) {
        dic = @{};
    }
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([ZZUtils checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            [instance setValue:obj forKey:key];
        } else {
            NSLog(@"不包含key=%@的属性",key);
        }
    }];
    if ([instance isKindOfClass:[ZZRecordViewController class]]) {
        [ZZUtils checkRecodeAuth:^(BOOL authorized) {
            if (authorized) {
                [self navigationMethod:instance push:push];
            }
        }];
    }
    else if ([instance isKindOfClass:[ZZUserChuzuViewController class]]) {    //旧版出租类名，后台未做调整，延用
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        ZZUserChuzuViewController *controller = [sb instantiateViewControllerWithIdentifier:@"rentStart"];
        //        controller.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:controller animated:YES];
        //未出租状态前往申请达人，其余状态进入主题管理
        if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
            WeakSelf
            ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
            registerRent.type = RentTypeRegister;
            [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
                ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }];
            [self.navigationController presentViewController:registerRent animated:YES completion:nil];
        } else {
            ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        return;
    }
    else if ([instance isKindOfClass:[ZZSelfIntroduceVC class]]) {
        BLOCK_SAFE_CALLS(self.touchRecordVideo);
    }
    else if ([instance isKindOfClass:[ZZChatVideoPlayerController class]]) {// 纯视频介绍页面
        ZZChatVideoPlayerController *playerVC = [[ZZChatVideoPlayerController alloc] init];
        playerVC.entrance = EntranceOthers;
        playerVC.videoUrl = [dic objectForKey:@"urlString"];
        [self presentViewController:playerVC animated:YES completion:nil];
    }
    else {
        [self navigationMethod:instance push:push];
    }
}

- (void)navigationMethod:(id)instance push:(BOOL)push {
    if (push) {
        UIViewController *ctl = (UIViewController *)instance;
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:instance animated:YES];
    } else {
        ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:instance];
        [self presentViewController:navCtl animated:YES completion:nil];
    }
}

#pragma mark - XRWaterfallLayoutDelegate methods
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (_activitityDic && [_activitityDic[@"pdgWgShow"] boolValue] && index == 0) {
        return 245.0;
    }
    
    if (_activitityDic && [_activitityDic[@"pdgWgShow"] boolValue]) {
        index--;
    }
    
    float marginH = [self.skillIntroHArray[index] intValue] > 0 ? 10 : 0;
    return (SCREEN_WIDTH - 5) / 2 + 85 + [self.skillIntroHArray[index] floatValue] + marginH;
}

#pragma mark - lazyload
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        //        _tableview.rowHeight = 135;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = RGBCOLOR(245, 245, 245);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollsToTop = YES;
        
        [_tableview registerClass:[ZZHomeNewRecommendCell class] forCellReuseIdentifier:[ZZHomeNewRecommendCell cellIdentifier]];
        [_tableview registerClass:[ZZNewHomeTaskFreeCell class] forCellReuseIdentifier:[ZZNewHomeTaskFreeCell cellIdentifier]];
        [_tableview registerClass:[ZZNewHomeRentEntryCell class] forCellReuseIdentifier:[ZZNewHomeRentEntryCell cellIdentifier]];
        
        //        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.01f)];
        
        //        if (SCREEN_HEIGHT >= 812.0) {
        //            _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 34.0)];
        //        }
    }
    return _tableview;
}

- (ZZAlertNotNetEmptyView *)alertEmptyView {    //无网络弹窗
    if (!_alertEmptyView) {
        _alertEmptyView = [[ZZAlertNotNetEmptyView alloc]init];
        [_alertEmptyView alertShowViewController:self];
    }
    return _alertEmptyView;
}

- (NSMutableArray<ZZHomeRecommendDetailModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)skillIntroHArray {
    if (nil == _skillIntroHArray) {
        _skillIntroHArray = [NSMutableArray array];
    }
    return _skillIntroHArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
