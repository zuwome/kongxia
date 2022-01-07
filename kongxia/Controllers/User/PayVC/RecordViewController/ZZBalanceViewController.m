//
//  ZZBalanceViewController.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZBalanceViewController.h"
#import "ZZPayRecordCalendars.h"//时间选择

#import "ZZRecordMeBiCell.h"
#import "ZZRecordFullInfoCell.h"

#import "ZZRecord.h"

@interface ZZBalanceViewController ()<UITableViewDelegate,UITableViewDataSource, ZZRecordFullInfoCellDelegate>
@property (nonatomic,strong) MJRefreshAutoStateFooter *footer;

@end

@implementation ZZBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBGColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emptyView];
    [self registCell];
    self.emptyView.infoLabel.text = @"您还没有余额记录";
    [self loadMeBiRecordDataIsFirstLoad];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_footer resetNoMoreData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ZZPayRecordCalendars shared] dissMiss];
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
- (void)loadMeBiRecordDataIsFirstLoad {
    [ZZRecord rechargeWithParam:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_footer endRefreshing];
        if (data) {
            if (!data[@"capitals"]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return ;
            }
            NSError *error;
            NSMutableArray *recordMeBiArr = [ZZRecord arrayOfModelsFromDictionaries:data[@"capitals"] error:&error];
            if (recordMeBiArr.count <= 0 || error != NULL) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];

                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray = recordMeBiArr;
                if (self.dataArray.count>0) {
                    self.emptyView.hidden = YES;
                     _footer.stateLabel.hidden = NO;
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

- (void)loadMeBiRecordData {
    NSMutableDictionary *dic = nil;
   
    ZZRecord *mebiModel = [self.dataArray lastObject];
    dic = [NSMutableDictionary dictionary];
    if (mebiModel.created_at) {
        [dic setObject:mebiModel.created_at forKey:@"lt"];
    }
    else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    [ZZRecord rechargeWithParam:dic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_footer endRefreshing];
        if (data) {
            if (!data[@"capitals"]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return ;
            }
            NSError *error;
            NSMutableArray *recordMeBiArr = [ZZRecord arrayOfModelsFromDictionaries:data[@"capitals"] error:&error];
            if (recordMeBiArr.count <= 0 || error != NULL) {
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

- (UITableView *)tableView {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRecord *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"receive_gift"] || [model.type isEqualToString:@"receive_gift_song"]) {
        ZZRecordFullInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRecordFullInfoCell cellIdentifier] forIndexPath:indexPath];
        cell.recordMoneyModel = model;
        cell.delegate = self;
        return cell;
    }
    else {
        ZZRecordMeBiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRecordMoneyID"];
        [cell setRecordMoneyModel:model];
        return cell;
    }
}

- (void)registCell {
    self.tableView.rowHeight = AdaptedHeight(75);
    self.tableView.mj_footer = self.footer;
    [self.tableView registerClass:[ZZRecordMeBiCell class] forCellReuseIdentifier:@"ZZRecordMoneyID"];
    [self.tableView registerClass:[ZZRecordFullInfoCell class] forCellReuseIdentifier:[ZZRecordFullInfoCell cellIdentifier]];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (ZZWalletEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[ZZWalletEmptyView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -124-SafeAreaBottomHeight)];
    }
    
    return _emptyView;
}

- (MJRefreshAutoStateFooter *)footer {
    if (!_footer) {
        _footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMeBiRecordData)];
        _footer.automaticallyRefresh = NO;
         _footer.stateLabel.hidden = YES;
    }
    return _footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
