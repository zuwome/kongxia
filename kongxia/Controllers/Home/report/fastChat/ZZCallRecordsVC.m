//
//  ZZCallRecordsVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCallRecordsVC.h"
#import "ZZCallRecordsModel.h"
#import "ZZCallRecordsCell.h"
#import "ZZFastChatManager.h"
#import "ZZRentViewController.h"

@interface ZZCallRecordsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZZCallRecordsModel *> *models;

@end

@implementation ZZCallRecordsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"通话记录";
    [self setupUI];
    [self sendRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZZCallRecordsCell class] forCellReuseIdentifier:[ZZCallRecordsCell reuseIdentifier]];
    }
    return _tableView;
}

- (NSMutableArray<ZZCallRecordsModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray new];
    }
    return _models;
}

#pragma mark - Private methods

- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
}

#pragma mark - 上下拉刷新回调

- (void)sendRequest {
    WeakSelf;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getHeadData];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getFootData];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)getHeadData {
    
    [self.tableView.mj_footer resetNoMoreData];
    NSMutableDictionary *aDcit = [@{} mutableCopy];
    WEAK_SELF();
    
    [GetFastChatManager() asyncFetchCallRecordsWithParam:aDcit completeBlock:^(ZZError *error, NSMutableArray<ZZCallRecordsModel *> *models, NSURLSessionDataTask *task) {
        [weakSelf headerCallBack:error models:models task:task];
    }];
}

- (void)getFootData {
    
    if (self.models.count) {
        WEAK_SELF();
        //        NSMutableDictionary *aDcit = [@{@"sortValue" : self.users.lastObject.sortValue} mutableCopy];
        NSMutableDictionary *aDcit = [@{@"sort_value" : self.models.lastObject.sort_value} mutableCopy];
        
        [GetFastChatManager() asyncFetchCallRecordsWithParam:aDcit completeBlock:^(ZZError *error, NSMutableArray<ZZCallRecordsModel *> *models, NSURLSessionDataTask *task) {
            [weakSelf footerCallBack:error models:models task:task];
        }];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)headerCallBack:(ZZError *)error models:(NSMutableArray<ZZCallRecordsModel *> *)models task:(NSURLSessionDataTask *)task {
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        self.models = models;
        if (self.models.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_tableView reloadData];
        [self updateNoneCallRecordsIfNeeded];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)footerCallBack:(ZZError *)error models:(NSMutableArray<ZZCallRecordsModel *> *)models task:(NSURLSessionDataTask *)task {
    [_tableView.mj_footer endRefreshing];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        if (models.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.models addObjectsFromArray:models];
            [_tableView reloadData];
        }
    }
}

// 删除通话记录
- (void)removeSelectCallRecordsWithIndePath:(NSIndexPath *)indexPath {
    
    ZZCallRecordsModel *model = self.models[indexPath.row];
    if (!model) {
        return;
    }
    WEAK_SELF();
    [ZZHUD show];
    [GetFastChatManager() asyncRemoveCallRecordsWithRid:model.room.id completeBlock:^(ZZError *error, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            [weakSelf.models removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
            
            [weakSelf updateNoneCallRecordsIfNeeded];
        }
    }];
}

// 空记录 UI 
- (void)updateNoneCallRecordsIfNeeded {
    
    if (self.models == nil || self.models.count == 0) {
        self.tableView.hidden = YES;
        
        CGFloat scale = SCREEN_WIDTH / 375.0;
        
        UIImageView *noneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_NoneCallRecords"]];
        
        UILabel *label = [UILabel new];
        label.text = @"还没有通话记录 你需要主动一点了";
        label.textColor = RGBCOLOR(165, 165, 165);
        label.font = [UIFont systemFontOfSize:15];
        
        [self.view addSubview:label];
        [self.view addSubview:noneImage];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self.view);
            make.height.equalTo(@20);
        }];
        
        [noneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(label.mas_top).offset(-27);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(scale * 182.0));
            make.height.equalTo(@(scale * 149.0));
        }];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZCallRecordsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ZZCallRecordsCell reuseIdentifier] forIndexPath:indexPath];
    [cell setupWithModel:self.models[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF();
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                              
                                                                              [weakSelf removeSelectCallRecordsWithIndePath:indexPath];
                                                                          }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZCallRecordsModel *model = self.models[indexPath.row];
    
    ZZUser *user ;
    if ([model.room.admin.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        user = model.room.user;
    } else {
        user = model.room.admin;
    }
    if (user) {
        ZZRentViewController *controller = [[ZZRentViewController alloc] init];
        controller.uid = user.uid;
        controller.isFromFastChat = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
