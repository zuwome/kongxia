//
//  ZZLocationSearchedController.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZLocationSearchedController.h"

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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSString *key = searchBar.text;
    _searchString = searchBar.text;
    
    [POIManager getPoisWithKeyword:key location:_location.coordinate completion:^(NSArray<PoiModel *> * pois) {
        [self filterResults:pois];
    }];
 
}

- (void)filterResults:(NSArray<PoiModel *> *)pois {
    NSArray<NSString *> *limitTypes = @[@"120104", @"120103", @"120200", @"120201", @"130807"];
    
    NSMutableArray *filterdPois = [[NSMutableArray alloc] init];
    
    [pois enumerateObjectsUsingBlock:^(PoiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![limitTypes containsObject:obj.poiType]) {
            [filterdPois addObject:obj];
        }
    }];
    
    _searchResultArray = filterdPois;
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    [self searchTipsWithKey:searchController.searchBar.text searchLimited:YES];
//    _searchString = searchController.searchBar.text;
//    _searchString = searchController.searchBar.text;
//    searchPage = 1;
//    [self searchPoiBySearchString:_searchString];
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
    
    PoiModel *poi = [_searchResultArray objectAtIndex:indexPath.row];
    
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
