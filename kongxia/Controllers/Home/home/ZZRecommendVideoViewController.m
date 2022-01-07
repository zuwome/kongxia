//
//  ZZRecommendVideoViewController.m
//  zuwome
//
//  Created by angBiu on 2017/3/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecommendVideoViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZRecordViewController.h"
#import "ZZTopicDetailViewController.h"
#import <NJKScrollFullScreen.h>

#import "ZZRecommendVideoCell.h"
#import "ZZFindTopicCell.h"

#import "ZZFindVideoModel.h"
#import "XRWaterfallLayout.h"
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "HttpDNS.h"
@interface ZZRecommendVideoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XRWaterfallLayoutDelegate, NJKScrollFullscreenDelegate>

@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) BOOL shouldUpdateData;
@property (nonatomic, assign) BOOL viewDidAppear;
@property (nonatomic, strong) NJKScrollFullScreen *scrollProxy;

@property (nonatomic, strong) XRWaterfallLayout *waterfall;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZRecommendVideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (_shouldUpdateData) {
        [self refresh];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _viewDidAppear = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _viewDidAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"附近视频";
    self.view.backgroundColor = kBGColor;
    _location = [ZZUserHelper shareInstance].location;
    [self createViews];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateVideo)
                                                 name:kMsg_VideoDataShouldUpdate
                                               object:nil];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.collectionView.mj_header beginRefreshing];
        }
    };
}

- (void)createViews
{
    [self.view addSubview:self.collectionView];
   _emptyView =   [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:_collectionView.frame viewController:self];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    self.collectionView.delegate = (id)_scrollProxy;
    _scrollProxy.delegate = self;
}

- (void)loadData
{
    WeakSelf;
    weakSelf.collectionView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullRequest:nil current_type:nil drop:YES];
    }];
    weakSelf.collectionView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZFindVideoModel *model = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:model.sort_value current_type:model.current_type drop:NO];
    }];
    [weakSelf.collectionView.mj_header beginRefreshing];
}

/**
 加载网络

 @param isDropDownRefresh 是否是下拉刷新  no上拉加载  yes下拉刷新
 */
- (void)pullRequest:(NSString *)sort_value current_type:(NSString *)current_type drop:(BOOL)isDropDownRefresh
{
    WEAK_SELF();
    NSMutableDictionary *aDict = [@{@"type":@"1"} mutableCopy];
    if (_location) {
        [aDict setObject:[NSNumber numberWithFloat:_location.coordinate.latitude] forKey:@"lat"];
        [aDict setObject:[NSNumber numberWithFloat:_location.coordinate.longitude] forKey:@"lng"];
    }
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
        [aDict setObject:current_type forKey:@"current_type"];
    }
    [ZZFindVideoModel getRecommendVideList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [weakSelf dataCallBack:error data:data task:task sort_value:sort_value drop:isDropDownRefresh];
    }];
}

- (void)dataCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task sort_value:(NSString *)sort_value drop:(BOOL)isDropDownRefresh
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    if (error) {
        if (error.code ==1111) {
            if (self.dataArray.count<=0) {
                self.emptyView.hidden = NO;
            }else{
                self.emptyView.hidden = YES;
                [self.alertEmptyView showView:self];
            }
        }else{
            [ZZHUD showErrorWithStatus:error.message];
        }
    } else {
        self.emptyView.hidden = YES;

        NSMutableArray *array = [ZZFindVideoModel arrayOfModelsFromDictionaries:data error:nil];
        NSMutableArray *filteredArray = [self filterVideoArray:array.copy];
        if (filteredArray.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (isDropDownRefresh) {
            self.dataArray = filteredArray;
        }else {
            [self.dataArray addObjectsFromArray:filteredArray];
        }
        [self.collectionView reloadData];
        
        for (ZZFindVideoModel *model in filteredArray) {
            if (!model.group.groupId) {
                [self.videoArray addObject:model];
            }
        }
    }

}

- (NSMutableArray<ZZFindVideoModel *> *)filterVideoArray:(NSArray<ZZFindVideoModel *> *)array {
    if (array.count == 0) {
        return [array mutableCopy];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    // 拉黑的用户
    NSMutableArray<NSString *> *peopleMuArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
    
    // 不感兴趣的视频
    NSMutableArray<NSString *> *videoMuArray = [[userDefault objectForKey:@"UserVideoNotIntersted"] mutableCopy];
    
    if (videoMuArray.count == 0 && peopleMuArray.count == 0) {
        return [array mutableCopy];
    }
    
    // 拉黑的用户
    NSMutableArray<ZZFindVideoModel *> *peoplefilteredArray = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(ZZFindVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![peopleMuArray containsObject:obj.sk.user.uid] && ![peopleMuArray containsObject:obj.mmd.from.uid]) {
            [peoplefilteredArray addObject: obj];
        }
    }];
    
    
    
    // 不感兴趣的视频
    NSMutableArray<ZZFindVideoModel *> *filteredArray = @[].mutableCopy;
    [peoplefilteredArray enumerateObjectsUsingBlock:^(ZZFindVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![videoMuArray containsObject:obj.sk.skId] && ![videoMuArray containsObject:obj.mmd.mid]) {
            [filteredArray addObject: obj];
        }
    }];
    
    return filteredArray;
}

- (void)updateVideo
{
    if (_viewDidAppear) {
        [self refresh];
    } else {
        _shouldUpdateData = YES;
    }
}

- (void)refresh
{
    _shouldUpdateData = NO;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Private methods

- (IBAction)zanClick:(NSIndexPath *)indexPath {
    
    [MobClick event:Event_click_player_zan];
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    if (model.like_status) {
        // 取消赞
        if (model.sk.skId) {
            // 时刻视频
            [self skUnLisk:indexPath];
        } else {
            // 么么哒视频
            [self mmdUnLike:indexPath];
        }
    } else {
        // 赞
        if (model.sk.skId) {
            // 时刻视频
            [self skLike:indexPath];
        } else {
            // 么么哒视频
            [self mmdLike:indexPath];
        }
    }
}

- (IBAction)commentClick:(NSIndexPath *)indexPath {
    
    WEAK_SELF();
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.isShowNotInterested = YES;
    controller.isShowBlackList = YES;
    controller.canLoadMore = YES;
    controller.dataArray = self.videoArray;
    NSIndexPath *path = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:model] inSection:0];
    controller.dataIndexPath = path;
    controller.hidesBottomBarWhenPushed = YES;
    controller.playType = PlayTypeFindHot;
    controller.isShowTextField = YES;
    
    controller.deleteCallBack = ^{
        [weakSelf.collectionView.mj_header beginRefreshing];
    };
    
    controller.notInterstedCallBack = ^{
        weakSelf.dataArray = [weakSelf filterVideoArray:weakSelf.dataArray.copy];
        [weakSelf.collectionView reloadData];
    };
    
    controller.vBannedCallBack = ^(NSString *userID) {
        weakSelf.dataArray = [weakSelf filterVideoArray:weakSelf.dataArray.copy];
        [weakSelf.collectionView reloadData];
    };
    controller.firstFindModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)skLike:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZSKModel zanSkWithModel:model.sk next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = YES;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
        }
    }];
}

- (void)skUnLisk:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZSKModel zanSkWithModel:model.sk next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = NO;
            [ZZHUD showSuccessWithStatus:@"取消赞"];
        }
    }];
}

- (void)mmdLike:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZMemedaModel zanMemeda:model.mmd next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = YES;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
        }
    }];
}

- (void)mmdUnLike:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZMemedaModel zanMemeda:model.mmd next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = NO;
            [ZZHUD showSuccessWithStatus:@"取消赞"];
        }
    }];
}

#pragma mark - XRWaterfallLayoutDelegate methods

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    if (model.group.groupId) {
        CGFloat width = (SCREEN_WIDTH - 15) / 2.0;
        return width * 13 / 9;
    }
    CGFloat imageHeight = 0;
    NSString *content = @"";
    if (model.sk.skId) {
        imageHeight = [INT_TO_STRING(model.sk.video.height) floatValue] / [INT_TO_STRING(model.sk.video.width) floatValue] * itemWidth;
        content = model.sk.content;
    } else {
        ZZMMDAnswersModel *mmd = model.mmd.answers.firstObject;
        imageHeight = [INT_TO_STRING(mmd.video.height) floatValue] / [INT_TO_STRING(mmd.video.width) floatValue] * itemWidth;
        content = model.mmd.content;
    }
    if (imageHeight >= VIDEO_MAX_HEIGHT || isnan(imageHeight)) {
        imageHeight = VIDEO_MAX_HEIGHT;
    }
    CGFloat textHeight = [ZZUtils heightForCellWithText:content fontSize:12 labelWidth:itemWidth - 30];
    return imageHeight + (textHeight == 0 ? 58 : (textHeight + 68));
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    WEAK_SELF();
    if (model.group.groupId) {
        ZZFindTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topic" forIndexPath:indexPath];
        [cell setData:model.group];
        return cell;
    } else {
        ZZRecommendVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
        
        [cell setData:model];
        [cell setZanBlock:^{
            //赞
            [weakSelf zanClick:indexPath];
        }];
        [cell setCommentBlock:^{
            //评论
            [weakSelf commentClick:indexPath];
        }];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    WeakSelf;
    if (model.group.groupId) {
        ZZTopicDetailViewController *controller = [[ZZTopicDetailViewController alloc] init];
        controller.groupModel = model.group;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else{
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:model] inSection:0];
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.isShowNotInterested = YES;
        controller.isShowBlackList = YES;
        controller.canLoadMore = YES;
        controller.dataArray = self.videoArray;
        controller.dataIndexPath = path;
        controller.hidesBottomBarWhenPushed = YES;
        controller.playType = PlayTypeRecommend;
        controller.deleteCallBack = ^{
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
        controller.notInterstedCallBack = ^{
            weakSelf.dataArray = [weakSelf filterVideoArray:weakSelf.dataArray.copy];
            [weakSelf.collectionView reloadData];
        };
        
        controller.vBannedCallBack = ^(NSString *userID) {
            weakSelf.dataArray = [weakSelf filterVideoArray:weakSelf.dataArray.copy];
            [weakSelf.collectionView reloadData];
        };
        controller.firstFindModel = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)publishBtnClick
{
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            [self gotoRecordView];
        }
    }];
}

- (void)gotoRecordView
{
    ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCtl animated:YES completion:nil];
}

#pragma mark NJKScrollFullScreen

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    if (_didScroll) {
        _didScroll(deltaY);
    }
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    if (_didScroll) {
        _didScroll(deltaY);
    }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    if (_didScrollStatus) {
        _didScrollStatus(NO);
    }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    if (_didScrollStatus) {
        _didScrollStatus(YES);
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

#pragma mark - lazyload

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
        //或者一次性设置
        [self.waterfall setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(0, 5, 0, 5)];
        self.waterfall.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.waterfall];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ZZRecommendVideoCell class] forCellWithReuseIdentifier:@"mycell"];
        [_collectionView registerClass:[ZZFindTopicCell class] forCellWithReuseIdentifier:@"topic"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

    }
    return _collectionView;
}

- (UIButton *)publishBtn
{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50-SafeAreaBottomHeight, SCREEN_WIDTH, 50+SafeAreaBottomHeight)];
        _publishBtn.backgroundColor = kYellowColor;
        [_publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.userInteractionEnabled = NO;
        [_publishBtn addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_publishBtn.mas_centerX);
            make.top.bottom.mas_equalTo(_publishBtn);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_videorec_record"];
        [bgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(23.5, 17.5));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kBlackTextColor;
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"发布我的瞬间";
        [bgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(8);
            make.right.mas_equalTo(bgView.mas_right);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _publishBtn;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
- (ZZAlertNotNetEmptyView *)alertEmptyView {
    if (!_alertEmptyView) {
        _alertEmptyView = [[ZZAlertNotNetEmptyView alloc]init];
        [_alertEmptyView alertShowViewController:self];
    }
    return _alertEmptyView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

