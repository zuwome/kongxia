//
//  ZZBlackManagerViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZBlackManagerViewController.h"

#import "ZZUserBlackCell.h"
#import "ZZUserBlackEmptyView.h"

#import "ZZUserBlackModel.h"

@interface ZZBlackManagerViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZUserBlackEmptyView *emptyView;

@end

@implementation ZZBlackManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"黑名单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - LoadData

- (void)loadData
{
    WeakSelf;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf pullWithSort_value:nil];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZUserBlackModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullWithSort_value:lastModel.sort_value];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullWithSort_value:(NSString *)sort_value
{
    NSMutableDictionary *aDict = [@{@"query_type":@"from"} mutableCopy];
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
    }
    ZZUserBlackModel *model = [[ZZUserBlackModel alloc] init];
    [model getBlackList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            NSMutableArray *d = [ZZUserBlackModel arrayOfModelsFromDictionaries:data error:nil];
            if (d.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (sort_value) {
                [_dataArray addObjectsFromArray:d];
            } else {
                _dataArray = d;
            }
            [_tableView reloadData];
            
            if (_dataArray.count == 0) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            } else {
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
            }
        }
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZUserBlackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZUserBlackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    WeakSelf;
    cell.touchCancel = ^{
        [weakSelf cancelBtnClick:indexPath];
    };
    [cell setData:_dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick:(NSIndexPath *)indexPath
{
    ZZUserBlackModel *model = _dataArray[indexPath.row];
    [ZZUser removeBlackWithUid:model.black.beUser.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            });
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
            if (!muArray) {
                muArray = @[].mutableCopy;
            }
            
            if ([muArray containsObject:model.black.beUser.uid]) {
                [muArray removeObject:model.black.beUser.uid];
            }
            
            [userDefault setObject:muArray.copy forKey:@"BannedVideoPeople"];
            [userDefault synchronize];
        }
    }];
}

- (ZZUserBlackEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[ZZUserBlackEmptyView alloc] init];
        [self.view addSubview:_emptyView];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _emptyView;
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
