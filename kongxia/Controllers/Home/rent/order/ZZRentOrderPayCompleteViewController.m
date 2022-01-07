//
//  ZZRentOrderPayCompleteViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderPayCompleteViewController.h"

#import "ZZPostTaskBasicInfoController.h"

#import "ZZRentPayCompleteChatCell.h"
#import "ZZRentPayCompleteCreateTaskCell.h"

@interface ZZRentOrderPayCompleteViewController ()<UITableViewDelegate, UITableViewDataSource, ZZRentPayCompleteChatCellDelegate, ZZRentOrderPayCompleteWeChatCellDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSDictionary *tipsDic;

@property (nonatomic, assign) bool isSubmitWechat;

@end

@implementation ZZRentOrderPayCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSubmitWechat = NO;
    [self fetchTips];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)navigationLeftBtnClick {
    [self gotoChatView];
}

- (void)pushOrPop:(BOOL)isPush controller:(UIViewController *)controller {
    if (isPush) {
        controller.hidesBottomBarWhenPushed = YES;
        NSMutableArray<__kindof UIViewController *> *array = self.navigationController.viewControllers.mutableCopy;
        
        __block BOOL isFromChat = NO;
        for (NSInteger i = array.count - 1; i >= 0; i--) {
            __kindof UIViewController *vc = array[i];
            if ([vc isKindOfClass:[ZZRentViewController class]]) {
                break;
            }
            else if ([vc isKindOfClass:[ZZChatViewController class]]) {
                isFromChat = YES;
                break;
            }
            else {
                [array removeObject:vc];
            }
        }
        
        if ([controller isKindOfClass:[ZZPostTaskBasicInfoController class]]) {
            [array addObject:controller];
        }
        else {
            if (!isFromChat) {
                [array addObject:controller];
            }
        }
        [self.navigationController setViewControllers:array animated:YES];
    }
    else {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark - ZZRentOrderPayCompleteWeChatCellDelegate
- (void)sumbitWechatWithCell:(ZZRentOrderPayCompleteWeChatCell *)cell wechat:(NSString * _Nonnull)wechat {
    [self submitWechat:wechat];
}

#pragma mark - ZZRentPayCompleteChatCellDelegate
- (void)cellGoChat:(ZZRentPayCompleteChatCell *)cell {
    [self gotoChatView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZZRentPayCompleteChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRentPayCompleteChatCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.order = self.order;
        return cell;
    }
    else if (indexPath.section == 1) {
        ZZRentPayCompleteCreateTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRentPayCompleteCreateTaskCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tipsDic = _tipsDic;
        return cell;
    }
    else {
        ZZRentOrderPayCompleteWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRentOrderPayCompleteWeChatCell cellIdentifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell buttonStateWithIsSubmin:_isSubmitWechat];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 158.0;
    }
    else if (indexPath.section == 1) {
        return 400;
    }
    return 57;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10.0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Navigator
- (void)gotoChatView {
    if (_fromChat) {
        for (UIViewController *ctl in self.navigationController.viewControllers) {
            if ([ctl isKindOfClass:[ZZChatViewController class]]) {
                if (_callBack) {
                    _callBack();
                }
                [self pushOrPop:YES controller:ctl];
                
                break;
            }
        }
    }
    else {
        ZZChatViewController *controller = [[ZZChatViewController alloc] init];
        controller.isFromRentOrder = YES;
        [ZZRCUserInfoHelper setUserInfo:_user];
        controller.user = _user;
        controller.nickName = _user.nickname;
        controller.uid = isNullString(_user.uid) ? _user.uuid : _user.uid;
        controller.portraitUrl = _user.avatar;
        
        if (_order.wechat_service) {
            controller.shouldShowWeChat = YES;
        }
        
        [[ZZTabBarViewController sharedInstance] managerAppBadge];
        
        [self pushOrPop:YES controller:controller];
    }
}

- (void)goToPostTaskView {
    NSMutableDictionary *infoDic = @{
        @"skill":    _order.skill,
        @"city":    _order.city,
        @"hour":     @(_order.hours),
        @"date":    _order.dated_at,
        @"date_type": @(_order.dated_at_type),
        @"gender": @(_user.gender),
    }.mutableCopy;
    
    if (_addressModel) {
        infoDic[@"addressModel"] = _addressModel;
    }
    
    if (_order.selectDate) {
        infoDic[@"selectDate"] = _order.selectDate;
    }
    
    ZZPostTaskBasicInfoController *vc = [[ZZPostTaskBasicInfoController alloc] initTaskType:TaskNormal taskInfo:infoDic.copy];
    [self pushOrPop:YES controller:vc];
}

#pragma mark - Request
- (void)fetchTips {
    // /pd4/getOrderTip
    [ZZRequest method:@"GET" path:@"/api/pdCustomerService" params:@{@"oid" : _order.id} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error && data && [data isKindOfClass:[NSDictionary class]]) {
            _tipsDic = data;
            [_tableView reloadData];
        }
    }];
}

- (void)submitWechat:(NSString *)wechat {
    [ZZRequest method:@"POST" path:@"/api/savePdWechat" params:@{@"wechat": wechat, @"oid" : _order.id} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error) {
            _isSubmitWechat = YES;
            [ZZHUD showInfoWithStatus:@"提交成功"];
            [_tableView reloadData];
            [self gotoChatView];
        }
    }];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.tableView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15.0);
        make.top.equalTo(self.view).offset(isFullScreenDevice ? 44 : 33);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAVIGATIONBAR_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - getters and setters
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        _backBtn.normalImage = [UIImage imageNamed:@"icGuanbi"];
        _backBtn.selectedImage = [UIImage imageNamed:@"icGuanbi"];
        [_backBtn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"picBg"];
    }
    return _bgImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ZZRentPayCompleteChatCell class]
           forCellReuseIdentifier:[ZZRentPayCompleteChatCell cellIdentifier]];
        [_tableView registerClass:[ZZRentPayCompleteCreateTaskCell class]
        forCellReuseIdentifier:[ZZRentPayCompleteCreateTaskCell cellIdentifier]];
        [_tableView registerClass:[ZZRentOrderPayCompleteWeChatCell class]
        forCellReuseIdentifier:[ZZRentOrderPayCompleteWeChatCell cellIdentifier]];
    }
    return _tableView;
}

@end
