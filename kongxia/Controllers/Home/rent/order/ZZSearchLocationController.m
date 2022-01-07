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

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ZZSearchLocationController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, MAMapViewDelegate, ZZLocationSearchedControllerDelegate>
{
    AMapSearchAPI *_search;
    NSMutableArray<AMapPOI *> *_tips;
    NSArray<AMapPOI *> *_pois;
    BOOL _regionDidChangeWithoutReload;
    BOOL _regionFirstDidChangeWithoutReload;
    BOOL _searchKeywords;
    UIImageView *_pinImageView;
    
    NSString *_keywords;
    NSInteger _selectIndex;
}

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) ZZLocationSearchedController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) ZZLocationAlertView *alertView;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createRightDoneBtn];
    [self createViews];
    [self createTimer];
    [self initMapView];
    [self initSearch];
}

- (void)searchTipsWithKey:(NSString *)key {
    if (key.length == 0) {
        return;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = key;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    if (_currentSelectCity) {
        request.city = _currentSelectCity.name? _currentSelectCity.name: @"厦门";
    }
    else if ([ZZUserHelper shareInstance].cityName) {
        request.city = [ZZUserHelper shareInstance].cityName;
    }
    request.cityLimit = YES;
    
    _searchKeywords = YES;
    [_search AMapPOIKeywordsSearch:request];
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
    AMapPOI *poi = _pois[_selectIndex];
    [self getSearchLocation:poi];
}

- (void)getSearchLocation:(AMapPOI *)poi {
    BOOL contain = NO;
    if (_currentSelectCity) {
        NSRange range = [poi.city rangeOfString:_currentSelectCity.name];
        if (range.location != NSNotFound) {
            contain = YES;
        }
        range = [_currentSelectCity.name rangeOfString:poi.city];
        if (range.location != NSNotFound) {
            contain = YES;
        }
        if (!contain) {
            contain = [self isContainSpecialCity:@"香港" poi:poi];
        }
        if (!contain) {
            contain = [self isContainSpecialCity:@"澳门" poi:poi];
        }
    }
    else {
        contain = YES;
    }
    
    if (!contain) {
        [UIAlertView showWithTitle:@"提示" message:
         [NSString stringWithFormat:@"出租地点请选择在%@内 ^_^",_currentSelectCity.name] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
             CLLocation *location = [ZZUserHelper shareInstance].location;
             
             if (location) {
                 [_mapView setCenterCoordinate:location.coordinate animated:YES];
             } else {
                 NSArray *point = [_currentSelectCity.center componentsSeparatedByString:@","];
                 [_mapView setCenterCoordinate:(CLLocationCoordinate2D){[point[1] floatValue], [point[0] floatValue]} animated:YES];
             }
         }];
    }
    else {
//        [self.displayController setActive:NO];
        
        // 过滤酒店、旅馆、宾馆、住宅、别墅等(这些都是高德标注的type)
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
            NSLog(@"该场合的类型是:%@, typeCode:%@",poi.type, poi.typecode);
            return;
        }
        
        ZZRentDropdownModel *model = [[ZZRentDropdownModel alloc] init];
        model.name = poi.name;
        model.location = [[CLLocation alloc] initWithLatitude:poi.location.latitude longitude:poi.location.longitude];
        model.detaiString = poi.address;
        if (isNullString(poi.city)) {
            model.city = poi.province;
        }
        else {
            model.city = poi.city;
        }
        
        if (_isFromTaskFree) {
            if (_currentSelectCity && ![_currentSelectCity.name isEqualToString:model.city]) {
                [ZZHUD showErrorWithStatus:@"该地点不在所选的城市中"];
                return;
            }
        }
        
        if (_selectPoiDone) {
            _selectPoiDone(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isContainSpecialCity:(NSString *)city poi:(AMapPOI *)poi {
    BOOL contain = NO;
    NSRange range = [_currentSelectCity.name rangeOfString:city];
    if (range.location != NSNotFound) {
        range = [poi.city rangeOfString:city];
        if (range.location != NSNotFound) {
            contain = YES;
        }
    }
    return contain;
}

#pragma mark - SearchResultTableVCDelegate
- (void)setSelectedLocationWithLocation:(AMapPOI *)poi {
    [self getSearchLocation:poi];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _keywords = searchBar.text;
    NSString *key = searchBar.text;
    /* 按下键盘enter, 搜索poi */
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords = key;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    if (_currentSelectCity) {
        request.city = _currentSelectCity.name? _currentSelectCity.name: @"厦门";
    } else if ([ZZUserHelper shareInstance].cityName) {
        request.city = [ZZUserHelper shareInstance].cityName;
    }
    request.requireExtension = YES;
    
//    [self.displayController setActive:NO animated:NO];
    self.searchController.searchBar.placeholder = key;
    [_search AMapPOIKeywordsSearch:request];
    _regionDidChangeWithoutReload = YES;
}

#pragma mark - AMapSearchDelegate
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    [_tips setArray:response.tips];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    
    if (_searchKeywords) {
        [_tips setArray:response.pois];
        _searchKeywords = NO;
    }
    else {
        AMapPOI *a = response.pois[0];
        _pois = response.pois;
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){a.location.latitude, a.location.longitude} animated:YES];
        _regionDidChangeWithoutReload = YES;
        _selectIndex = 0;
        [_listTableView reloadData];
    }
}

- (void)screeningPois {
    NSMutableArray<AMapPOI *> *pois = [NSMutableArray new];
    [_pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.name containsString:@"酒店"] && ![obj.name containsString:@"宾馆"] && ![obj.name containsString:@"公寓"] && ![obj.name containsString:@"旅馆"]) {
            [pois addObject:obj];
        }
        else {
            NSLog(@"type is %@, tpye code is %@", obj.type, obj.typecode);
        }
    }];
    _pois = pois;
}

- (void)screeningTips {
    NSMutableArray<AMapPOI *> *tips = [NSMutableArray new];
    [_tips enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.name containsString:@"酒店"] && ![obj.name containsString:@"宾馆"] && ![obj.name containsString:@"公寓"] && ![obj.name containsString:@"旅馆"]) {
            [tips addObject:obj];
        }
        else {
            NSLog(@"type is %@, tpye code is %@", obj.type, obj.typecode);
        }
    }];
    _tips = tips;
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
        _regionFirstDidChangeWithoutReload = NO;
    }
    else {
        [self searchPoiByCenterCoordinate:mapView.centerCoordinate];
        NSLog(@"did change and reload");
    }
    _regionDidChangeWithoutReload = NO;
}

#pragma mark - POI Search
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule = 0;
    //    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.requireExtension = YES;
    
    [_search AMapPOIAroundSearch:request];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return _tips.count;
    }
    if (tableView.tag == 2) {
        return _pois.count;
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
        
        AMapPOI *poi = _tips[indexPath.row];
        
        cell.titleLabel.text = poi.name;
        cell.contentLabel.text = poi.address;
        return cell;
    }
    
    if (tableView.tag == 2) {
        static NSString *identifier = @"poiCellIdentifier";
        ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        AMapPOI *poi = _pois[indexPath.row];
        cell.titleLabel.text = poi.name;
        cell.contentLabel.text = poi.address;
        
        if (indexPath.row == _selectIndex) {
            cell.selectImgView.image = [UIImage imageNamed:@"btn_report_p"];
        } else {
            cell.selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
        }
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        AMapPOI *poi = _tips[indexPath.row];
        [self getSearchLocation:poi];
    }
    if (tableView.tag == 2) {
        AMapPOI *poi = _pois[indexPath.row];
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude} animated:YES];
        
        _selectIndex = indexPath.row;
        [_listTableView reloadData];
    }
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
    _tips = [NSMutableArray array];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360)];
    
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
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    _alertView = [[ZZLocationAlertView alloc] initWithFrame:CGRectMake(0.0, _mapView.top + 55.0, SCREEN_WIDTH, 30.0)];
    _alertView.titleLabel.text = _isFromTaskFree ? @"选择城市中心或人流量密集的地点，才会有更多人感兴趣哦" : @"选择城市中心或人流量密集的地点，对方会更积极赴约哦";
    [self.view addSubview:self.alertView];
}

- (void)initMapView {
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.zoomLevel = 16;
    _mapView.delegate = self;
    _regionFirstDidChangeWithoutReload = YES;
    
    CLLocation *location = [ZZUserHelper shareInstance].location;
    
    if (_currentSelectCity) {
        NSArray *coordinatesArr = [_currentSelectCity.center componentsSeparatedByString:@","];
        if (coordinatesArr.count == 2) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([coordinatesArr.lastObject doubleValue], [coordinatesArr.firstObject doubleValue]);
            [_mapView setCenterCoordinate:coordinate animated:YES];
            [self searchPoiByCenterCoordinate:coordinate];
        }
        else {
            [_mapView setCenterCoordinate:location.coordinate animated:YES];
            [self searchPoiByCenterCoordinate:location.coordinate];
        }
        
    }
    else  if (location) {
        [_mapView setCenterCoordinate:location.coordinate animated:YES];
        [self searchPoiByCenterCoordinate:location.coordinate];
    }
    [_mapView bringSubviewToFront:_pinImageView];
}

- (void)initSearch {
    _searchResultTableVC = [[ZZLocationSearchedController alloc] init];
    _searchResultTableVC.delegate = self;
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
