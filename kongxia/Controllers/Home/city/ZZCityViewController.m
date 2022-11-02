//
//  ZZCityViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCityViewController.h"
#import "ZZCityLocationCell.h"
#import "ZZCityNameCell.h"
#import "ZZCityHotCell.h"

#import <MapKit/MapKit.h>

#import "ZZCity.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface ZZCityViewController () <UITableViewDataSource,UITableViewDelegate,ZZCitySearchViewControllerDelegate>
{
    NSMutableArray                      *_cityArray;//城市
    NSMutableArray                      *_indexArray;//索引
    CGFloat                             _hotCityHeight;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//总的数据
@property (nonatomic, strong) NSString *currentCity;//定位cell显示的值
@property (nonatomic, strong) ZZCity *currentLocation;
@property (nonatomic, assign) BOOL haveGotCity;//是否定位到城市
@property (nonatomic, strong) NSMutableArray *hotArray;//热门城市
@property (nonatomic, assign) BOOL requestLocation;

@property (nonatomic, strong) ZZCitySearchViewController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *searchArray;//搜索的数据
@property (nonatomic, assign) BOOL getLocatio;

@end

@implementation ZZCityViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isPush = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.definesPresentationContext = YES;
    self.navigationItem.title = @"选择城市";
    [self getLocation];
    [self createViews];
    [self sendRequest];
}

- (void)createNavigationLeftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    
    [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems =@[leftItem];

}

- (void)navigationLeftBtnClick
{
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)createViews
{
    _currentCity = @"正在定位...";
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = kYellowColor;
    _tableView.sectionIndexMinimumDisplayRowCount = 40;
    [_tableView registerClass:[ZZCityHotCell class] forCellReuseIdentifier:@"hotcell"];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(56);
        make.bottom.mas_equalTo(self.view).with.offset(-SafeAreaBottomHeight);

    }];
    
    [self initSearchDisplay];
}

- (void)initSearchDisplay {
    _searchResultTableVC = [[ZZCitySearchViewController alloc] init];
    _searchResultTableVC.cityArray = _cityArray;
    _searchResultTableVC.delegate = self;

    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;

    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - SendRequest

- (void)getLocation
{
    _requestLocation = NO;
    _currentCity = @"正在定位...";
    [_tableView reloadData];
    _getLocatio = NO;
    [[LocationManager shared] getLocationWithSuccess:^(CLLocation *location, CLPlacemark *placemark) {
        [self configureLocation:location
                      placeMark:placemark];
    } failure:^(CLAuthorizationStatus status, NSString *error) {
        self.currentCity = @"定位失败，重新获取";
    }];
}

- (void)configureLocation:(CLLocation *)location placeMark:(CLPlacemark *)placemark {
    if (_getLocatio) {
        return;
    }
    _getLocatio = YES;
    
    [ZZUserHelper shareInstance].location = location;
    
    __block BOOL haveCity = NO;
    if ([ZZUserHelper shareInstance].cityName) {
        haveCity = YES;
    }
    __weak typeof(self)weakSelf = self;

    NSString *cityName = @"";
    if (placemark.locality) {
        cityName = placemark.locality;
    } else if (placemark.administrativeArea) {
        cityName = placemark.administrativeArea;
    }
    if ([self isSpecailProvince:cityName]) {
        cityName = placemark.subLocality;
    }
    if (![placemark.ISOcountryCode isEqualToString:@"CN"]) {
        [ZZUserHelper shareInstance].isAbroad = YES;
        cityName = placemark.country;
    }
    
    if (!isNullString(cityName)) {
        [ZZUserHelper shareInstance].cityName = cityName;
        weakSelf.currentCity = cityName;
        weakSelf.haveGotCity = YES;
        if (!weakSelf.currentLocation) {
            weakSelf.currentLocation = [[ZZCity alloc] init];
        }
        weakSelf.currentLocation.name = cityName;
        weakSelf.currentLocation.center = [NSString stringWithFormat:@"%f,%f",placemark.location.coordinate.longitude, placemark.location.coordinate.latitude];
    }
    else {
        weakSelf.currentCity = @"定位失败，重新获取";
    }
    
    weakSelf.requestLocation = YES;
    [weakSelf.tableView reloadData];
}

- (BOOL)isSpecailProvince:(NSString *)province
{
    if ([province isEqualToString:@"新疆维吾尔自治区"] || [province isEqualToString:@"海南省"] ||[province isEqualToString:@"湖北省"] ||[province isEqualToString:@"河南省"]) {
        return YES;
    }
    return NO;
}

- (void)sendRequest
{
    [[ZZCity new] list:^(ZZError *error, NSArray *data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            NSArray *array = data;
            _dataArray = [NSMutableArray arrayWithArray:array];
            [_dataArray removeObjectAtIndex:0];
            _hotArray = [ZZCity arrayOfModelsFromDictionaries:[array[0] objectForKey:@"hot"] error:nil];
            [self managerHotCityHeight];
            [self managerIndex];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)managerHotCityHeight
{
    CGFloat labelHeight = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:14 labelWidth:MAXFLOAT] + 10;
    CGFloat width = 0;
    NSInteger count = 0;
    NSInteger yCount = 0;
    
    for (ZZCity *city in _hotArray) {
        CGFloat labelWidth = [ZZUtils widthForCellWithText:city.name fontSize:14] + 16;
        if (count == 0) {
            width = labelWidth;
        } else {
            width = width + labelWidth + 18;
        }
        if (width >= SCREEN_WIDTH - 30) {
            width = labelWidth;
            yCount++;
        }
        count++;
    }
    _hotCityHeight = 20 + labelHeight + (labelHeight + 13)*yCount;
}

- (void)managerIndex
{
    _indexArray = [NSMutableArray array];
    _cityArray = [NSMutableArray array];
    [_indexArray addObject:@"定位"];
    [_indexArray addObject:@"热门"];
    for (NSDictionary *aDict in _dataArray) {
        NSString *key = [[aDict allKeys] firstObject];
        [_indexArray addObject:key];
        NSArray *array = [ZZCity arrayOfModelsFromDictionaries:[aDict objectForKey:key] error:nil];
        [_cityArray addObject:array];
        _searchResultTableVC.cityArray = _cityArray;
    }
}

#pragma mark - ZZCitySearchViewControllerDelegate
- (void)selectCity:(ZZCity *)city {
    if (_selectedCity) {
        _selectedCity(city);
    }
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        if (_cityArray) {
            return _indexArray.count;
        }
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0 || section == 1) {
            return 1;
        }
        NSArray *array = _cityArray[section - 2];
        return array.count;
    } else {
        return _searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0:
            {
                static NSString *identifier = @"locationcell";
                
                ZZCityLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ZZCityLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                
                cell.titleLabel.text = _currentCity;
                cell.selectCity = ^{
                    [weakSelf locationCitySelect];
                };
                
                return cell;
            }
                break;
            case 1:
            {
                ZZCityHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcell"];
                
                [self setupCell:cell];
                
                return cell;
            }
                break;
            default:
            {
                static NSString *identifier = @"namecell";
                
                ZZCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ZZCityNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                
                NSArray *array = _cityArray[indexPath.section - 2];
                ZZCity *city = array[indexPath.row];
                cell.titleLabel.text = city.name;
                
                return cell;
            }
                break;
        }
    } else {
        static NSString *identifier = @"namecell";
        
        ZZCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZCityNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        ZZCity *city = _searchArray[indexPath.row];
        cell.titleLabel.text = city.name;
        
        return cell;
    }
}

- (void)setupCell:(ZZCityHotCell *)cell
{
    __weak typeof(self)weakSelf = self;
    [cell setData:_hotArray];
    
    cell.selectIndex = ^(NSInteger index) {
        ZZCity *city = weakSelf.hotArray[index];
        if (weakSelf.selectedCity) {
            weakSelf.selectedCity(city);
        }
        
        if (_isPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            return 35;
        }
        if (indexPath.section == 1) {
            return _hotCityHeight;
        }
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        headView.backgroundColor = kBGColor;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [headView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_left).offset(15);
            make.centerY.mas_equalTo(headView.mas_centerY);
        }];
        
        if (section == 0) {
            titleLabel.text = @"定位";
        } else {
            titleLabel.text = _indexArray[section];
        }
        return headView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return 30;
    } else {
        return 0.1;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_cityArray && tableView == _tableView) {
        return _indexArray;
    }
    else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        if (indexPath.section >= 2) {
            NSArray *array = _cityArray[indexPath.section - 2];
            ZZCity *city = array[indexPath.row];
            if (_selectedCity) {
                _selectedCity(city);
            }
            if (_isPush) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    else {
        ZZCity *city = _searchArray[indexPath.row];
        if (_selectedCity) {
            _selectedCity(city);
        }
        if (_isPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

//选择定位城市
- (void)locationCitySelect
{
    if (_haveGotCity) {
        if (_selectedCity) {
            _selectedCity(_currentLocation);
        }
        if (_isPush) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (_requestLocation) {
        [self getLocation];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchWithSearchString:searchBar.text];
}

- (void)searchWithSearchString:(NSString *)string
{
    [self.searchArray removeAllObjects];
    
    if (string.length > 0 && _cityArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (ZZCity *city in array) {
                    if ([ChineseInclude isIncludeChineseInString:city.name]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:city.name];
                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:city];
                        }
                        
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:city.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        
                        if (titleHeadResult.length>1) {
                            [_searchArray addObject:city];
                        }
                    } else {
                        NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:city];
                        }
                    }
                }
            }
        } else {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (ZZCity *city in array) {
                    NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchArray addObject:city];
                    }
                }
            }
        }
    }
}

#pragma mark - lazy
- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    
    return _searchArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

@interface ZZCitySearchViewController ()

@end

@implementation ZZCitySearchViewController
{
    // 搜索结果数组
    NSMutableArray *_searchResultArray;
}

- (void)searchWithSearchString:(NSString *)string {
    [_searchResultArray removeAllObjects];
    
    if (string.length > 0 && _cityArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (ZZCity *city in array) {
                    if ([ChineseInclude isIncludeChineseInString:city.name]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:city.name];
                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchResultArray addObject:city];
                        }
                        
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:city.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        
                        if (titleHeadResult.length>1) {
                            [_searchResultArray addObject:city];
                        }
                    } else {
                        NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchResultArray addObject:city];
                        }
                    }
                }
            }
        } else {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (ZZCity *city in array) {
                    NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchResultArray addObject:city];
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchWithSearchString:searchController.searchBar.text];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"namecell";
    
    ZZCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZZCityNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZZCity *city = _searchResultArray[indexPath.row];
    cell.titleLabel.text = city.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectCity:)]) {
        [self.delegate selectCity:_searchResultArray[indexPath.row]];
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
    _searchResultArray = [NSMutableArray array];
    // 解决tableview无法正常显示的问题
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.definesPresentationContext = YES;
}


@end
