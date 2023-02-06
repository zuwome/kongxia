//
//  ZZMultipleSelectMapViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMultipleSelectMapViewController.h"

#import "ZZSearchLocationController.h"
#import "ZZLocationSearchedController.h"

#import "ZZRentLocationCell.h"

#import "ZZCity.h"

@interface ZZMultipleSelectMapViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ZZLocationSearchedControllerDelegate,MapViewDelegate>

@property (nonatomic, strong) MapView *mapView;

@property (nonatomic, strong) UIImageView *pinImageView;

@property (nonatomic, strong) ZZLocationSearchedController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZZLocationAlertView *alertView;

@property (nonatomic, assign) NSInteger maxCounts;

@property (nonatomic, assign) BOOL regionFirstDidChangeWithoutReload;

@property (nonatomic, assign) BOOL regionDidChangeWithoutReload;

@property (nonatomic, assign) BOOL isKeywordSearch;

@property (nonatomic,   copy) NSArray<PoiModel *> *poisArray;

@property (nonatomic,   copy) NSArray<PoiModel *> *selectLocations;


@end

@implementation ZZMultipleSelectMapViewController

- (instancetype)initWithCurrentSelectLocations:(NSArray *)locations {
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray<PoiModel *> *locArr = @[].mutableCopy;
            [locations enumerateObjectsUsingBlock:^(ZZMyLocationModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                PoiModel *poi = [[PoiModel alloc] init];
                poi.name = obj.simple_address;
                poi.address = obj.address;
                
                NSString *longla = [NSString stringWithFormat:@"%f,%f",obj.address_lng, obj.address_lat];
                poi.lonlat = longla;
                
                [locArr addObject:poi];
            }];
            _selectLocations = locArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultConfig];
    [self layoutNavigations];
    [self layout];
    [self initMapView];
    [self initSearch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CLLocation *location = [ZZUserHelper shareInstance].location;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 500);
    
    [_mapView setRegion:region animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - private method
- (void)defaultConfig {
    _regionFirstDidChangeWithoutReload = YES;
    _maxCounts = 5;
}

- (void)selectLocationAt:(PoiModel *)poi {

    NSMutableArray<PoiModel *> *selectedPoisArr = _selectLocations.mutableCopy;
    if (!selectedPoisArr) {
        selectedPoisArr = @[].mutableCopy;
    }

    __block BOOL didExit = NO;
    __block NSInteger deleteIndex = -1;
    [selectedPoisArr enumerateObjectsUsingBlock:^(PoiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([poi.name isEqualToString: obj.name] && [poi.address isEqualToString: obj.address]) {
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

        [selectedPoisArr addObject:poi];
//        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude} animated:YES];
    }
    _selectLocations = selectedPoisArr.copy;
    [_tableView reloadData];
}

- (void)searchTipsWithKey:(NSString *)key searchLimited:(BOOL)searchLimited {
//    [POIManager getPoisWithKeyword:key location:[ZZUserHelper shareInstance].location.coordinate completion:^(NSArray<PoiModel *> * pois) {
//        [self filterResults:pois];
//    }];
}

- (void)filterResults:(NSArray<PoiModel *> *)pois {
    NSArray<NSString *> *limitTypes = @[@"120104", @"120103", @"120200", @"120201", @"130807"];
    
    NSMutableArray *filterdPois = [[NSMutableArray alloc] init];
    
    [pois enumerateObjectsUsingBlock:^(PoiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![limitTypes containsObject:obj.poiType]) {
            [filterdPois addObject:obj];
        }
    }];
    
    _poisArray = filterdPois;
    [self.tableView reloadData];
}

#pragma mark - response method
- (void)rightDoneClick {
    NSMutableArray<ZZMyLocationModel *> *array = @[].mutableCopy;
    
    [_selectLocations enumerateObjectsUsingBlock:^(PoiModel * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZMyLocationModel *location = [[ZZMyLocationModel alloc] init];
        location.simple_address = poi.name;
        location.address = poi.address;
        location.address_lng = poi.longitude;
        location.address_lat = poi.latitude;

        [array addObject:location];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didSelectLocations:)]) {
        [self.delegate controller:self didSelectLocations:array.copy];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SearchResultTableVCDelegate
- (void)setSelectedLocationWithLocation:(PoiModel *)poi {
    [self selectLocationAt:poi];
}

#pragma mark - POI Search
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    [[POIManager shared] getGDPoiWithCoordinate:coordinate completion:^(NSArray<PoiModel *> * _Nonnull pois) {
        _poisArray = pois;
        [_tableView reloadData];
    }];
//
//    [POIManager getPoisWithLocation:coordinate completion:^(NSArray<PoiModel *> * poiModels) {
//        _poisArray = poiModels;
//        [_tableView reloadData];
//    }];
}

#pragma mark - UITextFieldMethod
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    _isKeywordSearch = YES;
    [self searchTipsWithKey:textField.text searchLimited:NO];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _poisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentLocationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PoiModel *poi = _poisArray[indexPath.row];
    cell.titleLabel.text = poi.name;
    cell.contentLabel.text = poi.address;
    cell.selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_selectLocations enumerateObjectsUsingBlock:^(PoiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([poi.name isEqualToString: obj.name] && [poi.address isEqualToString: obj.address]) {
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

- (void)regionDidChangedWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.regionDidChangeWithoutReload || self.regionFirstDidChangeWithoutReload) {
        self.regionFirstDidChangeWithoutReload = NO;
    }
    else {
        [self searchPoiByCenterCoordinate:coordinate];
    }
    self.regionDidChangeWithoutReload = NO;
}

- (void)initMapView {
    CLLocation *location = [ZZUserHelper shareInstance].location;

    WEAK_SELF();
    [_mapView setRegionDidChange:^(CLLocationCoordinate2D centerCoorDinate) {
        if (weakSelf.regionDidChangeWithoutReload || weakSelf.regionFirstDidChangeWithoutReload) {
            weakSelf.regionFirstDidChangeWithoutReload = NO;
        }
        else {
            [weakSelf searchPoiByCenterCoordinate:centerCoorDinate];
        }
        weakSelf.regionDidChangeWithoutReload = NO;
    }];
    [_mapView setRegionDidChange:^(CLLocationCoordinate2D centerCoorDinate) {
        if (weakSelf.regionDidChangeWithoutReload || weakSelf.regionFirstDidChangeWithoutReload) {
            weakSelf.regionFirstDidChangeWithoutReload = NO;
        }
        else {
            [weakSelf searchPoiByCenterCoordinate:centerCoorDinate];
        }
        weakSelf.regionDidChangeWithoutReload = NO;

    }];
    _regionFirstDidChangeWithoutReload = YES;
    
    [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
    [self searchPoiByCenterCoordinate:location.coordinate];
    
//    if (_currentSelectCity) {
//        NSArray *coordinatesArr = [_currentSelectCity.center componentsSeparatedByString:@","];
//        if (coordinatesArr.count == 2) {
//            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([coordinatesArr.lastObject doubleValue], [coordinatesArr.firstObject doubleValue]);
//            [_mapView.mapView setCenterCoordinate:coordinate animated:YES];
//            [self searchPoiByCenterCoordinate:coordinate];
//        }
//        else {
//            [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
//            [self searchPoiByCenterCoordinate:location.coordinate];
//        }
//
//    }
//    else  if (location) {
//        [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
//        [self searchPoiByCenterCoordinate:location.coordinate];
//    }
    [_mapView bringSubviewToFront:_pinImageView];
}

- (void)initSearch {
    _searchResultTableVC = [[ZZLocationSearchedController alloc] init];
    _searchResultTableVC.delegate = self;
    _searchResultTableVC.location = [ZZUserHelper shareInstance].location;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;
    _searchController.searchBar.delegate = _searchResultTableVC;
    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    self.title = @"请选择地点";
    _mapView = [[MapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];

    _pinImageView = [[UIImageView alloc] init];
    _pinImageView.image = [UIImage imageNamed:@"pin"];
    _pinImageView.contentMode = UIViewContentModeCenter;
    _pinImageView.userInteractionEnabled = NO;
    [_mapView addSubview:_pinImageView];

    [_pinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_mapView.mas_centerX);
        make.centerY.mas_equalTo(_mapView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 38));
    }];

    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(_mapView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - getters and setters
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
@end
