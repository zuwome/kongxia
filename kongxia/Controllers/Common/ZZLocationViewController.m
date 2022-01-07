//
//  ZZLocationViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/5/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZLocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "ZZRentLocationCell.h"

@interface ZZLocationViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKSuggestionSearchDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) UIImageView *pinImageView;

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) ZZRentLocationAlertView1 *alertView;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, assign) BOOL searchKeywords;

@property (nonatomic, assign) BOOL regionDidChangeWithoutReload;

@property (nonatomic, assign) BOOL regionFirstDidChangeWithoutReload;

@property (nonatomic, assign) BOOL searchedReloadListTableViewView;

@property (nonatomic, assign) BOOL isSearchingPois;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSArray<BMKPoiInfo *> *poiInfos;

@property (nonatomic, strong) NSArray<BMKPoiInfo *> *poiInCityInfos;

@property (nonatomic, strong) NSArray<BMKSuggestionInfo *> *keywordsInfos;

@end

@implementation ZZLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchKeywords = NO;
    _regionFirstDidChangeWithoutReload = YES;
    _searchedReloadListTableViewView = NO;
    
    [self layoutNavigations];
    [self layout];
    
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK: BMK_COORDTYPE_COMMON];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CLLocation *location = [ZZUserHelper shareInstance].location;
        
        CLLocationCoordinate2D coordiante = kCLLocationCoordinate2DInvalid;
        if (location) {
            coordiante = location.coordinate;
        }
        else if (_city) {
            NSArray *point = [_city.center componentsSeparatedByString:@","];
            coordiante = CLLocationCoordinate2DMake([point[1] floatValue], [point[0] floatValue]);
        }
//        CLLocationCoordinate2D bdCoordiante = [self convertToBD09Coord:coordiante];
        [_mapView setCenterCoordinate:coordiante animated:YES];
        [self searchPoisByCenterCoordinate:coordiante];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillDisappear];
}

- (void)selectedSpot:(BMKPoiInfo *)poiInfo {
    BOOL contain = NO;
    if (_city) {
        NSRange range = [poiInfo.city rangeOfString:_city.name];
        if (range.location != NSNotFound) {
            contain = YES;
        }
        range = [_city.name rangeOfString:poiInfo.city];
        if (range.location != NSNotFound) {
            contain = YES;
        }
        if (!contain) {
            contain = [self isContainSpecialCity:@"香港" poi:poiInfo];
        }
        if (!contain) {
            contain = [self isContainSpecialCity:@"澳门" poi:poiInfo];
        }
    }
    else {
        contain = YES;
    }
    
    if (!contain) {
        [UIAlertView showWithTitle:@"提示" message:
         [NSString stringWithFormat:@"出租地点请选择在%@内 ^_^",_city.name] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
             CLLocation *location = [ZZUserHelper shareInstance].location;
             if (location) {
                 [_mapView setCenterCoordinate:location.coordinate animated:YES];
             } else {
                 NSArray *point = [_city.center componentsSeparatedByString:@","];
                 [_mapView setCenterCoordinate:(CLLocationCoordinate2D){[point[1] floatValue], [point[0] floatValue]} animated:YES];
             }
         }];
    }
    else {
     [self.searchController setActive:NO];
        if ([poiInfo.detailInfo.type isEqualToString:@"hotel"]) {
            [ZZHUD showTastInfoErrorWithString:@"请选择公共场合"];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        ZZRentDropdownModel *model = [[ZZRentDropdownModel alloc] init];
        model.name = poiInfo.name;
        model.location = [[CLLocation alloc] initWithLatitude:poiInfo.pt.latitude longitude:poiInfo.pt.longitude];
        model.detaiString = poiInfo.address;
        if (isNullString(poiInfo.city)) {
            model.city = poiInfo.province;
        }
        else {
            model.city = poiInfo.city;
        }
        if (_selectPoiDone) {
            _selectPoiDone(model);
        }
    }
}

- (BOOL)isContainSpecialCity:(NSString *)city poi:(BMKPoiInfo *)poi {
    BOOL contain = NO;
    NSRange range = [_city.name rangeOfString:city];
    if (range.location != NSNotFound) {
        range = [poi.city rangeOfString:city];
        if (range.location != NSNotFound) {
            contain = YES;
        }
    }
    return contain;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"12312312312312");
    NSLog(@"mapViewDidFinishRendering");
    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
        _regionFirstDidChangeWithoutReload = NO;
    }
    else {
        [self searchPoisByCenterCoordinate:_mapView.centerCoordinate];
    }
    _regionDidChangeWithoutReload = NO;
}

#pragma mark - Button method
- (void)rightDoneClick {
    if (_poiInfos.count == 0) {
        self.view.window.userInteractionEnabled = NO;
        [UIAlertView showWithTitle:@"提示" message:@"请选择地址" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            self.view.window.userInteractionEnabled = YES;
        }];
        return;
    }
    
    BMKPoiInfo *poi;
    if (_searchKeywords) {
        poi = _poiInCityInfos[_selectIndex];
    }
    else {
        poi = _poiInfos[_selectIndex];
    }
    
    [self selectedSpot:poi];
}

#pragma mark - Keywords Searchs
/*
 根据关键字去搜索
 */
- (void)searchPoisByKeywords:(NSString *)keywords {
    _searchKeywords = YES;
    BMKSuggestionSearch *search = [[BMKSuggestionSearch alloc] init];
    search.delegate = self;
    
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    if (_city) {
        option.cityname = _city.name? _city.name: @"厦门";
    }
    else if ([ZZUserHelper shareInstance].cityName) {
        option.cityname = [ZZUserHelper shareInstance].cityName;
    }
    option.cityname = UserHelper.cityName;
    option.keyword  = keywords;
    option.cityLimit = NO;
    
    BOOL flag = [search suggestionSearch:option];
    if (flag) {
        NSLog(@"Sug检索发送成功");
    }
    else  {
        NSLog(@"Sug检索发送失败");
    }
}

#pragma mark BMKSuggestionSearch
/**
 *返回suggestion搜索结果
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:( BMKSuggestionSearchResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _keywordsInfos = result.suggestionList;
        _selectIndex = 0;
        [_mapView setCenterCoordinate:_keywordsInfos.firstObject.location animated:YES];
        [_listTableView reloadData];
    }
    else {
        NSLog(@"检索失败");
    }
}

#pragma mark - Keywords City Searchs
/*
 根据在某个城市的关键字去搜索
 */
- (void)searchPoisInCityByKeywords:(NSString *)keywords {
    _searchKeywords = YES;
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    poiSearch.delegate = self;
    
    BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc] init];
    option.keyword = keywords;
    if (_city) {
        option.city = _city.name? _city.name: @"厦门";
    }
    else if ([ZZUserHelper shareInstance].cityName) {
        option.city = [ZZUserHelper shareInstance].cityName;
    }
//    option.tags = @[@"美食"];
//    option.isCityLimit = YES;
    option.pageIndex = 0;
    option.pageSize = 20;
    
    // 过滤
    option.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
    BMKPOISearchFilter *filter = [[BMKPOISearchFilter alloc] init];
    filter.industryType = BMK_POI_INDUSTRY_TYPE_CATER;
    filter.sortBasis = BMK_POI_SORT_BASIS_TYPE_CATER_DISTANCE;
    filter.sortRule = BMK_POI_SORT_RULE_ASCENDING;
    option.filter = filter;
    
    BOOL flag = [poiSearch poiSearchInCity:option];
    if(flag) {
        NSLog(@"POI城市内检索成功");
    }
    else {
        NSLog(@"POI城市内检索失败");
    }
}

#pragma mark - Coordinate Searchs
/*
 根据经纬度去搜索
 */
- (void)searchPoisByCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    if (_isSearchingPois) {
        return;
    }
    _isSearchingPois = YES;
    _searchKeywords = NO;
    BMKPOINearbySearchOption *nearbyOptions = [[BMKPOINearbySearchOption alloc] init];
    // 坐标
    nearbyOptions.location = coordinate;
    nearbyOptions.keywords = @[@"美食", @"购物", @"休闲娱乐", @"运动健身"];
    
    // 检索分类
//    nearbyOptions.tags = @[@"美食", @"购物", @"生活服务", @"丽人", @"休闲娱乐", @"运动健身", @"教育培训", @"文化传媒", @"医疗", @"汽车服务", @"交通设施", @"金融", @"房地产", @"公司企业", @"政府机构", @"出入口", @"自然地物"];
    
    // 半径
    nearbyOptions.radius = 500;
    
    // 最大值
    nearbyOptions.pageIndex = 0;
    nearbyOptions.pageSize = 20;
    
    //是否严格限定召回结果在设置检索半径范围内
    nearbyOptions.isRadiusLimit = YES;
    
    // 过滤
//    nearbyOptions.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
//    BMKPOISearchFilter *filter = [[BMKPOISearchFilter alloc] init];
//    filter.industryType = BMK_POI_INDUSTRY_TYPE_CATER;
//    filter.sortBasis = BMK_POI_SORT_BASIS_TYPE_CATER_DISTANCE;
//    filter.sortRule = BMK_POI_SORT_RULE_ASCENDING;
//    nearbyOptions.filter = filter;

    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    poiSearch.delegate = self;
    
    BOOL flag = [poiSearch poiSearchNearBy:nearbyOptions];
    if (flag) {
        NSLog(@"POI周边检索成功");
    }
    else {
        NSLog(@"POI周边检索失败");
        _isSearchingPois = NO;
    }
}

#pragma mark BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    _isSearchingPois = NO;
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        if (_searchKeywords) {
            _regionDidChangeWithoutReload = YES;
            _poiInCityInfos = poiResult.poiInfoList;
            _selectIndex = 0;
            [self.searchController.searchResultsTableView reloadData];
            [_mapView setCenterCoordinate:_poiInCityInfos.firstObject.pt animated:YES];
            if (_searchedReloadListTableViewView) {
                [_listTableView reloadData];
                _searchedReloadListTableViewView = NO;
            }
        }
        else {
            _poiInfos = poiResult.poiInfoList;
            _selectIndex = 0;
            [self sortItOut];
            [_listTableView reloadData];
            
            // 让地图坐标移动到中心
            [_mapView setCenterCoordinate:_poiInfos.firstObject.pt animated:YES];
            _regionDidChangeWithoutReload = YES;
        }
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    }
    else {
        NSLog(@"其他检索结果错误码相关处理");
    }
}

- (void)sortItOut {
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    NSMutableArray<BMKPoiInfo *> *array = _poiInfos.mutableCopy;
    NSInteger gap = array.count / 2;
    while (gap > 0) {
        for (NSInteger x = gap; x < array.count; x++) {
            NSInteger y = x - gap;
            while (y >= 0) {
                CLLocation *location1 = [[CLLocation alloc] initWithLatitude:array[y].pt.latitude longitude:array[y].pt.longitude];
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:array[y + gap].pt.latitude longitude:array[y + gap].pt.longitude];
                double distance1 = [myLocation distanceFromLocation:location1];
                double distance2 = [myLocation distanceFromLocation:location2];
                if (distance1 > distance2) {
                    BMKPoiInfo *temp = array[y];
                    array[y] = array[y + gap];
                    array[y + gap] = temp;
                }
                y -= gap;
            }
        }
         gap = gap / 2;
    }
    _poiInfos = array.copy;
}

#pragma mark - BMKMapViewDelegate
//- (void)mapViewDidFinishRendering:(BMKMapView *)mapView {
//    NSLog(@"mapViewDidFinishRendering");
//    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
//        _regionFirstDidChangeWithoutReload = NO;
//    }
//    else {
//        [self searchPoisByCenterCoordinate:mapView.centerCoordinate];
//    }
//    _regionDidChangeWithoutReload = NO;
//}

//- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
//    NSLog(@"mapview onDrawMapFrame");
//}

/*
 地图区域改变完成后会调用此接口
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"region will changed");
//    [_mapView setZoomLevel:18];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"region did changed");
//    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
//        _regionFirstDidChangeWithoutReload = NO;
//    }
//    else {
//        [self searchPoisByCenterCoordinate:mapView.centerCoordinate];
//    }
//    _regionDidChangeWithoutReload = NO;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self searchPoisByKeywords:searchBar.text];
    _regionDidChangeWithoutReload = YES;
    _searchedReloadListTableViewView = YES;
    
    [self searchPoisInCityByKeywords:searchBar.text];
    self.searchBar.placeholder = searchBar.text;
    [self.searchController setActive:NO animated:NO];
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self searchPoisInCityByKeywords:searchString];
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return _poiInCityInfos.count;
    }
    else if (tableView.tag == 2) {
        if (_searchKeywords) {
            return _poiInCityInfos.count;
        }
        else {
            return _poiInfos.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        static NSString *tipCellIdentifier = @"tipCellIdentifier";
        ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];

        if (cell == nil) {
            cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tipCellIdentifier];
        }

        BMKPoiInfo *item = _poiInCityInfos[indexPath.row];
        cell.titleLabel.text = item.name;
        cell.contentLabel.text = item.address;
        return cell;
    }
    else if (tableView.tag == 2) {
        static NSString *identifier = @"poiCellIdentifier";
        ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        if (!cell) {
            cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        BMKPoiInfo *item = nil;
        if (_searchKeywords) {
            item = _poiInCityInfos[indexPath.row];
        }
        else {
            item = _poiInfos[indexPath.row];
        }
        
        cell.titleLabel.text = item.name;
        cell.contentLabel.text = item.address;

        if (indexPath.row == _selectIndex) {
            cell.selectImgView.image = [UIImage imageNamed:@"btn_report_p"];
        }
        else {
            cell.selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        BMKPoiInfo *info = _poiInCityInfos[indexPath.row];
        [self.mapView setCenterCoordinate:info.pt animated:YES];
        [self selectedSpot:info];
    }
    else if (tableView.tag == 2) {
        if (_searchKeywords) {
            BMKPoiInfo *info = _poiInCityInfos[indexPath.row];
            [self.mapView setCenterCoordinate:info.pt animated:YES];
        }
        else {
            BMKPoiInfo *item = _poiInfos[indexPath.row];
            [self.mapView setCenterCoordinate:item.pt animated:YES];
        }
        _selectIndex = indexPath.row;
        [_listTableView reloadData];
    }
    _regionDidChangeWithoutReload = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Layout
- (void)layoutNavigations {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 20);
    [rightBtn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightDoneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *leftBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, leftBarButon];
}

- (void)layout {
    [self.view addSubview:self.searchBar];
//    _searchBar.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44.0);
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.pinImageView];
    [self.view addSubview:self.listTableView];
    
    _mapView.frame = CGRectMake(0.0, _searchBar.bottom, SCREEN_WIDTH, 250);
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@44.0);
    }];
    
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(_mapView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [_pinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_mapView.mas_centerX);
        make.centerY.mas_equalTo(_mapView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 38));
    }];
    
    _alertView = [[ZZRentLocationAlertView1 alloc] initWithFrame:CGRectMake(0.0, _searchBar.bottom + 12, SCREEN_WIDTH, 30.0)];
    [self.view addSubview:self.alertView];
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30.0);
    }];
    
    [self initSearchController];
    
    [self.view bringSubviewToFront:_searchBar];
}

- (void)initSearchController {
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchController.delegate                = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate   = self;
    _searchController.searchContentsController.edgesForExtendedLayout = UIRectEdgeNone;
    _searchController.searchResultsTableView.tag = 1;
}

#pragma mark - getters and setters
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索地点";
        _searchBar.delegate = self;
        
    }
    return _searchBar;
}

- (UIImageView *)pinImageView {
    if (!_pinImageView) {
        _pinImageView = [[UIImageView alloc] init];
        _pinImageView.image = [UIImage imageNamed:@"pin"];
        _pinImageView.contentMode = UIViewContentModeCenter;
        _pinImageView.userInteractionEnabled = NO;
    }
    return _pinImageView;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
        _mapView.showMapScaleBar = NO;
    }
    return _mapView;
}

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [UIView new];
        _listTableView.tag = 2;
        [self.view addSubview:_listTableView];
    }
    return _listTableView;
}

@end

@interface ZZRentLocationAlertView1 ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZRentLocationAlertView1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.4;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"选择城市中心或人流量密集的地点，对方会更积极赴约哦";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
