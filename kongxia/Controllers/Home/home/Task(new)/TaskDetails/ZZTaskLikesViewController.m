//
//  ZZTaskLikesViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskLikesViewController.h"
#import "ZZRentViewController.h"

#import "ZZTaskLikesViewModel.h"

@interface ZZTaskLikesViewController ()<ZZTaskLikesViewModelDelegate>

@property (nonatomic, strong) ZZTaskLikesViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ZZTaskLikesViewController

- (instancetype)initWithTaskID:(NSString *)taskID {
    self = [super init];
    if (self) {
        _viewModel = [[ZZTaskLikesViewModel alloc] initWithTaskID:taskID tableView:self.tableview];
        _viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部点赞";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Navigator
- (void)showUserInfo:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = user.uuid;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ZZTaskLikesViewModelDelegate
- (void)viewModel:(ZZTaskLikesViewModel *)model showUserInfoWith:(ZZUser *)user {
    [self showUserInfo:user];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Getter&Setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableview.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.01f)];
    }
    return _tableview;
}

@end
