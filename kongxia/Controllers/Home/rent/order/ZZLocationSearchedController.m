//
//  ZZLocationSearchedController.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZLocationSearchedController.h"
#import <AMapSearchKit/AMapSearchKit.h>

#import "ZZRentLocationCell.h"

@interface ZZLocationSearchedController ()

@end

@implementation ZZLocationSearchedController
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
    BOOL _isFromMoreLoadRequest;
}

- (instancetype)init {
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)searchTipsWithKey:(NSString *)key searchLimited:(BOOL)searchLimited {
    if (key.length == 0) {
        return;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = key;
    if (_isFromMylocations) {
        request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|风景名胜|科教文化服务|商场|购物服务|购物中心";
//         request.types =@"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
        request.cityLimit = NO;

    }
    else {
        request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
        if (_currentCity) {
            request.city = _currentCity.name ? _currentCity.name: @"厦门";
        }
        else if ([ZZUserHelper shareInstance].cityName) {
            request.city = [ZZUserHelper shareInstance].cityName;
        }
        request.cityLimit = searchLimited;
    }
    if (_currentCity) {
        request.city = _currentCity.name? _currentCity.name: @"厦门";
    }
    else if ([ZZUserHelper shareInstance].cityName) {
        request.city = [ZZUserHelper shareInstance].cityName;
    }
    [_searchAPI AMapPOIKeywordsSearch:request];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    _keywords = searchBar.text;
    NSString *key = searchBar.text;
    /* 按下键盘enter, 搜索poi */
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];

    request.keywords = key;
    request.types = @"餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    if (_currentCity) {
        request.city = _currentCity.name? _currentCity.name: @"厦门";
    } else if ([ZZUserHelper shareInstance].cityName) {
        request.city = [ZZUserHelper shareInstance].cityName;
    }
    request.requireExtension = YES;
    request.cityLimit = NO;
//    [self.displayController setActive:NO animated:NO];
//    self.searchController.searchBar.placeholder = key;
    _searchString = searchBar.text;
    [self searchTipsWithKey:searchBar.text searchLimited:NO];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchTipsWithKey:searchController.searchBar.text searchLimited:YES];
    _searchString = searchController.searchBar.text;
//    _searchString = searchController.searchBar.text;
//    searchPage = 1;
//    [self searchPoiBySearchString:_searchString];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    // 判断是否从更多拉取
    if (_isFromMoreLoadRequest) {
        _isFromMoreLoadRequest = NO;
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
    ZZRentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentLocationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _searchResultArray.count - 1) {
        cell.seperateLine.hidden = YES;
    }
    else {
        cell.seperateLine.hidden = NO;
    }
    
    AMapPOI *poi = [_searchResultArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:poi.name];
    [text addAttribute:NSForegroundColorAttributeName value:kBlackTextColor range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    //高亮
    NSRange textHighlightRange = [poi.name rangeOfString:_searchString];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:textHighlightRange];
    cell.titleLabel.attributedText = text;
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:poi.address];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, detailText.length)];
    [detailText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, detailText.length)];
    //高亮
    NSRange detailTextHighlightRange = [poi.address rangeOfString:_searchString];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:detailTextHighlightRange];
    cell.contentLabel.attributedText = detailText;
    cell.selectImgView.hidden = YES;
    
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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50.0;
    
    [self.tableView registerClass:[ZZRentLocationCell class] forCellReuseIdentifier:@"ZZRentLocationCell"];
}

- (void)setSearchCity:(NSString *)city
{
    _city = city;
}


@end
