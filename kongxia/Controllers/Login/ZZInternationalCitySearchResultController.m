//
//  ZZInternationalCitySearchResultController.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZInternationalCitySearchResultController.h"
#import "ZZInternationalCityModel.h"
#import "ZZInternationalCityCell.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface ZZInternationalCitySearchResultController ()


@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索的数据

@end

@implementation ZZInternationalCitySearchResultController
{
    // 搜索key
    NSString *_searchString;
}

- (void)searchWithSearchString:(NSString *)string {
    [_searchArray removeAllObjects];
    
    if (string.length > 0 && _dataArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_dataArray.count; i++) {
                NSArray *array = _dataArray[i];
                for (ZZInternationalCityModel *model in array) {
                    if ([ChineseInclude isIncludeChineseInString:model.name]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.name];
                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:model];
                        }
                        
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        
                        if (titleHeadResult.length>1) {
                            [_searchArray addObject:model];
                        }
                    } else {
                        NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:model];
                        }
                    }
                }
            }
        } else {
            for (int i=0; i<_dataArray.count; i++) {
                NSArray *array = _dataArray[i];
                for (ZZInternationalCityModel *model in array) {
                    NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchArray addObject:model];
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
    _searchString = searchController.searchBar.text;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuseIdentifier = @"searchResultCell";
    ZZInternationalCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZInternationalCityCell"];
    if (!cell) {
        cell = [[ZZInternationalCityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    ZZInternationalCityModel *model = self.searchArray[indexPath.row];
    [cell setData:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectNation:)]) {
        [self.delegate selectNation:_searchArray[indexPath.row]];
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

    _searchArray = [NSMutableArray array];
    // 解决tableview无法正常显示的问题
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.definesPresentationContext = YES;
}


@end
