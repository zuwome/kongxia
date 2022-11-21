//
//  ZZSearchLocationController.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSearchLocationController.h"

#import "ZZRentLocationCell.h"
#import "ZZLocationSearchedController.h"


@interface ZZSearchLocationController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, ZZLocationSearchedControllerDelegate,MapViewDelegate>
{
    BOOL _searchKeywords;
    
    NSString *_keywords;
    NSInteger _selectIndex;
}

@property (nonatomic, strong) MapView *mapView;

@property (nonatomic, strong) UIImageView *pinImageView;;

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) ZZLocationSearchedController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) ZZLocationAlertView *alertView;

@property (nonatomic, assign) bool regionDidChangeWithoutReload;

@property (nonatomic, assign) bool regionFirstDidChangeWithoutReload;

@property (nonatomic, copy) NSArray *pois;

@end

@implementation ZZSearchLocationController

- (instancetype)initWithSelectCity:(ZZCity *)city {
    self = [super init];
    if (self) {
        _isFromTaskFree = NO;
        _currentSelectCity = city;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    [self createRightDoneBtn];

    [self createViews];
    [self createTimer];
    [self initMapView];
    [self initSearch];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    CLLocation *location = [ZZUserHelper shareInstance].location;

    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 500);
    
    [_mapView setRegion:region animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
    });
}

- (void)createTimer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            _alertView.top -= _alertView.height;
        } completion:^(BOOL finished) {
            [_alertView removeFromSuperview];
            _alertView = nil;
        }];
    });
}

#pragma mark - response method
- (void)navigationLeftBtnClick {
    BLOCK_SAFE_CALLS(self.presentBlock);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightDoneClick {
    if (_pois.count == 0) {
        self.view.window.userInteractionEnabled = NO;
        [UIAlertView showWithTitle:@"提示" message:@"请选择地址" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            self.view.window.userInteractionEnabled = YES;
        }];
        return;
    }
    PoiModel *poi = _pois[_selectIndex];
    [self getSearchLocation:poi];
}

- (void)getSearchLocation:(PoiModel *)poi {
    
    ZZRentDropdownModel *model = [[ZZRentDropdownModel alloc] init];
    model.name = poi.name;
    model.location = [[CLLocation alloc] initWithLatitude:poi.latitude longitude:poi.longitude];
    model.detaiString = poi.address;
    model.city = _currentSelectCity.name;
    
    if (_isFromTaskFree) {
        if (_currentSelectCity && ![_currentSelectCity.name isEqualToString:model.city]) {
            [ZZHUD showErrorWithStatus:@"该地点不在所选的城市中"];
            return;
        }
    }
    
    if (_selectPoiDone) {
        _selectPoiDone(model);
    } else if (_selectPoi) {
        UIImage *image = [_mapView snapShot];
        _selectPoi(model, image);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initMapView {
    CLLocation *location = [ZZUserHelper shareInstance].location;

//    WEAK_SELF();
//    [_mapView setRegionDidChange:^(CLLocationCoordinate2D centerCoorDinate) {
//        if (weakSelf.regionDidChangeWithoutReload || weakSelf.regionFirstDidChangeWithoutReload) {
//            weakSelf.regionFirstDidChangeWithoutReload = NO;
//        }
//        else {
//            [weakSelf searchPoiByCenterCoordinate:centerCoorDinate];
//        }
//        weakSelf.regionDidChangeWithoutReload = NO;
//    }];
//    [_mapView setRegionDidChange:^(CLLocationCoordinate2D centerCoorDinate) {
//        if (weakSelf.regionDidChangeWithoutReload || weakSelf.regionFirstDidChangeWithoutReload) {
//            weakSelf.regionFirstDidChangeWithoutReload = NO;
//        }
//        else {
//            [weakSelf searchPoiByCenterCoordinate:centerCoorDinate];
//        }
//        weakSelf.regionDidChangeWithoutReload = NO;
//
//    }];
    _regionFirstDidChangeWithoutReload = YES;
    
    if (_currentSelectCity) {
        NSArray *coordinatesArr = [_currentSelectCity.center componentsSeparatedByString:@","];
        if (coordinatesArr.count == 2) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([coordinatesArr.lastObject doubleValue], [coordinatesArr.firstObject doubleValue]);
            [_mapView.mapView setCenterCoordinate:coordinate animated:YES];
            [self searchPoiByCenterCoordinate:coordinate];
        }
        else {
            [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
            [self searchPoiByCenterCoordinate:location.coordinate];
        }
        
    }
    else  if (location) {
        [_mapView.mapView setCenterCoordinate:location.coordinate animated:YES];
        [self searchPoiByCenterCoordinate:location.coordinate];
    }
    [_mapView bringSubviewToFront:_pinImageView];
}

#pragma mark - MapviewDelegate
- (void)regionDidChangedWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.regionDidChangeWithoutReload || self.regionFirstDidChangeWithoutReload) {
        self.regionFirstDidChangeWithoutReload = NO;
    }
    else {
        [self searchPoiByCenterCoordinate:coordinate];
    }
    self.regionDidChangeWithoutReload = NO;
}

#pragma mark - SearchResultTableVCDelegate
- (void)setSelectedLocationWithLocation:(PoiModel *)poi {
    [self getSearchLocation:poi];
}

#pragma mark - POI Search
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D transCoor = [LocationUtil transformGCJToWGSWithLocation:coordinate];
    
    [POIManager getPoisWithLocation:transCoor completion:^(NSArray<PoiModel *> * poiModels) {
        _pois = poiModels;
        [_listTableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"poiCellIdentifier";
    ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PoiModel *poi = _pois[indexPath.row];
    cell.titleLabel.text = poi.name;
    cell.contentLabel.text = poi.address;
    
    if (indexPath.row == _selectIndex) {
        cell.selectImgView.image = [UIImage imageNamed:@"btn_report_p"];
    } else {
        cell.selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
    }
    return cell;
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PoiModel *poi = _pois[indexPath.row];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
    CLLocationCoordinate2D transCoor = [LocationUtil transformWGSToGCJWithWgsLocation:coordinate];
    
    [_mapView.mapView setCenterCoordinate:transCoor animated:YES];
    _selectIndex = indexPath.row;
    [_listTableView reloadData];
    
    _regionDidChangeWithoutReload = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Layout
- (void)createRightDoneBtn {
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

- (void)createViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    _listTableView = [[UITableView alloc] init];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.tableFooterView = [UIView new];
    _listTableView.tag = 2;
    [self.view addSubview:_listTableView];
    
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(_mapView.mas_bottom);
//        make.top.mas_equalTo(_searchController.searchBar.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

    _alertView = [[ZZLocationAlertView alloc] initWithFrame:CGRectMake(0.0, _listTableView.top + 55.0, SCREEN_WIDTH, 30.0)];
    _alertView.titleLabel.text = _isFromTaskFree ? @"选择城市中心或人流量密集的地点，才会有更多人感兴趣哦" : @"选择城市中心或人流量密集的地点，对方会更积极赴约哦";
    [self.view addSubview:self.alertView];
}

- (void)initSearch {
    _searchResultTableVC = [[ZZLocationSearchedController alloc] init];
    _searchResultTableVC.delegate = self;
    _searchResultTableVC.location = [ZZUserHelper shareInstance].location;
    _searchResultTableVC.currentCity = _currentSelectCity;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;
    _searchController.searchBar.delegate = _searchResultTableVC;
    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - getters and setters
- (void)setIsFromTaskFree:(BOOL)isFromTaskFree {
    _isFromTaskFree = isFromTaskFree;
}

@end

@interface ZZLocationAlertView ()



@end

@implementation ZZLocationAlertView

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
