//
//  ZZRentOrderInfoViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderInfoViewController.h"
#import "ZZOrderLocationViewController.h"
#import "ZZRentAbroadLocationViewController.h"
#import "ZZSearchLocationController.h"
#import "ZZRentOrderPaymentViewController.h"

#import "ZZRentOrderHeaderView.h"
#import "ZZOrderCheckWeChatCell.h"
#import "ZZRentOrderSkillCell.h"
#import "ZZRentOrderTimeCell.h"
#import "ZZRentOrderLocationCell.h"
#import "ZZRentOrderPayCell.h"

#import "ZZDatePicker.h"
#import "ZZHoursPicker.h"
#import "ZZRentDropdownMenuView.h"
#import "ZZRentOrderPriceView.h"

#import "ZZOrder.h"
#import "ZZTasks.h"

@interface ZZRentOrderInfoViewController ()<UITableViewDataSource, UITableViewDelegate, ZZDatePickerDelegate, ZZHoursPickerDelegate, ZZRentDropdownMenuDelegate,ZZRentOrderLocationCellDelegate, ZZRentOrderPriceViewDelegate>

@property (nonatomic,   copy) NSArray<NSArray<NSNumber *> *> *tableViewCellTypes;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZZRentDropdownMenuView *dropdownView;

@property (nonatomic, strong) ZZRentOrderPriceView *priceView;

@property (strong, nonatomic) ZZRentDropdownModel *model;

@property (nonatomic, strong) UIButton *confirmEditBtn;

@end

@implementation ZZRentOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self defaultConfig];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    if (_order.hours != 0 && !_isEdit) {
       [self showPrice];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self hidePrice];
}

- (void)dealloc {

}

#pragma mark - private method
- (void)defaultConfig {
    if (!_isFromTask) {
        if (_isEdit) {
            self.navigationItem.title = @"修改信息";
        }
        else {
            self.navigationItem.title = _order.skill.name;
        }
    }
    
    ZZCacheOrder *cacheOrder = [ZZUserHelper shareInstance].cacheOrder;
    if (cacheOrder) {
        NSInteger interval = [[NSDate date] timeIntervalSinceDate:cacheOrder.currentDate];
        if (interval < 1800 && interval > 0) {
            if ([ZZUserHelper shareInstance].configModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no) {
                _order.isWechatServiceFromCached = YES;
                _order.wechat_service = cacheOrder.checkWeChat;
            }

            _order.hours = cacheOrder.hours;
            if ([cacheOrder.dated_at timeIntervalSinceDate:[NSDate date]] >= 3600*2) {
                _order.dated_at = cacheOrder.dated_at;
            } else {
                _order.dated_at = [[ZZDateHelper shareInstance] getNextHours:2];
            }
            if (cacheOrder.isQuickTime) {
                _order.dated_at_type = 1;
            } else {
                _order.dated_at_type = 0;
            }
            if (!isNullString(cacheOrder.city) && _order.city.name) {
                BOOL contain = NO;
                NSRange range = [_order.city.name rangeOfString:cacheOrder.city];
                if (range.location != NSNotFound) {
                    contain = YES;
                }
                range = [cacheOrder.city rangeOfString:_order.city.name];
                if (range.location != NSNotFound) {
                    contain = YES;
                }

                if (contain) {
                    _order.address = cacheOrder.address;
                    ZZRentDropdownModel *model = [[ZZRentDropdownModel alloc] init];
                    model.location = cacheOrder.loc;
                    model.name = cacheOrder.address;
                    model.city = cacheOrder.city;
                    _model = model;
                    ZZOrderLocation *orderLocation = [[ZZOrderLocation alloc] init];
                    orderLocation.lat = [NSString stringWithFormat:@"%f",cacheOrder.loc.coordinate.latitude];
                    orderLocation.lng = [NSString stringWithFormat:@"%f",cacheOrder.loc.coordinate.longitude];
                    _order.loc = orderLocation;
                }
            }
            
            if (cacheOrder.checkWeChat) {
                if ([ZZUserHelper shareInstance].configModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no) {
                    _order.wechat_service = cacheOrder.checkWeChat;
                }
            }
            else {
                _order.wechat_service = cacheOrder.checkWeChat;
            }
            
        }
    }
    
    [self createOrderCellTypes];
}

- (void)createOrderCellTypes {
    NSMutableArray *array = @[].mutableCopy;
    
    if (_isFromTask && _taskType == TaskFree) {
        [array addObject:@[
                           @(CellTypeStartTime),
                           @(CellTypeDuration),
                           @(CellTypeLocation)
                           ]];
    }
    else {
        [array addObject:@[
            @(CellTypeLocation),
            @(CellTypeStartTime),
            @(CellTypeDuration),
        ]];
    }
    self.tableViewCellTypes = array.copy;
}

- (void)getLocationModel:(ZZRentDropdownModel *)model {
    _order.address = model.name;
    ZZOrderLocation *orderLocation = [[ZZOrderLocation alloc] init];
    orderLocation.lat = [NSString stringWithFormat:@"%f",model.location.coordinate.latitude];
    orderLocation.lng = [NSString stringWithFormat:@"%f",model.location.coordinate.longitude];
    _order.loc = orderLocation;
    [self.tableView reloadData];
    _model = model;
}

//保存搜索过的地址
- (void)backupLocationArray {
    if (self.model) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ZZUserHelper shareInstance].locationArray];
        __block BOOL have = NO;
        [array enumerateObjectsUsingBlock:^(ZZRentDropdownModel *downModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([downModel.name isEqualToString:self.model.name]) {
                have = YES;
                *stop = YES;
            }
        }];
        if (!have) {
            if (array.count == 100) {
                [array removeLastObject];
            }
            [array insertObject:self.model atIndex:0];
        }
        [[ZZUserHelper shareInstance] setLocationArray:array];
    }
}

#pragma mark - response method
- (void)confirmEdit {
    [self editOrder];
}

#pragma mark - ZZRentOrderPriceViewDelegate
- (void)view:(ZZRentOrderPriceView *)view isSelectBestDeal:(BOOL)isSelectBestDeal {
    _order.wechat_service = isSelectBestDeal;
}

- (void)viewShowBestDetailProtocols:(ZZRentOrderPriceView *)view {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.youxiangOrderDetail;
    controller.isPush = YES;
    controller.isShowLeftButton = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)view:(ZZRentOrderPriceView *)view showPriceDetails:(BOOL)isSelectBestDeal {
    [self gotoAmountDetailView];
}

- (void)confirm:(ZZRentOrderPriceView *)view {
    if ([ZZUtils isConnecting]) {
        return;
    }
    
    if (!_order.hours) {
        return [ZZHUD showInfoWithStatus:@"请选择时长"];
    }
    if (!_order.dated_at) {
        return [ZZHUD showInfoWithStatus:@"请选择开始时间"];
    }
    if (!_order.address) {
        return [ZZHUD showInfoWithStatus:@"请选择地点"];
    }
    
    ZZRentOrderPaymentViewController *vc = [[ZZRentOrderPaymentViewController alloc] init];
    vc.order = _order;
    vc.isEdit = _isEdit;
    vc.taskType = _taskType;
    vc.fromChat = _fromChat;
    vc.isFromTask = _isFromTask;
    vc.taskModel = _taskModel;
    vc.addressModel = _model;
    vc.user = _user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ZZRentDropdownMenuDelegate
- (void)selectLocation:(ZZRentDropdownModel *)model {
    if (isNull(_order.city.name)) {
        [ZZHUD showErrorWithStatus:@"该用户城市名有误，请联系客服！"];
        return;
    }
    BOOL contain = NO;

    if (isNull(model.city)) {
        [ZZHUD showErrorWithStatus:@"该用户城市名有误，请联系客服！"];
        return;
    }
    NSRange range = [model.city rangeOfString:_order.city.name];
    if (range.location != NSNotFound) {
        contain = YES;
    }
    range = [_order.city.name rangeOfString:model.city];
    if (range.location != NSNotFound) {
        contain = YES;
    }
    if (!contain) {
        [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"出租地点请选择在%@内 ^_^",_order.city.name]];
        return;
    }
    _order.address = model.name;
    _model = model;
    ZZOrderLocation *orderLocation = [[ZZOrderLocation alloc] init];
    orderLocation.lat = [NSString stringWithFormat:@"%f",model.location.coordinate.latitude];
    orderLocation.lng = [NSString stringWithFormat:@"%f",model.location.coordinate.longitude];
    _order.loc = orderLocation;
    _model = model;
    [_tableView reloadData];
    [self hideRecommendLocationView];
}

#pragma mark - ZZRentOrderLocationCellDelegate
- (void)cellShowRecommendLocation:(ZZRentOrderLocationCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    CGRect rectInTable = [_tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSelfview = [_tableView convertRect:rectInTable toView:self.view];
    CGFloat cellY = rectInSelfview.origin.y + rectInSelfview.size.height;
    [self showOrHideRecommendLocationViewAt:cellY];
}

- (void)cellShowMap:(ZZRentOrderLocationCell *)cell {
    [self hideRecommendLocationView];
    if ((_isFromTask && _taskType == TaskFree)) {
       [self showLocation:_taskModel];
    }
    else {
        [self locationBtnClick];
    }
}

#pragma mark - ZZDatePickerDelegate
- (void)ZZDatePicker:(ZZDatePicker *)pickView didSelectedString:(NSString *)selectedSting selectDate:(NSString *)selectDate index:(NSInteger)index {
    _order.dated_at_type = pickView.showDate ? 0:1;
    _order.dated_at = [[ZZDateHelper shareInstance] getDateWithDateString:selectedSting];
    _order.selectDate = selectDate;
    _order.date_Des = selectedSting;
    [self.tableView reloadData];
}

#pragma mark - ZZHoursPickerDelegate
- (void)ZZHoursPicker:(ZZHoursPicker *)pickView didSelectedString:(NSString *)selectedSting index:(NSInteger)index {
    _order.hours = (int)index + 1;
    [self showPrice];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewCellTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewCellTypes[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCellType type = (OrderCellType)[self.tableViewCellTypes[indexPath.section][indexPath.row] integerValue];
    
    if (type == CellTypeContent) {
        ZZRentOrderSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentOrderSkillCell" forIndexPath:indexPath];
        if ((_isFromTask && _taskType == TaskFree)) {
            cell.titleLabel.text = _taskModel.task.skillModel.name;
        }
        else {
            cell.titleLabel.text = _order.skill.name;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (type == CellTypeStartTime || type == CellTypeDuration) {
        ZZRentOrderTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentOrderTimeCell" forIndexPath:indexPath];
        
        if ((_isFromTask && _taskType == TaskFree)) {
            [cell setTask:_taskModel indexPath:indexPath];
        }
        else {
            [cell setOrder:_order indexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (type == CellTypeLocation) {
        ZZRentOrderLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentOrderLocationCell" forIndexPath:indexPath];
        cell.delegate = self;
         if ((_isFromTask && _taskType == TaskFree)) {
             cell.task = _taskModel;
         }
         else {
             cell.order = _order;
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCellType type = (OrderCellType)[self.tableViewCellTypes[indexPath.section][indexPath.row] integerValue];
    if (_isFromTask && _taskType == TaskFree && (type == CellTypeContent || type == CellTypeStartTime)) {
        if (indexPath.section != 0) {
            // 有空不能修改信息
            [UIAlertController presentAlertControllerWithTitle:@"温馨提示" message:@"只能选择对方填写好的出租信息哦，或先与对方私信沟通，再进行邀约" doneTitle:@"知道了" cancelTitle:@"私信TA" completeBlock:^(BOOL isCancelled) {
                if (isCancelled) {
                    [self gotoChat:_taskModel.from];
                }
            }];
        }
        return;
    }

    if (type == CellTypeContent) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (type == CellTypeStartTime) {
        [MobClick event:Event_rent_choose_time];
        ZZDatePicker *datePicker = [[ZZDatePicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
        datePicker.delegate = self;
        [self.view.window addSubview:datePicker];
        if (_order.dated_at_type != 1 && _order.dated_at) {
            datePicker.showDate = YES;
        }
        [datePicker showDatePickerWithDate:_order.dated_at];
    }
    else if (type == CellTypeDuration) {
        [MobClick event:Event_rent_choose_hours];
        ZZHoursPicker *hourPicker= [[ZZHoursPicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        hourPicker.delegate = self;
        [self.view.window addSubview:hourPicker];
        [hourPicker showViews:_order.hours];
    }
    else if (type == CellTypeLocation) {
       if ((_isFromTask && _taskType == TaskFree)) {
           [self showLocation:_taskModel];
        }
        else {
            [self locationBtnClick];
        }
    }
}

#pragma mark - Request


#pragma mark - Navigator
- (void)showLocation:(ZZTaskModel *)task {
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:task.task.address_lat longitude:task.task.address_lng];
    controller.location = location;
    controller.name = [NSString stringWithFormat:@"%@%@",task.task.city_name, task.task.address];
    controller.navigationItem.title = @"邀约地点";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)locationBtnClick {
    if (!_order.city.name) {
        [ZZHUD showErrorWithStatus:@"该用户城市名有误，请联系客服！"];
        return;
    }
    [MobClick event:Event_rent_choose_location];
//    [self touchMyTableView];
    if ([ZZUserHelper shareInstance].isAbroad) {
        ZZRentAbroadLocationViewController *controller = [[ZZRentAbroadLocationViewController alloc] init];
        controller.currentSelectCity = _order.city;
        controller.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [self getLocationModel:model];
        };
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        ZZSearchLocationController *vc = [[ZZSearchLocationController alloc] initWithSelectCity:_order.city];
        vc.isCityLimited = YES;
        vc.title = @"选择邀约地点";
        vc.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [self getLocationModel:model];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)gotoAmountDetailView {
    if (![ZZUserHelper shareInstance].configModel.yj) {
        return;
    }
    
    CGFloat total = [_order pureTotalPrice];
    if (_order.wechat_service) {
        total += _order.wechat_price;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/order/price_detail/page?total_price=%.2f&&access_token=%@",kBase_URL,total,[ZZUserHelper shareInstance].oAuthToken];
   
    if (_order.wechat_service) {
        urlString = [NSString stringWithFormat:@"%@&wechat_service=true",urlString];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@&xdf_price=%@",urlString, _order.xdf_price];
    }
    
    if (_isEdit) {
        urlString = [NSString stringWithFormat:@"%@&&oid=%@",urlString,_order.id];
    }
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.navigationItem.title = @"价格详情";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoChat:(ZZUser *)user {
    ZZChatViewController *chatController = [[ZZChatViewController alloc] init];
    chatController.nickName = user.nickname;
    chatController.uid = user.uid;
    chatController.portraitUrl = user.avatar;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)gotoChatView {
    [ZZUserHelper shareInstance].unreadModel.order_ongoing_count++;
    
//    if (!(_isFromTask && _taskType == TaskFree)) {
//        [self savePayMethod];
//        [self backupOrder];
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_fromChat) {
            for (UIViewController *ctl in self.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[ZZChatViewController class]]) {
                    if (_callBack) {
                        _callBack();
                    }
                    [self.navigationController popToViewController:ctl animated:YES];
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
            [self.navigationController pushViewController:controller animated:YES];
            
            if (_order.wechat_service) {
                controller.shouldShowWeChat = YES;
            }
            
            [[ZZTabBarViewController sharedInstance] managerAppBadge];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            NSInteger index = array.count - 2;
            if (array.count > index) {
                [array removeObjectAtIndex:(array.count - 2)];
                [array removeObjectAtIndex:(array.count - 2)];
            }
            self.navigationController.viewControllers = array;
        }
    });
}

- (void)editOrder {
    [ZZHUD showWithStatus:@"正在修改.."];
    _confirmEditBtn.enabled = NO;
    [_order update:^(ZZError *error, id data, NSURLSessionDataTask *task) {
         _confirmEditBtn.enabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateOrder object:self userInfo:data];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OrderStatusChante object:nil];
            }];
            
            [self backupLocationArray];
        }
    }];
}

#pragma mark - Layout
- (void)layout {
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (_isEdit) {
        [self.view addSubview:self.confirmEditBtn];
        [_confirmEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15.0);
            } else {
                make.bottom.equalTo(self.view).offset(-15.0);
            }
            make.left.equalTo(self.view).offset(15.0);
            make.right.equalTo(self.view).offset(-15.0);
            make.height.equalTo(@50.0);
        }];
    }
}

- (void)showOrHideRecommendLocationViewAt:(CGFloat)frameY {
    if (!_dropdownView) {
        _dropdownView = [[ZZRentDropdownMenuView alloc] initWithFrame:CGRectMake(0, frameY, SCREEN_WIDTH, SCREEN_HEIGHT - frameY) user:_user];
        _dropdownView.delegate = self;
        [self.view addSubview:_dropdownView];
    }
    else {
        [_dropdownView removeFromSuperview];
        _dropdownView = nil;
    }
}

- (void)hideRecommendLocationView {
    [_dropdownView removeFromSuperview];
    _dropdownView = nil;
}

- (void)showPrice {
    if (!_isEdit && !_isFromTask) {
        if (_order.hours == 0) {
            return;
        }
        
        if (!_priceView) {
            [self.view addSubview:self.priceView];
            if (_order.wechat_service) {
                if ([ZZUserHelper shareInstance].configModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no) {
                    _order.wechat_service = YES;
                }
                else {
                    _order.wechat_service = NO;
                }
            }
            else {
                if (!_order.isWechatServiceFromCached) {
                    if ([ZZUserHelper shareInstance].configModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no) {
                        _order.wechat_service = YES;
                    }
                    else {
                        _order.wechat_service = NO;
                    }
                }
            }
            [_priceView changeCurrentSelection: _order.wechat_service ? RentPriceOptionTypeBest : RentPriceOptionTypeNormal shouldShowProtocol:NO isTheFirstTime:YES];
            
            _priceView.frame = CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, _priceView.totalHeight);
            
            [UIView animateWithDuration:0.3 animations:^{
                _priceView.top = self.view.height - _priceView.height - (self.view.top == 0 ? 64 : 0);
            } completion:nil];
        }
        _priceView.order = _order;
        return;
    }
}

- (void)hidePrice {
    if (!_priceView) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _priceView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [_priceView removeFromSuperview];
        _priceView = nil;
    }];
}

#pragma mark - getters and setters
- (void)setTaskModel:(ZZTaskModel *)taskModel {
    _taskModel = taskModel;
    if (_isFromTask && _taskType == TaskFree) {
        _order = [[ZZOrder alloc] init];
        _order.to = _taskModel.from;
        _order.totalPrice = @([_taskModel.task.price doubleValue]);
        _order.price = @([_taskModel.task.price doubleValue]);
        _order.hours = (int)_taskModel.task.hours;
        ZZCity *city =[[ZZCity alloc] init];
        city.cityId = _taskModel.task.cityId;
        _order.city = city;
        _order.address = _taskModel.task.address;
        _order.dated_at = [[ZZDateHelper shareInstance] getDetailDataWithDateString:[ZZDateHelper localTime:_taskModel.task.dated_at]];
        _order.dated_at_type = 0;
        ZZOrderLocation *location = [[ZZOrderLocation alloc] init];
        location.lat = [NSString stringWithFormat:@"%f",_taskModel.task.address_lat];
        location.lng = [NSString stringWithFormat:@"%f",_taskModel.task.address_lng];
        _order.loc = location;
        _order.skill = _taskModel.task.skillModel;
        _user = _taskModel.from;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 61.5;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(247, 247, 247);
        
        ZZRentOrderHeaderView *headerView = [[ZZRentOrderHeaderView alloc] init];
        headerView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 87.5);
        headerView.titleLabel.text = @"预约信息";
        headerView.subTitleLabel.text = @"预约需要支付一定的意向金，对方接受后，方可支付全款。款项将由平台全程担保，预约不成功，意向金将按规则返还。";
        _tableView.tableHeaderView = headerView;
        
        [_tableView registerClass:[ZZOrderCheckWeChatCell class]
           forCellReuseIdentifier:[ZZOrderCheckWeChatCell cellIdentifier]];
        [_tableView registerClass:[ZZRentOrderSkillCell class]
           forCellReuseIdentifier:@"ZZRentOrderSkillCell"];
        [_tableView registerClass:[ZZRentOrderTimeCell class]
           forCellReuseIdentifier:@"ZZRentOrderTimeCell"];
        [_tableView registerClass:[ZZRentOrderLocationCell class]
           forCellReuseIdentifier:@"ZZRentOrderLocationCell"];
    }
    return _tableView;
}

- (ZZRentOrderPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[ZZRentOrderPriceView alloc] initWithUser:_user];
        _priceView.order = _order;
        _priceView.delegate = self;
    }
    return _priceView;
}

- (UIButton *)confirmEditBtn {
    if (!_confirmEditBtn) {
        _confirmEditBtn = [[UIButton alloc] init];
        _confirmEditBtn.normalTitle = @"确认修改信息";
        _confirmEditBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _confirmEditBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _confirmEditBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_confirmEditBtn addTarget:self action:@selector(confirmEdit) forControlEvents:UIControlEventTouchUpInside];
        _confirmEditBtn.layer.cornerRadius = 25.0;
    }
    return _confirmEditBtn;
}

@end
