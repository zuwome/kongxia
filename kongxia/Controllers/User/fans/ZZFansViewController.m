//
//  ZZFansViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFansViewController.h"
#import "ZZRentViewController.h"

#import "ZZAttentionCell.h"
#import "ZZAttentSortTypeView.h"
#import "ZZFansEmptyView.h"

#import "ZZUserFollowModel.h"
#import "ZZNotNetEmptyView.h"
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "HttpDNS.h"

@interface ZZFansViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZAttentSortTypeView *typeView;
@property (nonatomic, strong) ZZFansEmptyView *emptyView;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyNotEmptView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZFansViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的粉丝";
    
    [self createViews];
    [self loadData];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
}

- (void)createViews
{
    self.view.backgroundColor = kBGColor;
    
    [self.view addSubview:self.tableView];
   _emptyNotEmptView = [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:_tableView.frame viewController:self];

    [self.view addSubview:self.typeView];
    [self setCount];
}

- (void)setCount
{
    self.typeView.countLabel.text = [NSString stringWithFormat:@"%ld位粉丝用户",_user.follower_count];
}

#pragma mark - Data

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf pullWithSort_value1:nil sort_value2:nil];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZUserFollowModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullWithSort_value1:lastModel.sort_value1 sort_value2:lastModel.sort_value2];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullWithSort_value1:(NSString *)sort_value1 sort_value2:(NSString *)sort_value2
{
    NSMutableDictionary *aDict = [@{@"query_type":@"from"} mutableCopy];
    if (sort_value1) {
        [aDict setObject:sort_value1 forKey:@"sort_value1"];
    }
    if (sort_value2) {
        [aDict setObject:sort_value2 forKey:@"sort_value2"];
    }
    switch (self.typeView.selectedIndex) {
        case 0:
        {
            [aDict setObject:@"default" forKey:@"type"];
        }
            break;
        case 1:
        {
            [aDict setObject:@"level" forKey:@"type"];
        }
            break;
        case 2:
        {
            [aDict setObject:@"distance" forKey:@"type"];
        }
            break;
        case 3:
        {
            [aDict setObject:@"gender_2" forKey:@"type"];
        }
            break;
        case 4:
        {
            [aDict setObject:@"gender_1" forKey:@"type"];
        }
            break;
        default:
            break;
    }
    ZZUserFollowModel *model = [[ZZUserFollowModel alloc] init];
    WS(weakSelf);
    [model getFansListWithParam:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        if (error) {
            if (error.code ==1111) {
                if (weakSelf.dataArray.count<=0&&error.code ==1111) {
                    weakSelf.emptyNotEmptView.hidden = NO;
                }else{
                    weakSelf.emptyNotEmptView.hidden = YES;
                   [weakSelf.alertEmptyView showView:weakSelf];
                }
            }else{
                [ZZHUD showErrorWithStatus:error.message];
            }
          
        } else if (data) {
            NSMutableArray *d = [ZZUserFollowModel arrayOfModelsFromDictionaries:data error:nil];
            if (d.count == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (sort_value1) {
                [weakSelf.dataArray addObjectsFromArray:d];
            } else {
                weakSelf.dataArray = d;
            }
            [weakSelf.tableView reloadData];
            weakSelf.emptyNotEmptView.hidden = YES;

            if (weakSelf.dataArray.count == 0 && weakSelf.typeView.selectedIndex == 0) {
                weakSelf.emptyView.hidden = NO;
                weakSelf.tableView.hidden = YES;
            } else {
                weakSelf.emptyView.hidden = YES;
                weakSelf.tableView.hidden = NO;
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
    
    ZZAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setData:_dataArray[indexPath.row]];
    WeakSelf;
    cell.attentView.touchAttent = ^{
        [weakSelf attentWithIndexPath:indexPath];
    };
    if (self.typeView.selectedIndex == 2) {
        cell.distanceLabel.hidden = NO;
        cell.distanceImgView.hidden = NO;
    } else {
        cell.distanceLabel.hidden = YES;
        cell.distanceImgView.hidden = YES;
    }
    
    if (indexPath.row == self.dataArray.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZUserFollowModel *model = _dataArray[indexPath.row];
    
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = model.user.uid;
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)attentWithIndexPath:(NSIndexPath *)indexPath
{
    if ([ZZUtils isBan]) {
        return;
    }
    ZZUserFollowModel *model = _dataArray[indexPath.row];
    if (model.follow_status == 0) {
        [model.user followWithUid:model.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                model.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                [self.tableView reloadData];
                _user.follower_count++;
            }
        }];
    } else {
        [model.user unfollowWithUid:model.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                model.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                [self.tableView reloadData];
                if (_user.follower_count) {
                    _user.follower_count--;
                }
            }
        }];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 36)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    return _tableView;
}

- (ZZAttentSortTypeView *)typeView
{
    WeakSelf;
    if (!_typeView) {
        _typeView = [[ZZAttentSortTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        _typeView.selectedCallBack = ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _typeView;
}

- (ZZFansEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[ZZFansEmptyView alloc] init];
        _emptyView.contentLabel.text = @"一个粉丝也没有 你不能再低调了";
        [self.view addSubview:_emptyView];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _emptyView;
}
- (ZZAlertNotNetEmptyView *)alertEmptyView {
    if (!_alertEmptyView) {
        _alertEmptyView = [[ZZAlertNotNetEmptyView alloc]init];
        [_alertEmptyView alertShowViewController:self];
    }
    return _alertEmptyView;
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
