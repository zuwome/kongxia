//
//  ZZHomeRecommendViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeRefreshViewController.h"
#import "ZZHomeRefreshCell.h"
#import "ZZRentViewController.h"

#import "ZZHomeHelper.h"

#import <NJKScrollFullScreen.h>
#import <Underscore.h>
#import "ZZNotNetEmptyView.h"
#import "ZZAlertNotNetEmptyView.h"
#import "HttpDNS.h"
#import "ZZNewHomeViewController.h"

@interface ZZHomeRefreshViewController () <UITableViewDataSource,UITableViewDelegate,NJKScrollFullscreenDelegate, ZZHomeRefreshCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, strong) NJKScrollFullScreen *scrollProxy;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ZZHomeRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  kBGColor;

    [self createViews];
    [self sendRequest];
    _haveLoad = YES;
    _update = NO;
    WeakSelf
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf reloadInfo];
        }
    };
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coverWindowClick) name:@"click" object:nil];
}


- (void)coverWindowClick {
   [UIView animateWithDuration:0.5 animations:^{
       [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
   }];
}

- (void)reloadInfo
{
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - SendRequest

- (void)sendRequest
{
    WeakSelf;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getHeadData];
    }];
    
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getFootData];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)getHeadData
{
    _pageIndex = 1;
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    [self.tableView.mj_footer resetNoMoreData];
    NSMutableDictionary *aDcit = [@{@"cate":self.type} mutableCopy];
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
    
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
        [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
    }
    
    aDcit[@"pageIndex"] = @(_pageIndex);
    
    NSLog(@"*************************************\n \
          Refresh aDict is %@ \n\
          *************************************",aDcit);
    WS(weakSelf);
    [helper getHomeListWithParam:aDcit
                            next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                [weakSelf headerCallBack:error data:data task:task];
                            }];
}

- (void)getFootData {
    _pageIndex += 1;
    ZZHomeHelper *helper = [[ZZHomeHelper alloc] init];
    if (self.dataArray.count > 0) {
        ZZHomeNearbyModel *model = [self.dataArray lastObject];
        // FIXME: 可能会产生崩溃
        NSMutableDictionary *aDcit = @{@"cate":self.type ?: @"new",
                                       @"sortValue":model.sortValue ?: @"0"}.mutableCopy;
        
        if (model.current_star) {
            [aDcit setObject:model.current_star forKey:@"current_star"];
        }
        if (self.cityName) {
            [aDcit setObject:self.cityName forKey:@"cityName"];
        }
        if (self.filterDict) {
            aDcit = [[NSMutableDictionary alloc] initWithDictionary:Underscore.extend(self.filterDict, aDcit)];
        }
        if ([ZZUserHelper shareInstance].isLogin) {
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
        
        if ([ZZUserHelper shareInstance].location) {
            CLLocation *location = [ZZUserHelper shareInstance].location;
            [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
            [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
        }
        aDcit[@"pageIndex"] = @(_pageIndex);
        [helper getHomeListWithParam:aDcit
                                next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                    [self footerCallBack:error data:data task:task];
                                }];
        
    }
    else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)headerCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task {
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
        _dataArray = [ZZHomeNearbyModel arrayOfModelsFromDictionaries:data error:nil];
        if (_dataArray.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.emptyView.hidden = YES;
        [_tableView reloadData];
    }
   
    [_tableView.mj_header endRefreshing];
}

- (void)footerCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task
{
    [_tableView.mj_footer endRefreshing];
    if (error) {
        _pageIndex -= 1;
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
        NSMutableArray *ndata = [ZZHomeNearbyModel arrayOfModelsFromDictionaries:data error:nil];
        if (ndata.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [_dataArray addObjectsFromArray:ndata];
            [_tableView reloadData];
        }
    }

}

- (void)updateData {
    if (_haveLoad) {
        if ([_tableView.mj_header isRefreshing]) {
            [self getHeadData];
        } else {
            [_tableView.mj_header beginRefreshing];
        }
        _update = NO;
    }
}

- (void)refresh {
    [_tableView.mj_header beginRefreshing];
}

- (void)createViews {
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = kBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    _emptyView = [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:self.view.frame viewController:self];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    _tableView.delegate = (id)_scrollProxy;
    _scrollProxy.delegate = self;
    _scrollProxy.downThresholdY = 0.0;
}

#pragma mark - ZZHomeRefreshCellDelegate
- (void)cellTapped:(ZZHomeRefreshCell *)cell model:(ZZHomeNearbyModel *)model {
    if (_tapCell) {
        _tapCell(model,cell.imgView);
    }
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    
    ZZHomeRefreshCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZHomeRefreshCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell setModel:_dataArray[indexPath.row]];
    __weak typeof(cell)weakCell = cell;
    cell.touchCancel = ^{
        [self touchCancelCell:weakCell];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
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

- (void)touchCancelCell:(ZZHomeRefreshCell *)cell {
    if (self.tableView.mj_header.isRefreshing) {
        return;
    }
    [MobClick event:Event_click_home_refresh_cancel];
    if ([ZZUtils isUserLogin]) {
        if (cell) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            ZZHomeNearbyModel *model = self.dataArray[indexPath.row];
            [ZZHomeModel refreshCancel:model.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                
            }];
            
            [_dataArray removeObjectAtIndex:indexPath.row];
            if (indexPath.row < [self.tableView numberOfRowsInSection:indexPath.section]) {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                [self.tableView reloadData];
            }
            
            if (_touchCancel) {
                _touchCancel(model.user.uid);
            }
            
            if (_dataArray.count == 0) {
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }
}

- (void)refreshCancel:(NSString *)uid {
    if (self.tableView.mj_header.isRefreshing) {
        return;
    }
    for (ZZHomeNearbyModel *model in self.dataArray) {
        if ([model.user.uid isEqualToString:uid]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:0];
            [self.dataArray removeObject:model];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark NJKScrollFullScreen
- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY {
    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - SCREEN_HEIGHT - 50) {
        
    }
    else {
        if (_didScroll && ![_tableView.mj_footer isRefreshing]) {
            _didScroll(deltaY);
        }
    }
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY {
    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - SCREEN_HEIGHT - 50) {
        
    }
    else {
        if (_didScroll && ![_tableView.mj_footer isRefreshing]) {
            _didScroll(deltaY);
        }
    }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy {
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
