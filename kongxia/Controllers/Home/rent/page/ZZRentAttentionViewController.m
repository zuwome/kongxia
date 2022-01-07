//
//  ZZRentAttentionViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentAttentionViewController.h"
#import "ZZRentViewController.h"

#import "ZZRentAttentionCell.h"
#import "ZZAttentEmptyView.h"

#import "ZZUserFollowModel.h"

@interface ZZRentAttentionViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZAttentEmptyView *emptyView;

@end

@implementation ZZRentAttentionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBGColor;
    self.navigationItem.title = @"关注";
    
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - Data

- (void)loadData
{
    WeakSelf;
    self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullWithSort_value:nil];
    }];
    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZUserFollowModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullWithSort_value:lastModel.sort_value];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)pullWithSort_value:(NSString *)sort_value
{
    NSMutableDictionary *aDict = [@{@"query_type":@"from"} mutableCopy];
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
    }
    if ([ZZUserHelper shareInstance].isLogin) {
        [ZZUserFollowModel getUserAttentionListParam:aDict uid:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self getData:data error:error sort_value:sort_value];
        }];
    } else {
        [ZZUserFollowModel getUnloginUserAttentionListParam:aDict uid:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self getData:data error:error sort_value:sort_value];
        }];
    }
}

- (void)getData:(id)data error:(ZZError *)error sort_value:(NSString *)sort_value
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
    if (error) {
        if (error.code ==1111) {
            if (self.dataArray.count<=0) {
                self.emptyView.hidden = NO;
            }else{
                self.emptyView.hidden = YES;
            }
        }else{
            [ZZHUD showErrorWithStatus:error.message];
        }
    } else if (data) {
        self.emptyView.hidden = YES;

        NSMutableArray *d = [ZZUserFollowModel arrayOfModelsFromDictionaries:data error:nil];
        if (d.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (sort_value) {
            [_dataArray addObjectsFromArray:d];
        } else {
            _dataArray = d;
        }
        [self.tableView reloadData];
    
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    static NSString *identifier = @"mycell";
    
    ZZRentAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZRentAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setData:_dataArray[indexPath.row]];
    cell.attentView.touchAttent = ^{
        [weakSelf attentWithIndexPath:indexPath];
    };
    if (indexPath.row == 0) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _dataArray.count?40:0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headView.backgroundColor = kBGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = HEXCOLOR(0x7a7a7a);
        label.font = [UIFont systemFontOfSize:13];
        if (_dataArray.count) {
            label.text = @"TA关注的人";
        }
        [headView addSubview:label];
        return headView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
}

- (void)attentWithIndexPath:(NSIndexPath *)indexPath
{
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
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
            }
        }];
    }
}

#pragma mark - lazyload

- (ZZAttentEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[ZZAttentEmptyView alloc] init];
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
