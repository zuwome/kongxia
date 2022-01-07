
//
//  ZZChatLoacationViewController.m
//  zuwome
//
//  Created by angBiu on 2016/11/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatLocationViewController.h"

#import "ZZRentLocationCell.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ZZChatLocationViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, MAMapViewDelegate, ZZChatLocationSearchedControllerDelegate>
{
    AMapSearchAPI *_search;
    NSMutableArray *_tips;
    NSArray *_pois;
    BOOL _regionDidChangeWithoutReload;
    BOOL _regionFirstDidChangeWithoutReload;
    BOOL _searchKeywords;
    UIImageView *_pinImageView;
    
    NSString *_keywords;
    NSInteger _selectIndex;
}

@property (strong, nonatomic) MAMapView *mapView;

@property (nonatomic, strong) ZZChatLocationSearchedController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) UITableView *listTableView;
@property (nonatomic, assign) BOOL isUpdate;

@end

@implementation ZZChatLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.definesPresentationContext = YES;
    self.navigationItem.title = @"选取位置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createRightDoneBtn];
    
    [self createViews];
    [self initSearchDisplay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initMapView];
    });
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

- (void)createViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    _tips = [NSMutableArray array];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 180)];
    //    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(@320);
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
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

- (void)initMapView
{
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.zoomLevel = 14.5;
    _mapView.delegate = self;
    _regionFirstDidChangeWithoutReload = YES;
    
    CLLocation *location = [ZZUserHelper shareInstance].location;
    
    if (location) {
        [_mapView setShowsUserLocation:YES];
    }
    
    [_mapView bringSubviewToFront:_pinImageView];
}

- (void)initSearchDisplay
{
    
    _searchResultTableVC = [[ZZChatLocationSearchedController alloc] init];
    _searchResultTableVC.delegate = self;
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
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = key;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.city = [ZZUserHelper shareInstance].cityName;
    request.cityLimit = YES;
    
    _searchKeywords = YES;
    [_search AMapPOIKeywordsSearch:request];
}

#pragma mark - ZZChatLocationSearchedController
- (void)setSelectedLocationWithLocation:(AMapPOI *)poi {
    [self getSearchLocation:poi];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _keywords = searchBar.text;
    NSString *key = searchBar.text;
    /* 按下键盘enter, 搜索poi */
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords = key;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.city = [ZZUserHelper shareInstance].cityName;
    request.requireExtension = YES;
    [_search AMapPOIKeywordsSearch:request];
    _regionDidChangeWithoutReload = YES;
}

#pragma mark - AMapSearchDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!_isUpdate) {
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        [self searchPoiByCenterCoordinate:userLocation.location.coordinate];
        [_mapView setShowsUserLocation:NO];
        _isUpdate = YES;
    }
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [_tips setArray:response.tips];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    
    if (_searchKeywords) {
        [_tips setArray:response.pois];
        _searchKeywords = NO;
    } else {
        AMapPOI *a = response.pois[0];
        _pois = response.pois;
        //NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){a.location.latitude, a.location.longitude} animated:YES];
        _regionDidChangeWithoutReload = YES;
        _selectIndex = 0;
        [_listTableView reloadData];
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (_regionDidChangeWithoutReload || _regionFirstDidChangeWithoutReload) {
        _regionFirstDidChangeWithoutReload = NO;
    } else {
        [self searchPoiByCenterCoordinate:mapView.centerCoordinate];
        NSLog(@"did change and reload");
    }
    _regionDidChangeWithoutReload = NO;
}


#pragma mark - POI Search

- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule = 0;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.requireExtension = YES;
    
    [_search AMapPOIAroundSearch:request];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return _tips.count;
    }
    if (tableView.tag == 2) {
        return _pois.count;
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
        
        AMapPOI *poi = _tips[indexPath.row];
        
        cell.titleLabel.text = poi.name;
        cell.contentLabel.text = poi.address;
        return cell;
    }else {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        AMapPOI *poi = _tips[indexPath.row];
        [self searchPoiByCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude}];
        
        [_listTableView reloadData];
    }
    if (tableView.tag == 2) {
        AMapPOI *poi = _pois[indexPath.row];
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){poi.location.latitude, poi.location.longitude} animated:YES];
        
        _selectIndex = indexPath.row;
        [_listTableView reloadData];
    }
    _regionDidChangeWithoutReload = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UIButtonMethod

- (void)rightDoneClick
{
    if (_pois.count == 0) {
        [UIAlertView showWithTitle:@"提示" message:@"请选择地址" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        }];
        return;
    }
    AMapPOI *poi = _pois[_selectIndex];
    [self getSearchLocation:poi];
}

- (void)getSearchLocation:(AMapPOI *)poi
{
    UIImage *image = [_mapView takeSnapshotInRect:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    UIImage *resultImage = [ZZUtils addImage:image toImage:_pinImageView.image size:_pinImageView.size];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:poi.location.latitude longitude:poi.location.longitude];
    if (_locationCallBack) {
        _locationCallBack(resultImage,location,poi.name);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

@interface ZZChatLocationSearchedController () <UISearchResultsUpdating, AMapSearchDelegate>

@end

@implementation ZZChatLocationSearchedController
{
    NSString *_city;
    // 搜索key
    NSString *_searchString;
    // 搜索页数
    NSInteger searchPage;
    // 搜索API
    AMapSearchAPI *_searchAPI;
    // 搜索结果数组
    NSMutableArray *_searchResultArray;
    // 下拉更多请求数据的标记
    BOOL isFromMoreLoadRequest;
}

- (void)searchTipsWithKey:(NSString *)key {
    if (key.length == 0) {
        return;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = key;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";

    request.city = [ZZUserHelper shareInstance].cityName;
    request.cityLimit = YES;
    
//    _searchKeywords = YES;
    [_searchAPI AMapPOIKeywordsSearch:request];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchTipsWithKey:searchController.searchBar.text];
    _searchString = searchController.searchBar.text;
//    _searchString = searchController.searchBar.text;
//    searchPage = 1;
//    [self searchPoiBySearchString:_searchString];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    // 判断是否从更多拉取
    if (isFromMoreLoadRequest) {
        isFromMoreLoadRequest = NO;
    }
    else{
        [_searchResultArray removeAllObjects];
        // 刷新后TableView返回顶部
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    // 刷新完成,没有数据时不显示footer
    if (response.pois.count == 0) {
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    else {
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        // 添加数据并刷新TableView
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            [_searchResultArray addObject:obj];
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuseIdentifier = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    AMapPOI *poi = [_searchResultArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:poi.name];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    //高亮
    NSRange textHighlightRange = [poi.name rangeOfString:_searchString];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:textHighlightRange];
    cell.textLabel.attributedText = text;
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:poi.address];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, detailText.length)];
    [detailText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, detailText.length)];
    //高亮
    NSRange detailTextHighlightRange = [poi.address rangeOfString:_searchString];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:detailTextHighlightRange];
    cell.detailTextLabel.attributedText = detailText;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(setSelectedLocationWithLocation:)]) {
        [self.delegate setSelectedLocationWithLocation:_searchResultArray[indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    _searchResultArray = [NSMutableArray array];
    // 解决tableview无法正常显示的问题
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.definesPresentationContext = YES;
}


@end
