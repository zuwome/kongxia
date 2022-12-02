//
//  ZZRentAbroadLocationViewController.m
//  zuwome
//
//  Created by angBiu on 2017/2/9.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRentAbroadLocationViewController.h"

#import "ZZRentLocationCell.h"

#import "ZZAbroadLocationModel.h"

#import "ZZAFNHelper.h"
#import <MapKit/MapKit.h>

@interface ZZRentAbroadLocationViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate, ZZRentAbroadLocationSearchViewControllerDelegate>
{
    BOOL _regionDidChangeWithoutReload;
    BOOL _regionFirstDidChangeWithoutReload;
    BOOL _searchKeywords;
    UIImageView *_pinImageView;
    
    NSString *_keywords;
    NSInteger _selectIndex;
}

@property (strong, nonatomic) MKMapView *mapView;

@property (nonatomic, strong) ZZRentAbroadLocationSearchViewController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *regionArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation ZZRentAbroadLocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_mapView bringSubviewToFront:_pinImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"选择通告地点";
    self.definesPresentationContext = YES;
    [self createRightDoneBtn];
    
    [self createViews];
    [self initSearchDisplay];
    [self located];
}

- (void)createRightDoneBtn
{
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

- (void)located {
    CLLocation *location = [ZZUserHelper shareInstance].location;
    
    if (_currentSelectCity) {
        NSArray *coordinatesArr = [_currentSelectCity.center componentsSeparatedByString:@","];
        if (coordinatesArr.count == 2) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([coordinatesArr.lastObject doubleValue], [coordinatesArr.firstObject doubleValue]);
            MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
            MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
            [_mapView setRegion:region animated:NO];
            [_mapView setCenterCoordinate:coordinate animated:YES];
            [self hotSeatch:coordinate];
        }
        else {
            MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
            MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
            [_mapView setRegion:region animated:NO];
            [_mapView setCenterCoordinate:location.coordinate animated:YES];
            [self hotSeatch:location.coordinate];
        }
        
    }
    else if (location) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
        [_mapView setRegion:region animated:NO];
        [_mapView setCenterCoordinate:location.coordinate animated:YES];
        [self hotSeatch:location.coordinate];
    }
    else {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        if (!location) {
            NSArray *point = [_currentSelectCity.center componentsSeparatedByString:@","];
            coordinate = (CLLocationCoordinate2D){[point[1] floatValue], [point[0] floatValue]};
        }
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        [self.mapView setRegion:region animated:NO];
        [self.mapView setCenterCoordinate:coordinate];
    }
}

- (void)createViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 180)];
    _mapView.delegate = self;
    _mapView.zoomEnabled = YES;
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(@360);
    }];
    
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
}

- (void)initSearchDisplay
{
    
    _searchResultTableVC = [[ZZRentAbroadLocationSearchViewController alloc] init];
    _searchResultTableVC.delegate = self;
    _searchResultTableVC.coordinates = self.mapView.centerCoordinate;
    _searchResultTableVC.currentCity = _currentSelectCity;
    _searchResultTableVC.isFromTaskFree = _isFromTaskFree;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;

    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0) {
        return;
    }
    [self keywordSearch:key];
    
    _searchKeywords = YES;
}

#pragma mark - ZZRentAbroadLocationSearchViewControllerDelegate
- (void)setSelectedLocation:(ZZRentDropdownModel *)place {
    if (_selectPoiDone) {
        _selectPoiDone(place);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchDisplayDelegate

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self searchTipsWithKey:searchString];
//
//    return YES;
//}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _keywords = searchBar.text;
    NSString *key = searchBar.text;

    [self keywordSearch:key];
    _regionDidChangeWithoutReload = YES;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
        _regionFirstDidChangeWithoutReload = NO;
    } else {
        [self hotSeatch:mapView.centerCoordinate];
        NSLog(@"did change and reload");
    }
    _regionDidChangeWithoutReload = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return _searchArray.count;
    }
    if (tableView.tag == 2) {
        return _regionArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *tipCellIdentifier = @"tipCellIdentifier";
        ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
        
        if (cell == nil) {
            cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tipCellIdentifier];
        }
        
        CLPlacemark *placemark = _searchArray[indexPath.row];
        cell.titleLabel.text = placemark.name;
        cell.contentLabel.text = placemark.thoroughfare;
        return cell;
    } else {
        static NSString *identifier = @"poiCellIdentifier";
        ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        CLPlacemark *placemark = _regionArray[indexPath.row];
        cell.titleLabel.text = placemark.name;
        cell.contentLabel.text = placemark.thoroughfare;
        
        if (indexPath.row == _selectIndex) {
            cell.selectImgView.image = [UIImage imageNamed:@"btn_report_p"];
        } else {
            cell.selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        CLPlacemark *placemark = _searchArray[indexPath.row];
        ZZRentDropdownModel *downModel = [[ZZRentDropdownModel alloc] init];
        downModel.name = placemark.name;
        downModel.location = placemark.location;
        downModel.detaiString = placemark.thoroughfare;
        downModel.isAbroat = YES;
        if (_selectPoiDone) {
            _selectPoiDone(downModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (tableView.tag == 2) {
//        ZZAbroadLocationResultModel *model = _regionArray[indexPath.row];
//        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){model.geometry.location.lat, model.geometry.location.lng} animated:YES];
        
        CLPlacemark *placemark = _regionArray[indexPath.row];
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){placemark.location.coordinate.latitude, placemark.location.coordinate.longitude} animated:YES];

        _selectIndex = indexPath.row;
        [_listTableView reloadData];
    }
    _regionDidChangeWithoutReload = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - private

- (void)hotSeatch:(CLLocationCoordinate2D)coordinate
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    //设置搜索热点词（自然语言）
    request.naturalLanguageQuery = @"Restaurant";
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    request.region = region;
    
    //创建本地搜索对象
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    //开启搜索
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSArray *arrResult = response.mapItems;
            [self.regionArray removeAllObjects];
            for (MKMapItem *item in arrResult) {
                CLPlacemark *placemark = item.placemark;
                [self.regionArray addObject:placemark];
            }
            [self.listTableView reloadData];
        }else {
            NSLog(@"搜索失败");
        }
    }];
}

//关键字搜索
- (void)keywordSearch:(NSString *)keyword
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    //设置搜索热点词（自然语言）
    request.naturalLanguageQuery = keyword;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 5000, 5000);
    request.region = region;
    
    //创建本地搜索对象
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    //开启搜索
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSArray *arrResult = response.mapItems;
            [self.searchArray removeAllObjects];
            for (MKMapItem *item in arrResult) {
                CLPlacemark *placemark = item.placemark;
                [self.searchArray addObject:placemark];
            }
//            [self.searchDisplayController.searchResultsTableView reloadData];
        }else {
            NSLog(@"搜索失败");
        }
    }];
}

- (void)getNearby
{
    AFHTTPSessionManager *manager = [ZZAFNHelper shareInstance];
    CLLocationCoordinate2D coordinate = [ZZUserHelper shareInstance].location.coordinate;
    if (![ZZUserHelper shareInstance].location) {
        NSArray *point = [_currentSelectCity.center componentsSeparatedByString:@","];
        coordinate = (CLLocationCoordinate2D){[point[1] floatValue], [point[0] floatValue]};
    }
    CGFloat lng = coordinate.longitude;
    CGFloat lat = coordinate.latitude;
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f151.1957&radius=500&name=cruise&key=AIzaSyAai0xH88C_ESpzUAT7osjn51s8FIPzicM",lng,lat];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        ZZAbroadLocationModel *model = [[ZZAbroadLocationModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.status isEqualToString:@"OK"]) {
            [self.regionArray removeAllObjects];
            [self.regionArray addObjectsFromArray:model.results];
            [self.listTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

#pragma mark - UIButtonMethod

- (void)rightDoneClick
{
    if (_regionArray.count == 0) {
        [UIAlertView showWithTitle:@"提示" message:@"请选择地址" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        }];
        return;
    }
    
    CLPlacemark *placemark = _regionArray[_selectIndex];
    ZZRentDropdownModel *downModel = [[ZZRentDropdownModel alloc] init];
    downModel.city = placemark.locality;
    downModel.name = placemark.name;
    downModel.location = placemark.location;
    downModel.detaiString = placemark.thoroughfare;
    downModel.isAbroat = YES;
    if (_isFromTaskFree) {
        if (![downModel.city isEqualToString:_currentSelectCity.name]) {
            [ZZHUD showErrorWithStatus:@"该地点不在所选的城市中"];
            return;
        }
    }
    
    if (_selectPoiDone) {
        _selectPoiDone(downModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
//    ZZAbroadLocationResultModel *model = _regionArray[_selectIndex];
//    ZZRentDropdownModel *downModel = [[ZZRentDropdownModel alloc] init];
//    downModel.name = model.name;
//    downModel.location = [[CLLocation alloc] initWithLatitude:model.geometry.location.lat longitude:model.geometry.location.lng];
//    downModel.detaiString = model.vicinity;
//    downModel.isAbroat = YES;
//    if (_selectPoiDone) {
//        _selectPoiDone(downModel);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazyload

- (NSMutableArray *)regionArray
{
    if (!_regionArray) {
        _regionArray = [NSMutableArray array];
    }
    return _regionArray;
}

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface ZZRentAbroadLocationSearchViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation ZZRentAbroadLocationSearchViewController

//关键字搜索
- (void)keywordSearch:(NSString *)keyword
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    //设置搜索热点词（自然语言）
    request.naturalLanguageQuery = keyword;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.coordinates, 5000, 5000);
    request.region = region;
    
    //创建本地搜索对象
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    //开启搜索
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSArray *arrResult = response.mapItems;
            [self.searchArray removeAllObjects];
            for (MKMapItem *item in arrResult) {
                CLPlacemark *placemark = item.placemark;
                [self.searchArray addObject:placemark];
            }
            [self.tableView reloadData];
        }else {
            NSLog(@"搜索失败");
        }
    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self keywordSearch:searchController.searchBar.text];
//    [self searchTipsWithKey:searchController.searchBar.text];
//    _searchString = searchController.searchBar.text;
//    _searchString = searchController.searchBar.text;
//    searchPage = 1;
//    [self searchPoiBySearchString:_searchString];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil) {
        cell = [[ZZRentLocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tipCellIdentifier];
    }
    
    CLPlacemark *placemark = _searchArray[indexPath.row];
    cell.titleLabel.text = placemark.name;
    cell.contentLabel.text = placemark.thoroughfare;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLPlacemark *placemark = _searchArray[indexPath.row];
    ZZRentDropdownModel *downModel = [[ZZRentDropdownModel alloc] init];
    downModel.name = placemark.name;
    downModel.location = placemark.location;
    downModel.detaiString = placemark.thoroughfare;
    downModel.isAbroat = YES;
    downModel.city = placemark.locality;
    if (_isFromTaskFree) {
        if (![downModel.city isEqualToString:_currentCity.name]) {
            [ZZHUD showErrorWithStatus:@"该地点不在所选的城市中"];
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(setSelectedLocation:)]) {
        [self.delegate setSelectedLocation:downModel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchArray = [NSMutableArray array];
    // 解决tableview无法正常显示的问题
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.definesPresentationContext = YES;
}


@end
