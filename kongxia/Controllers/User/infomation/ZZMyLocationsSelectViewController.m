//
//  ZZMyLocationsSelectViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyLocationsSelectViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

#import "ZZSearchLocationController.h"
#import "ZZLocationSearchedController.h"

#import "ZZRentLocationCell.h"

#import "ZZCity.h"

@interface ZZMyLocationsSelectViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, MAMapViewDelegate, ZZLocationSearchedControllerDelegate>

@property (nonatomic, strong) ZZLocationSearchedController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UIImageView *pinImageView;

@property (nonatomic, strong) ZZLocationAlertView *alertView;

@property (nonatomic, strong) AMapSearchAPI *searchManager;

@property (nonatomic, assign) NSInteger maxCounts;

@property (nonatomic, assign) BOOL regionFirstDidChangeWithoutReload;

@property (nonatomic, assign) BOOL regionDidChangeWithoutReload;

@property (nonatomic,   copy) NSArray<AMapPOI *> *poisArray;

@property (nonatomic,   copy) NSArray<AMapPOI *> *selectLocations;

@end

@implementation ZZMyLocationsSelectViewController

- (instancetype)initWithCurrentSelectLocations:(NSArray *)locations from:(LocationFrom)from {
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray<AMapPOI *> *locArr = @[].mutableCopy;
            [locations enumerateObjectsUsingBlock:^(ZZMyLocationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AMapPOI *poi = [[AMapPOI alloc] init];
                poi.name = obj.simple_address;
                poi.address = obj.address;
                poi.city = obj.city;
                poi.province = obj.province;
                poi.oriLocationUID = obj._id;
                AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
                point.longitude = obj.address_lng;
                point.latitude = obj.address_lat;
                poi.location = point;
                
                [locArr addObject:poi];
            }];
            _selectLocations = locArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        });
        
        _from = from;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    self.title = @"选择常去的地点";
    
    [self defaultConfig];
    [self layoutNavigations];
    [self layout];
    [self initSearch];
    [self start];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _searchManager = nil;
}


#pragma mark - private method
- (void)defaultConfig {
    _regionFirstDidChangeWithoutReload = YES;
    if (_from == FromMyLocations) {
        _maxCounts = 5;
    }
    else {
        _maxCounts = 1;
    }
}

- (void)initSearch {
    _searchResultTableVC = [[ZZLocationSearchedController alloc] init];
    _searchResultTableVC.delegate = self;
    _searchResultTableVC.isFromMylocations = _from == FromMyLocations;
//    _searchResultTableVC.currentCity = _currentSelectCity;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;
    _searchController.searchBar.delegate = _searchResultTableVC;
    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)start {
    CLLocation *location = [ZZUserHelper shareInstance].location;
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    [self searchPoiByCenterCoordinate:location.coordinate];
}

- (void)selectLocationAt:(AMapPOI *)poi {
    NSMutableArray<AMapPOI *> *selectedPoisArr = _selectLocations.mutableCopy;
    if (!selectedPoisArr) {
        selectedPoisArr = @[].mutableCopy;
    }
    
    __block BOOL didExit = NO;
    __block NSInteger deleteIndex = -1;
    [selectedPoisArr enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([poi.province isEqualToString: obj.province] && [poi.city isEqualToString: obj.city] && [poi.name isEqualToString: obj.name] && [poi.address isEqualToString: obj.address]) {
            didExit = YES;
            *stop = YES;
            deleteIndex = idx;
        }
    }];
    
    if (didExit) {
        [selectedPoisArr removeObjectAtIndex:deleteIndex];
        
        _selectLocations = selectedPoisArr.copy;
        [_tableView reloadData];
    }
    else {
        if (selectedPoisArr.count + 1 > _maxCounts) {
            [ZZHUD showTaskInfoWithStatus:@"最多只能选择5个"];
            return;
        }
        
        if ([poi.typecode isEqualToString: @"100100"]
            || [poi.typecode isEqualToString: @"100101"]
            || [poi.typecode isEqualToString: @"100102"]
            || [poi.typecode isEqualToString: @"100103"]
            || [poi.typecode isEqualToString: @"100104"]
            || [poi.typecode isEqualToString: @"100105"]
            || [poi.typecode isEqualToString: @"100200"]
            || [poi.typecode isEqualToString: @"100201"]
            || [poi.typecode isEqualToString: @"120300"]
            || [poi.typecode isEqualToString: @"120301"]
            || [poi.typecode isEqualToString: @"120302"]
            || [poi.typecode isEqualToString: @"120303"]
            || [poi.typecode isEqualToString: @"120304"]) {
            [ZZHUD showTastInfoErrorWithString:@"请选择公共场合"];
            return;
        }
        
        [selectedPoisArr addObject:poi];
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude} animated:YES];
    }
    _selectLocations = selectedPoisArr.copy;
    [_tableView reloadData];
}

#pragma mark - ZZLocationSearchedControllerDelegate
- (void)setSelectedLocationWithLocation:(AMapPOI *)poi {
//    [self selectLocationAt:poi];
    [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude} animated:YES];
}

#pragma mark - response method
- (void)rightDoneClick {
    NSMutableArray<ZZMyLocationModel *> *array = @[].mutableCopy;
    
    [_selectLocations enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZMyLocationModel *location = [[ZZMyLocationModel alloc] init];
        location.province = poi.province;
        location.city = poi.city;
        location.simple_address = poi.name;
        location.address = poi.address;
        location.address_lng = poi.location.longitude;
        location.address_lat = poi.location.latitude;
        
        if (!isNullString(poi.oriLocationUID)) {
            location._id = poi.oriLocationUID;
        }
        [array addObject:location];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didSelectLocations:)]) {
        [self.delegate viewController:self didSelectLocations:array.copy];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - POI Search
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    /* 按照距离排序. */
    request.sortrule = 0;

    request.requireExtension = YES;
    
    if (_from == FromMyLocations) {
        request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|风景名胜|科教文化服务";
        request.radius = 5000;
    }
    
    [self.searchManager AMapPOIAroundSearch:request];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    AMapPOI *poi = response.pois[0];
    _poisArray = response.pois;
    [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude} animated:YES];
    _regionDidChangeWithoutReload = YES;
    [_tableView reloadData];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
        _regionFirstDidChangeWithoutReload = NO;
    }
    else {
        [self searchPoiByCenterCoordinate:mapView.centerCoordinate];
    }
    _regionDidChangeWithoutReload = NO;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _poisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentLocationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AMapPOI *poi = _poisArray[indexPath.row];
    cell.titleLabel.text = poi.name;
    cell.contentLabel.text = poi.address;
    cell.selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_selectLocations enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([poi.province isEqualToString: obj.province] && [poi.city isEqualToString: obj.city] && [poi.name isEqualToString: obj.name] && [poi.address isEqualToString: obj.address]) {
                *stop = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                   cell.selectImgView.image = [UIImage imageNamed:@"btn_report_p"];
                });
            }
        }];
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _poisArray.count) {
        [self selectLocationAt:_poisArray[indexPath.row]];
    }
    _regionDidChangeWithoutReload = YES;
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
    [self.view addSubview:self.mapView];
    [self.mapView addSubview:self.pinImageView];
    [self.view addSubview:self.tableView];
    
    [_pinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_mapView.mas_centerX);
        make.centerY.mas_equalTo(_mapView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 38));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(_mapView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - getters and setters
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360)];
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.zoomLevel = 16;
        _mapView.delegate = self;
        CLLocation *location = [ZZUserHelper shareInstance].location;
        if (location) {
            [_mapView setShowsUserLocation:YES];
        }
        [_mapView bringSubviewToFront:_pinImageView];
    }
    return _mapView;
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50.0;
        
        [_tableView registerClass:[ZZRentLocationCell class] forCellReuseIdentifier:@"ZZRentLocationCell"];
    }
    return _tableView;
}

- (AMapSearchAPI *)searchManager {
    if (!_searchManager) {
        _searchManager = [[AMapSearchAPI alloc] init];
        _searchManager.delegate = self;
    }
    return _searchManager;
}

- (ZZLocationAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZZLocationAlertView alloc] initWithFrame:CGRectMake(0.0, _mapView.top + 55.0, SCREEN_WIDTH, 30.0)];
    }
    return _alertView;
}

@end
