//
//  ZZContributionViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZContributionViewController.h"
#import "ZZRentViewController.h"
#import "ZZTotalContributionCell.h"
#import "ZZTotalContributionHeadView.h"
#import "ZZTotalContributionBottomView.h"

#import "ZZMMDTipModel.h"
#import "ZZUserFollowModel.h"

@interface ZZContributionViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZTotalContributionHeadView *headView;
@property (nonatomic, strong) ZZTotalContributionBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZMMDTipModel *tipModel;

@end

@implementation ZZContributionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"赏金贡献榜";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kYellowColor;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)createHeadView
{
    WeakSelf;
    CGFloat scale = SCREEN_WIDTH / 375.0;
    _headView = [[ZZTotalContributionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170*scale + 245)];
    [_headView setMMDData:self.dataArray model:_tipModel];
    _tableView.tableHeaderView = _headView;
    
    _headView.touchHead = ^(NSString *uid) {
        [weakSelf gotoUserPageWithUid:uid];
    };
}

#pragma mark - Data

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        if (weakSelf.mid) {
            [weakSelf pullWithSort_value1:nil Sort_value2:nil];
        } else {
            [weakSelf pullSkWithSort_value1:nil Sort_value2:nil];
        }
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZMMDTipListModel *lastModel = [weakSelf.dataArray lastObject];
        if (weakSelf.mid) {
            [weakSelf pullWithSort_value1:lastModel.sort_value1 Sort_value2:lastModel.sort_value2];
        } else {
            [weakSelf pullSkWithSort_value1:lastModel.sort_value1 Sort_value2:lastModel.sort_value2];
        }
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullWithSort_value1:(NSString *)sort_value1 Sort_value2:(NSString *)sort_value2
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    if (sort_value1 && sort_value2) {
        [aDict setObject:sort_value1 forKey:@"sort_value1"];
        [aDict setObject:sort_value2 forKey:@"sort_value2"];
    } else {
        aDict = nil;
    }
    [ZZMMDTipModel getMMDTipsListParam:aDict mid:_mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            _tipModel = [[ZZMMDTipModel alloc] initWithDictionary:data error:nil];
            if (!_dataArray) {
                _dataArray = [NSMutableArray array];
            }
            
            if (sort_value1 && sort_value2) {
                [_dataArray addObjectsFromArray:_tipModel.mmd_tips];
            } else {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:_tipModel.mmd_tips];
            }
            
            if (_tipModel.mmd_tips.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (!_headView) {
                [self createHeadView];
            }
            
            if (_tipModel.my_tip_rank && !_bottomView) {
                [self createBottomView];
            }
            
            [_tableView reloadData];
        }
    }];
}

- (void)pullSkWithSort_value1:(NSString *)sort_value1 Sort_value2:(NSString *)sort_value2
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    if (sort_value1 && sort_value2) {
        [aDict setObject:sort_value1 forKey:@"sort_value1"];
        [aDict setObject:sort_value2 forKey:@"sort_value2"];
    } else {
        aDict = nil;
    }
    [ZZMMDTipModel getSKTipsListParam:aDict skId:_skId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            _tipModel = [[ZZMMDTipModel alloc] initWithDictionary:data error:nil];
            if (!_dataArray) {
                _dataArray = [NSMutableArray array];
            }
            
            if (sort_value1 && sort_value2) {
                [_dataArray addObjectsFromArray:_tipModel.sk_tips];
            } else {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:_tipModel.sk_tips];
            }
            
            if (_tipModel.sk_tips.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (!_headView) {
                [self createHeadView];
            }
            
            if (_tipModel.my_tip_rank && !_bottomView) {
                [self createBottomView];
            }
            
            [_tableView reloadData];
        }
    }];
}

- (void)createBottomView
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-78);
    }];
    
    [self.bottomView setData:_tipModel.my_tip myRank:_tipModel.my_tip_rank];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count > 3?self.dataArray.count - 3:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    WeakSelf;
    
    ZZTotalContributionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZTotalContributionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setMMDData:self.dataArray[indexPath.row + 3] indexPath:indexPath];
    cell.attentView.touchAttent = ^{
        [weakSelf attentWithIndexPath:indexPath];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZZMMDTipListModel *model = _dataArray[indexPath.row + 3];
    [self gotoUserPageWithUid:model.tip.from.uid];
}

- (void)gotoUserPageWithUid:(NSString *)uid
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)attentWithIndexPath:(NSIndexPath *)indexPath
{
    if ([ZZUtils isBan]) {
        return;
    }
    ZZMMDTipListModel *model = _dataArray[indexPath.row + 3];
    if (model.tip.from.follow_status == 0) {
        [model.tip.from followWithUid:model.tip.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                model.tip.from.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                [self.tableView reloadData];
            }
        }];
    } else {
        [model.tip.from unfollowWithUid:model.tip.from.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                model.tip.from.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Lazyload

- (ZZTotalContributionBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[ZZTotalContributionBottomView alloc] init];
        [self.view addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(@78);
        }];
    }
    
    return _bottomView;
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
