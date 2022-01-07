//
//  ZZMeBiRecordViewController.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZMeBiRecordViewController.h"
#import "ZZPayRecordCalendars.h"//时间选择
#import "ZZMeBiRecordModel.h"
#import "ZZRecordMeBiCell.h"
#import "ZZRecordFullInfoCell.h"

#import <MJRefresh.h>

@interface ZZMeBiRecordViewController ()<UITableViewDelegate,UITableViewDataSource, ZZRecordFullInfoCellDelegate>
@property (nonatomic,strong) MJRefreshAutoStateFooter *footer;
@property (nonatomic, strong) ZZWalletEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ZZMeBiRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBGColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emptyView];
   
    [self registCell];
    self.emptyView.infoLabel.text = @"您还没有么币记录";
    [self loadMeBiRecordDataIsFirstLoad];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[ZZPayRecordCalendars shared] dissMiss];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView.mj_footer resetNoMoreData];

}

- (void)registCell {
    self.tableView.rowHeight = AdaptedHeight(75);
    self.tableView.mj_footer = self.footer;

    [self.tableView registerClass:[ZZRecordMeBiCell class] forCellReuseIdentifier:@"ZZRecordMeBiCellID"];
    [self.tableView registerClass:[ZZRecordFullInfoCell class] forCellReuseIdentifier:[ZZRecordFullInfoCell cellIdentifier]];
}

#pragma mark - ZZRecordFullInfoCellDelegateDelegate
- (void)cell:(ZZRecordFullInfoCell *)cell showUserInfo:(ZZUser *)user {
    [self showUserInfo:user];
}

#pragma mark - Navigator
- (void)showUserInfo:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.user = user;
    controller.uid = user._id;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 加载数据

- (void)loadMeBiRecordData {
    NSMutableDictionary *dic = nil;
  
        ZZMeBiRecordModel *mebiModel = [self.dataArray lastObject];
        dic = [NSMutableDictionary dictionary];
        if (mebiModel.sort_value) {
            [dic setObject:mebiModel.sort_value forKey:@"sort_value"];
        }
        else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
            return;
        }
        

    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/mcoin_records"] params:dic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_footer endRefreshing];
        if (data) {
            NSMutableArray *recordMeBiArr = [ZZMeBiRecordModel arrayOfModelsFromDictionaries:data];
            if (recordMeBiArr.count <= 0 || !recordMeBiArr) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return ;
            }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataArray  addObjectsFromArray:recordMeBiArr];
                    [self.tableView reloadData];
                });
          }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [ZZHUD showTaskInfoWithStatus:error.message];
            });
        }
    }];
}

- (void)loadMeBiRecordDataIsFirstLoad{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/mcoin_records"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
      
        [self.tableView.mj_footer endRefreshing];
        if (data) {
           NSMutableArray *recordMeBiArr = [ZZMeBiRecordModel arrayOfModelsFromDictionaries:data];
            if (recordMeBiArr.count <= 0 || !recordMeBiArr) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return ;
            }
    
                dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray = recordMeBiArr;
                if (self.dataArray.count>0) {
                     _footer.stateLabel.hidden = NO;
                    self.emptyView.hidden = YES;
                }
                  [self.tableView reloadData];
                });
          
      
        }
        else{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
                 [ZZHUD showTaskInfoWithStatus:error.message];
                });
        }
    }];
}
- (MJRefreshAutoStateFooter *)footer {
    if (!_footer) {
        _footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMeBiRecordData)];
        _footer.automaticallyRefresh = NO;
        _footer.stateLabel.hidden = YES;
    }
    return _footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZMeBiRecordModel *model = self.dataArray[indexPath.row];
    if ([model.mcoin_record[@"type"] isEqualToString:@"give_gift"] || [model.mcoin_record[@"type"] isEqualToString:@"song_gift"]) {
        ZZRecordFullInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRecordFullInfoCell cellIdentifier] forIndexPath:indexPath];
        cell.mebiModel = model;
        cell.delegate = self;
        return cell;
    }
    else {
        ZZRecordMeBiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRecordMeBiCellID"];
        [cell setRecordModel: model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -44) style:UITableViewStylePlain ];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0.5)];
        view.backgroundColor = RGBCOLOR(237, 237, 237);
        self.tableView.tableHeaderView = view;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    
    return _tableView;
}
#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (ZZWalletEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[ZZWalletEmptyView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -124-SafeAreaBottomHeight)];
    }
    
    return _emptyView;
}
- (void)dealloc {
     NSLog(@"PY_%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
