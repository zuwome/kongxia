 //
//  ZZFindHotViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindHotViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZTopicViewController.h"
#import "ZZTopicDetailViewController.h"
//网络占位图
#import "ZZNotNetEmptyView.h"
#import "ZZAlertNotNetEmptyView.h"

#import "ZZFindHotHeadView.h"
#import "ZZFindNewCell.h"
#import "ZZFindTopicCell.h"
#import "ZZFindGroupsView.h"

#import "ZZFindVideoModel.h"
#import "ZZFindModel.h"
#import "ZZFindGroupModel.h"

#import <NJKScrollFullScreen.h>
#import "VideoPlayer.h"
#import "ZZAFNHelper.h"
#import "UIScrollView+Direction.h"
#import "HttpDNS.h"
@interface ZZFindHotViewController () <UICollectionViewDataSource,UICollectionViewDelegate,NJKScrollFullscreenDelegate,JPVideoPlayerDelegate, XRWaterfallLayoutDelegate>

@property (nonatomic, strong) ZZFindGroupsView *groupsView;
@property (nonatomic, strong) NSMutableArray<ZZFindVideoModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<ZZFindVideoModel *> *videoArray;
@property (nonatomic, strong) NJKScrollFullScreen *scrollProxy;
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, strong) ZZFindHotHeadView *headView;
@property (nonatomic, strong) NSMutableArray *bannerDataArray;

@property (nonatomic, strong) UICollectionViewCell *playingCell;
@property (nonatomic, assign) BOOL viewDidAppear;
@property (nonatomic, assign) BOOL isHaveLoad;//是否已经加载了
@property (nonatomic, assign) NSInteger lastEndCount;//上次的条数

@property (nonatomic, assign) BOOL isHidden;//是否隐藏了顶部
@property (nonatomic, assign) BOOL isCompleted;//动画是否已完成
//网络占位图
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZFindHotViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _viewDidAppear = YES;
    
    if (self.dataArray.count != 0) {
        [self handleScrollStop];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopPlay];
    
    _viewDidAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isCompleted = YES;
    self.view.backgroundColor = RGBCOLOR(243, 243, 243);
   _emptyView =  [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:self.view.frame viewController:self];
    WEAK_SELF();
    self.groupsView = [[ZZFindGroupsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.groupsView setFetchGroupsSuccessBlock:^(ZZFindGroupModel *model) {
        if (!weakSelf.collectionView) {
            [ZZHUD dismiss];
            [weakSelf createViews];
        }
        weakSelf.emptyView.hidden = YES;
    }];
    [self.groupsView setFetchGroupsFailBlock:^(ZZError *error,NSMutableArray *array) {
        [ZZHUD dismiss];
        if (error.code ==1111) {
            if (weakSelf.dataArray.count<=0) {
                weakSelf.emptyView.hidden = NO;
            }else{
                weakSelf.emptyView.hidden = YES;
                [weakSelf.alertEmptyView showView:weakSelf];
                
            }
        }else{
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
    [self.groupsView setDidSelectGroupsBlock:^(ZZFindGroupModel *model) {
        
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    [self.groupsView setDidStartScroll:^{
        BLOCK_SAFE_CALLS(weakSelf.didStartScroll);
    }];
    [self.groupsView setDidEndScroll:^{
        BLOCK_SAFE_CALLS(weakSelf.didEndScroll);
    }];
    [self.view addSubview:self.groupsView];

    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable ) {
            [weakSelf.groupsView againReloadGropusIfNeeded];
        }
    };
    _haveLoad = YES;
    _update = NO;
    _isHaveLoad = NO;
}

- (void)createViews
{

    
    //创建瀑布流布局
    self.waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];

    //或者一次性设置
    [self.waterfall setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    self.waterfall.delegate = self;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - 40) collectionViewLayout:self.waterfall];
    [self.collectionView registerClass:[ZZFindNewCell class] forCellWithReuseIdentifier:@"mycell"];
    [self.collectionView registerClass:[ZZFindTopicCell class] forCellWithReuseIdentifier:@"topic"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.enableDirection = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];

    self.collectionView.contentSize = CGSizeMake(0, SCREEN_WIDTH*5/9 + 105);
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    self.collectionView.delegate = (id)_scrollProxy;
    _scrollProxy.delegate = self;
    [self loadData];
//    [self loadVideos];
 
}

#pragma mark - Data

- (void)loadBaner
{
    WS(weakSelf);
    ZZFindModel *model = [[ZZFindModel alloc] init];
    [model getFindBanner:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (error) {
            if (error.code ==1111) {
                if (weakSelf.dataArray.count<=0) {
                    weakSelf.emptyView.hidden = NO;
                }else{
                    weakSelf.emptyView.hidden = YES;
                    [weakSelf.alertEmptyView showView:weakSelf];
                    
                }
            }else{
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else {
            weakSelf.emptyView.hidden = YES;

            weakSelf.bannerDataArray = [ZZFindModel arrayOfModelsFromDictionaries:data error:nil];
            NSMutableArray *imgArray = [NSMutableArray array];
            [weakSelf.bannerDataArray enumerateObjectsUsingBlock:^(ZZFindModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [imgArray addObject:model.img];
            }];
            weakSelf.headView = [[ZZFindHotHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.3) array:imgArray];
            weakSelf.headView.topicView.touchMore = ^{
                [weakSelf gotoTopicView];
            };
            weakSelf.headView.topicView.selectItem = ^(ZZTopicModel *model) {
                [weakSelf gotoTopicDetail:model.group];
            };
            weakSelf.headView.adView.callBack = ^(NSInteger index, NSString *imageURL) {
                [weakSelf banerSelectIndex:index];
            };
            weakSelf.headView.topicView.didStartScroll = ^{
                if (weakSelf.didStartScroll) {
                    weakSelf.didStartScroll();
                }
            };
            weakSelf.headView.topicView.didEndScroll = ^{
                if (weakSelf.didEndScroll) {
                    weakSelf.didEndScroll();
                }
            };
            weakSelf.headView.adView.didStartDrag = ^{
                if (weakSelf.didStartScroll) {
                    weakSelf.didStartScroll();
                }
            };
            weakSelf.headView.adView.didEndDrag = ^{
                if (weakSelf.didEndScroll) {
                    weakSelf.didEndScroll();
                }
            };
            [weakSelf createViews];
        }
        
        
    }];
}

// UICollectionView Header
- (void)loadVideos
{
    WS(weakSelf);
    [ZZTopicModel getTopicsWithParam:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZTopicModel arrayOfModelsFromDictionaries:data error:nil];
            if (array.count) {
                CGFloat headHeight = SCREEN_WIDTH/2.3 + 170;
//                _layout.sectionInset = UIEdgeInsetsMake(headHeight, 5.0f, 5.0f, 5.0f);
                weakSelf.waterfall.sectionInset = UIEdgeInsetsMake(headHeight, 5.0f, 5.0f, 5.0f);
                weakSelf.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headHeight);
                weakSelf.headView.topicView.dataArray = array;
                weakSelf.headView.topicView.hidden = NO;
            }
        }
    }];
}

- (void)loadData
{
    WeakSelf;
    self.collectionView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullRequest:nil sort_value2:nil];
    }];
    self.collectionView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZFindVideoModel *model = [weakSelf.videoArray lastObject];
        [weakSelf pullRequest:model.sort_value1 sort_value2:model.sort_value2];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_footer beginRefreshing];
    });
}


/**
 加载更多
 */
- (void)pullRequest:(NSString *)sort_value1 sort_value2:(NSString *)sort_value2
{
    self.isCompleted = NO;
    [self stopPlay];

    WEAK_SELF();
    
    if (!isNullString(weakSelf.groupsView.currentSelectGropus.id)) {
        NSMutableDictionary *aDict = [@{@"type":@"hot"} mutableCopy];
        [aDict setObject:weakSelf.groupsView.currentSelectGropus.id forKey:@"groupId"];
        if (sort_value1 && sort_value2) {
            [aDict setObject:sort_value1 forKey:@"sort_value1"];
            [aDict setObject:sort_value2 forKey:@"sort_value2"];
            
        }
        [ZZFindVideoModel getFindVideoList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            
            
            [weakSelf dataCallBack:error data:data task:task sort_value1:sort_value1 sort_value2:sort_value2];
            weakSelf.groupsView.userInteractionEnabled = YES;
        }];
    }
    
}

- (void)dataCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task sort_value1:(NSString *)sort_value1 sort_value2:(NSString *)sort_value2 {
    
    WEAK_SELF();
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_footer resetNoMoreData];
    if (error) {
        if (error.code == 1111&&weakSelf.dataArray.count>0) {
            [weakSelf.alertEmptyView showView:weakSelf];
            weakSelf.isCompleted = YES;;

            return;
        }
        [ZZHUD showErrorWithStatus:error.message];
        weakSelf.isCompleted = YES;;
    } else {
        [ZZHUD dismiss];
        NSMutableArray<ZZFindVideoModel *> *array = [ZZFindVideoModel arrayOfModelsFromDictionaries:data error:nil];
        NSMutableArray *filteredArray = [self filterVideoArray:array.copy];
        if (filteredArray.count == 0) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (!sort_value1) {
            _dataArray = filteredArray;
            [weakSelf.videoArray removeAllObjects];
        } else {
            [_dataArray addObjectsFromArray:filteredArray];
        }
        for (ZZFindVideoModel *model in filteredArray) {
            if (!model.group.groupId) {
                [weakSelf.videoArray addObject:model];
            }
        }
        
        
        [weakSelf.collectionView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf stopPlay];
            weakSelf.isCompleted = YES;;
        });
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
    
    if (peoplefilteredArray.count == 0) {
        return peoplefilteredArray;
    }
    
    // 不感兴趣的视频
    NSMutableArray<ZZFindVideoModel *> *filteredArray = @[].mutableCopy;
    [peoplefilteredArray enumerateObjectsUsingBlock:^(ZZFindVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![videoMuArray containsObject:obj.sk.skId] && ![videoMuArray containsObject:obj.mmd.mid]) {
            [filteredArray addObject: obj];
        }
    }];
    
    return filteredArray;
}

#pragma mark - XRWaterfallLayoutDelegate methods

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {

    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    if (model.group.groupId) {
        return (SCREEN_WIDTH - 15) / 2.0 * 13 / 9.0;
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
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    WEAK_SELF();
    if (model.group.groupId) {
        ZZFindTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topic" forIndexPath:indexPath];
        if (!collectionView.dragging&&!collectionView.decelerating) {
        [cell setData:model.group];
        }
        return cell;
    } else {
        ZZFindNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
            if (model.sk.skId) {
                [cell setSkData:model];
            } else {
                [cell setMMDData:model];
            }
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
    if (_pushCallBack) {
        _pushCallBack();
    }
    WeakSelf;
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    if (model.group.groupId) {
        [self gotoTopicDetail:model.group];
    } else{
       
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.isShowNotInterested = YES;
        controller.isShowBlackList = YES;
        controller.canLoadMore = YES;
        controller.groupId = self.groupsView.currentSelectGropus.id;
        controller.dataArray = self.videoArray;
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:model] inSection:0];
        controller.dataIndexPath = path;
        controller.hidesBottomBarWhenPushed = YES;
        controller.playType = PlayTypeFindHot;
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

#pragma mark - navigation

- (void)banerSelectIndex:(NSInteger)index
{
    [MobClick event:Event_click_find_banner];
    ZZFindModel *model = _bannerDataArray[index];
    
    if (model.link) {
        ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
        controller.urlString = model.link;
        controller.imgUrl = model.share_img;
        controller.shareTitle = model.title;
        controller.shareContent = model.sub_title;
        controller.showShare = YES;
        controller.hidesBottomBarWhenPushed = YES;
        controller.isHideBar = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void)gotoTopicView
{
    WeakSelf;
    ZZTopicViewController *controller = [[ZZTopicViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    controller.requestNewData = ^(NSMutableArray *array) {
        weakSelf.headView.topicView.dataArray = array;
    };
}

- (void)gotoTopicDetail:(ZZTopicGroupModel *)model
{
    ZZTopicDetailViewController *controller = [[ZZTopicDetailViewController alloc] init];
    controller.groupModel = model;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NJKScrollFullScreen

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    if (_didScroll) {
        NSLog(@"deltaY --- %.2f", deltaY);
        _didScroll(deltaY);
    }
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    if (_didScroll) {
        NSLog(@"deltaY --- %.2f", deltaY);
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

#pragma mark - 视频播放

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    scrollView.bounces = scrollView.contentOffset.y <= 0 ? YES : scrollView.bounces;
//    if (self.currentNoMoreData) {
//        scrollView.bounces = scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.size.height ? NO : YES;
//    }
//    NSLog(@"差值... %.2f", scrollView.contentSize.height - scrollView.contentOffset.y);
    
    // 暂时先注释顶部隐藏动画
    if (scrollView.contentOffset.y > 0.0 && scrollView.contentOffset.y < scrollView.contentSize.height) {
//        NSLog(@"=======%zd", scrollView.direction);
//        NSLog(@".... %.2f", scrollView.contentOffset.y);
//        if (self.isCompleted) {
//            
//            if (scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.size.height + 100) {//距离底部还有100的位置，则不再进行动画，防止到底部时动画来回弹
//                return;
//            }
//            
//            if (scrollView.direction == 1) {//向上
//                
//                if (!self.isHidden) {
//                    self.isHidden = YES;
//                    self.isCompleted = NO;
//                    [UIView animateWithDuration:0.4 animations:^{
//                        self.groupsView.mj_y = -40.0f;
//                        self.collectionView.mj_y = 0.0f;
//                        self.collectionView.height = SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT;
//                    } completion:^(BOOL finished) {
//                        self.isCompleted = YES;
//                    }];
//                }
//            } else if (scrollView.direction == 2) {//向下
//                if (self.isHidden) {
//                    self.isHidden = NO;
//                    self.isCompleted = NO;
//                    [UIView animateWithDuration:0.4 animations:^{
//                        self.groupsView.mj_y = 0.0f;
//                        self.collectionView.mj_y = 40.0f;
//                        self.collectionView.height = SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - 40;
//
//                    } completion:^(BOOL finished) {
//                        self.isCompleted = YES;
//                    }];
//                }
//            }
//        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //竖直滑动时 判断是上滑还是下滑
//    if (velocity.y > 0) {
//        //上滑
//        NSLog(@"上滑");
//    } else {
//        //下滑
//        NSLog(@"下滑");
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        //加载图片
//        [self loadCellData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //加载图片
//      [self loadCellData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    BLOCK_SAFE_CALLS(self.didEndScroll);
    [self handleScrollStop];
}

#pragma mark - 加载可视区域的数据
- (void)loadCellData {
    WS(weakSelf);
    NSArray *indexsArray = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in indexsArray) {
        ZZFindVideoModel *model = _dataArray[indexPath.row];
        if (model.userHeaderImgIcon) {
            //如果用户头像和视屏已经加载过了就return
            return;
        }
         if (model.group.groupId) {
             ZZFindTopicCell *cell = (ZZFindTopicCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
             [cell setData:model.group];
         } else {
              ZZFindNewCell *cell = (ZZFindNewCell*)(ZZFindTopicCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
             if (model.sk.skId) {
                 [cell setSkData:model];
             } else {
                 [cell setMMDData:model];
             }
             [cell setZanBlock:^{
                 //赞
                 [weakSelf zanClick:indexPath];
             }];
             [cell setCommentBlock:^{
                 //评论
                 [weakSelf commentClick:indexPath];
             }];
         }
    }
}

- (void)handleScrollStop
{
    WEAK_SELF();
    [weakSelf stopPlay];
    if ([weakSelf canPlay]) {
        [weakSelf play];
    } else if (_playingCell) {
        [weakSelf stopPlay];
    }
}

- (void)play
{
    WEAK_SELF();
    NSArray *visiableCells = [weakSelf.collectionView visibleCells];
    if (![visiableCells containsObject:weakSelf.playingCell]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        if (visiableCells.count) {
            for (UICollectionViewCell *cell in visiableCells) {
                if ([cell isKindOfClass:[ZZFindNewCell class]]) {
                    [tempArray addObject:cell];
                }
            }
            if (tempArray.count != 0) {
                NSInteger index = arc4random()%tempArray.count;
                ZZFindNewCell *cell = (ZZFindNewCell *)tempArray[index];
                WEAK_OBJECT(cell, weakCell);
                weakCell.imgView.jp_videoPlayerDelegate = weakSelf;
                
                if (weakCell.model.sk.skId) {
                    NSLog(@"PY_视频地址 %@\n",weakCell.model.sk.video.video_url);
                    [weakCell.imgView jp_playVideoWithURL:[NSURL URLWithString:weakCell.model.sk.video.video_url] options:JPVideoPlayerContinueInBackground | JPVideoPlayerMutedPlay | JPVideoPlayerLayerVideoGravityResizeAspectFill progress:nil completed:nil];
                    
                } else {
                    ZZMMDAnswersModel *answerModel = weakCell.model.mmd.answers[0];
                    [weakCell.imgView jp_playVideoWithURL:[NSURL URLWithString:answerModel.video.video_url] options:JPVideoPlayerContinueInBackground | JPVideoPlayerMutedPlay | JPVideoPlayerLayerVideoGravityResizeAspectFill progress:nil completed:nil];
                }
                _playingCell = weakCell;
            }
        }
    }
}

- (void)stopPlay
{
    if (!self.playingCell) {
        return;
    }
    [self.playingCell jp_stopPlay];
    self.playingCell = nil;
}

- (void)pause
{
    
}

- (BOOL)canPlay
{
    if (!_viewDidAppear) {
        return NO;
    }
    switch ([[ZZAFNHelper shareInstance] reachabilityManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            return YES;
        }
            break;
        default:
        {
            return NO;
        }
            break;
    }
}

#pragma mark -

- (NSMutableArray<ZZFindVideoModel *> *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
/**
 无网络弹窗
 */
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
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
    if (_viewDidAppear) {
        [[JPVideoPlayerCache sharedCache] clearDiskOnCompletion:^{
            [self handleScrollStop];
        }];
    }
}


@end
