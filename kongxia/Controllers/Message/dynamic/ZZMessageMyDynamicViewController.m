//
//  ZZMessageMyDynamicViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageMyDynamicViewController.h"
#import "ZZRentViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZTaskDetailViewController.h"

#import "ZZMessageMyDynamicCell.h"
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "ZZMessageDynamicModel.h"
#import "HttpDNS.h"
@interface ZZMessageMyDynamicViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZMessageMyDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"互动";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)createViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableView registerClass:[ZZMessageMyDynamicCell class] forCellReuseIdentifier:@"mycell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _emptyView = [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:_tableView.frame viewController:self];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
}

#pragma mark - Data

- (void)loadData
{
    if ([[ZZUserHelper shareInstance].unreadModel.hd intValue] > 0) {
        [ZZUserHelper shareInstance].unreadModel.hd = @0;
        [ZZUserHelper shareInstance].updateMessageList = YES;
    }
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf pullRequest:nil];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZMessageDynamicModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:lastModel.sort_value];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSMutableDictionary *aDict = [@{@"type":@"hd"} mutableCopy];
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
    }
    [ZZMessageDynamicModel getMyDynamicList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (error) {
            if (error.code ==1111) {
                if (self.dataArray.count<=0) {
                    self.emptyView.hidden = NO;
                }else{
                    self.emptyView.hidden = YES;
                    [self.alertEmptyView showView:self];
                }
            }else{
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else if (data) {
            self.emptyView.hidden = YES;
            NSMutableArray *d = [ZZMessageDynamicModel arrayOfModelsFromDictionaries:data error:nil];
            if (d.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (sort_value) {
                [_dataArray addObjectsFromArray:d];
            } else {
                _dataArray = d;
            }
            [_tableView reloadData];
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
    ZZMessageMyDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(ZZMessageMyDynamicCell *)cell indexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    [cell setData:_dataArray[indexPath.row]];
    cell.touchHead = ^{
        [weakSelf gotoUserPage:indexPath];
    };
    cell.touchLinkUrl = ^{
        [self gotoUserPage:indexPath];
    };
    if (indexPath.row == 0) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    return [tableView fd_heightForCellWithIdentifier:@"mycell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf setupCell:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageDynamicModel *model = _dataArray[indexPath.row];
    
    if ([model.message.type isEqualToString:@"pd_like"]) {
        if (model.pd == 0) {
            [self goToTaskDetails:model.pid];
        }
        else {
            [ZZHUD showTaskInfoWithStatus:@"订单已经结束"];
        }
    }
    else {
        if (model.message.mmd.mid) {
            [self gotoMmdDetail:model];
        } else if (model.message.sk.skId) {
            [self gotoSKDetai:model];
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)gotoMmdDetail:(ZZMessageDynamicModel *)model
{
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.mid = model.message.mmd.mid;
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstMMDModel = model.message.mmd;
}

- (void)gotoSKDetai:(ZZMessageDynamicModel *)model
{
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.skId = model.message.sk.skId;
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstSkModel = model.message.sk;
}

- (void)gotoUserPage:(NSIndexPath *)indexPath
{
    ZZMessageDynamicModel *model = _dataArray[indexPath.row];
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = model.message.from.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (ZZAlertNotNetEmptyView *)alertEmptyView {
    if (!_alertEmptyView) {
        _alertEmptyView = [[ZZAlertNotNetEmptyView alloc]init];
        [_alertEmptyView alertShowViewController:self];
    }
    return _alertEmptyView;
}

- (void)goToTaskDetails:(NSString *)taskID {
    ZZTaskDetailViewController *vc = [[ZZTaskDetailViewController alloc] initWithTaskID:taskID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
