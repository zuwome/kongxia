//
//  ZZHomeNearViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeNearbyViewController.h"
#import "ZZHomeNearbyCell.h"
#import "ZZRentViewController.h"

#import "ZZHomeHelper.h"
#import "ZZHomeNearLocationGuideView.h"

#import <NJKScrollFullScreen.h>
#import <Underscore.h>
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "HttpDNS.h"
#import "ZZNewHomeViewController.h"

@interface ZZHomeNearbyViewController () <UITableViewDataSource,UITableViewDelegate,NJKScrollFullscreenDelegate,ZZHomeNearbyCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, strong) NJKScrollFullScreen *scrollProxy;
@property (nonatomic, assign) BOOL authorized;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;

@end

@implementation ZZHomeNearbyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    [self checkLocationAuthority];
    
    _haveLoad = YES;
    _update = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endRefresh) name:@"homeendrefresh"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadInfo)
                                                 name:kMsg_UserLogin
                                               object:nil];
//    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WeakSelf
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf reloadInfo];
        }
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"did disappear");
}

- (void)checkLocationAuthority
{
    if (![LocationMangers shared].hasPermission) {
        _authorized = NO;
        [self.tableView reloadData];
    } else {
        _authorized = YES;
        [self sendRequest];
    }
}

- (void)endRefresh
{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void)reloadInfo
{
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - SendRequest

- (void)sendRequest
{
    __weak typeof(self)weakSelf = self;
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        NSMutableDictionary *aDcit = [@{@"cate":weakSelf.type} mutableCopy];
        if (weakSelf.cityName) {
            [aDcit setObject:weakSelf.cityName forKey:@"cityName"];
            if ([[ZZUserHelper shareInstance].cityName isEqualToString:weakSelf.cityName]) {
                // FIXME:新定位
                if ([[ZZUserDefaultsHelper objectForDestKey:@"NewLocation"] isEqualToString:@"1"]) {
                    [ZZUserDefaultsHelper setObject:@"0" forDestKey:@"NewLocation"];
                    [aDcit setObject:@"gps" forKey:@"city_choose_by"];
                }
                else {
                    [aDcit setObject:@"" forKey:@"city_choose_by"];
                }
            }
        }
        if (![ZZUserHelper shareInstance].isLogin && [ZZUserHelper shareInstance].location) {
            CLLocation *location = [ZZUserHelper shareInstance].location;
            [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
            [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
        }
        if (weakSelf.filterDict) {
            aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(weakSelf.filterDict, aDcit)];
        }
        [helper getHomeListWithParam:aDcit
                                next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                if (error.code==1111) {
                    if (weakSelf.dataArray.count<=0) {
                        weakSelf.emptyView.hidden = NO;
                        weakSelf.update = YES;
                    }else{
                        weakSelf.emptyView.hidden = YES;
                        [weakSelf.alertEmptyView showView:self];
                    }
                }else{
                    [ZZHUD showErrorWithStatus:error.message];
                }
            } else {
                self.emptyView.hidden = YES;
                weakSelf.dataArray = [ZZHomeNearbyModel arrayOfModelsFromDictionaries:data error:nil];
                if (weakSelf.dataArray.count == 0) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [weakSelf.tableView reloadData];
            }
         
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.dataArray.count) {
            ZZHomeNearbyModel *model = [weakSelf.dataArray lastObject];
            NSMutableDictionary *aDcit = [@{@"cate":weakSelf.type,
                                            @"sortValue":model.sortValue} mutableCopy];
            if (weakSelf.cityName) {
                [aDcit setObject:weakSelf.cityName forKey:@"cityName"];
                if ([[ZZUserHelper shareInstance].cityName isEqualToString:weakSelf.cityName] && _haveGetLocation) {
                    // FIXME:新定位
                    if ([[ZZUserDefaultsHelper objectForDestKey:@"NewLocation"] isEqualToString:@"1"]) {
                        [aDcit setObject:@"gps" forKey:@"city_choose_by"];
                    }
                    else {
                        [aDcit setObject:@"" forKey:@"city_choose_by"];
                    }
                }
            }
            if (![ZZUserHelper shareInstance].isLogin && [ZZUserHelper shareInstance].location) {
                CLLocation *location = [ZZUserHelper shareInstance].location;
                [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
                [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
            }
            if (weakSelf.filterDict) {
                aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(weakSelf.filterDict, aDcit)];
            }
            [helper getHomeListWithParam:aDcit
                                    next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                        [_tableView.mj_footer endRefreshing];
                                        if (error) {
                                            [ZZHUD showErrorWithStatus:error.message];
                                            if (weakSelf.dataArray.count>0&&error.code ==1111) {
                                                [weakSelf.alertEmptyView showView:self];
                                            }
                                        } else {
                                            NSMutableArray *ndata = [ZZHomeNearbyModel arrayOfModelsFromDictionaries:data error:nil];
                                            if (ndata.count == 0) {
                                                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                            } else {
                                                [weakSelf.dataArray addObjectsFromArray:ndata];
                                                [weakSelf.tableView reloadData];
                                            }
                                        }
                                    }];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if (weakSelf.dataArray.count<=0) {
            _emptyView.hidden = NO;
            weakSelf.update = YES;
        }else{
            _emptyView.hidden = YES;
        }
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)updateData
{
    if (_haveLoad) {
        [_tableView.mj_header beginRefreshing];
        _update = NO;
    }
}

- (void)refresh {
    [_tableView.mj_header beginRefreshing];
}

- (void)updateLocationInfoAndRefresh {
    [self checkLocationAuthority];
}

#pragma mark - CreateViews

- (void)createViews
{
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = kBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.userInteractionEnabled = YES;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    _emptyView =  [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:self.view.frame viewController:self];
    [self.view bringSubviewToFront:_emptyView];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    _tableView.delegate = (id)_scrollProxy;
    _scrollProxy.delegate = self;
    _scrollProxy.downThresholdY = 0.0;
    
}

#pragma mark - ZZHomeNearbyCellDelegate
-(void)cellTapped:(ZZHomeNearbyCell *)cell model:(ZZHomeNearbyModel *)model {
    if (_tapCell) {
        _tapCell(model,cell.imgView);
    }
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZHomeNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZHomeNearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell setModel:_dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_authorized) {
        return 0.1;
    } else {
        return 350;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_authorized) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    } else {
        ZZHomeNearLocationGuideView *footView = [[ZZHomeNearLocationGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
        return footView;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) { //滚动到顶部通知supertable可滚动
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

#pragma mark NJKScrollFullScreen

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - SCREEN_HEIGHT - 50) {
        
    } else {
        if (_didScroll && ![_tableView.mj_footer isRefreshing]) {
            _didScroll(deltaY);
        }
    }
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - SCREEN_HEIGHT - 50) {
        
    } else {
        if (_didScroll && ![_tableView.mj_footer isRefreshing]) {
            _didScroll(deltaY);
        }
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
//    [_scrollProxy reset];
//    [self showNavigationBar:YES];
//    [self showToolbar:YES];
//    if (_didScrollStatus) {
//        _didScrollStatus(YES);
//    }
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


@end
