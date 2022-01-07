//
//  ZZSignUpCityViewController.m
//  zuwome
//
//  Created by angBiu on 2016/11/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZInternationalCityViewController.h"
#import "ZZInternationalCitySearchResultController.h"

#import "ZZInternationalCityCell.h"
#import "ZZInternationalCityModel.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface ZZInternationalCityViewController () <UITableViewDataSource,UITableViewDelegate, ZZInternationalCitySearchResultControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//总的数据
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索的数据

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ZZInternationalCitySearchResultController *resultSearchController;

@end

@implementation ZZInternationalCityViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [ZZHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择国家或地区";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    [self loadData];
}

#pragma mark - Data

 - (void)loadData
{
    [ZZHUD showWithStatus:@"加载中..."];
    [ZZInternationalCityModel getInternationalCityList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            
            for (NSDictionary *aDict in data) {
                NSString *key = [[aDict allKeys] firstObject];
                [self.indexArray addObject:key];
                NSArray *array = [ZZInternationalCityModel arrayOfModelsFromDictionaries:[aDict objectForKey:key] error:nil];
                [self.dataArray addObject:array];
            }
            
            [self.view addSubview:self.tableView];
            [self initSearchVc];
//            [self.view addSubview:self.searchBar];
        }
    }];
}

#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        NSArray *array = self.dataArray[section];
        return array.count;
    } else {
        return self.searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    
    ZZInternationalCityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZInternationalCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (tableView == _tableView) {
        NSArray *array = self.dataArray[indexPath.section];
        ZZInternationalCityModel *model = array[indexPath.row];
        [cell setData:model];
    } else {
        ZZInternationalCityModel *model = self.searchArray[indexPath.row];
        [cell setData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return self.indexArray;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZInternationalCityModel *model;
    if (tableView == _tableView) {
        NSArray *array = self.dataArray[indexPath.section];
        model = array[indexPath.row];
    }
    else {
        model = self.searchArray[indexPath.row];
    }
    if (_selectedCode) {
        _selectedCode(model.code);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchWithSearchString:(NSString *)string
{
    [self.searchArray removeAllObjects];
    
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
}

#pragma mark - ZZInternationalCitySearchResultControllerDelegate
- (void)selectNation:(ZZInternationalCityModel *)nationModel {
    if (_selectedCode) {
        _selectedCode(nationModel.code);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Layout
- (void)initSearchVc {
    _resultSearchController = [[ZZInternationalCitySearchResultController alloc] init];
    _resultSearchController.delegate = self;
    _resultSearchController.dataArray = self.dataArray;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultSearchController];
    
    _searchController.searchResultsUpdater = _resultSearchController;

    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - Lazyload
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = kYellowColor;
        _tableView.sectionIndexMinimumDisplayRowCount = 40;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)indexArray
{
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    
    return _indexArray;
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
