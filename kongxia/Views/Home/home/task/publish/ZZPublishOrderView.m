//
//  ZZPublishOrderView.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishOrderView.h"
#import "ZZLinkWebViewController.h"

#import "ZZPublishOrderTaskCell.h"
#import "ZZPublishOrderSexCell.h"
#import "ZZPublishOrderExpandSwitchCell.h"
#import "ZZPublishOrderNormalCell.h"
#import "ZZPublishOrderLocationView.h"
#import "WBActionContainerView.h"
#import "ZZTaskChooseViewController.h"

#import "ZZPublishLocationModel.h"
#import "ZZDateHelper.h"
#import "ZZRentAbroadLocationViewController.h"
#import "ZZSearchLocationController.h"

@interface ZZPublishOrderView () <UITableViewDelegate,UITableViewDataSource,ZZTaskTimeViewDelegate,ZZTaskMoneyInputVieDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZPublishOrderLocationView *locationView;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSMutableDictionary *selectionDict;
@property (nonatomic, copy) NSString *selectDate;
@property (nonatomic, copy) NSString *isExpand; // 是否自动扩充 1自动扩充 0不自动扩充

@property (nonatomic, assign) BOOL allDismiss;//是否需要dismiss全部窗口
@property (nonatomic, strong) WBActionContainerView *presentSlider;

@end

@implementation ZZPublishOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%p is dealloc", NSStringFromClass([self class]));
}

- (void)getLocationData
{
    if (self.locationView.locationsArray) {
        [self.locationView show:_location];
    } else {
        [ZZRequest method:@"GET" path:@"/province/list" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                NSMutableArray *array = [ZZPublishLocationModel arrayOfModelsFromDictionaries:data error:nil];
                self.locationView.locationsArray = array;
                [self.locationView show:_location];
            }
        }];
    }
}

- (void)setSkill:(ZZSkill *)skill
{
    _skill = skill;
    [self.tableView reloadData];
    
    [self.param setObject:skill.id forKey:@"skill_id"];
    if (skill.type == 1) {
        [self.param setObject:[NSNumber numberWithInteger:3] forKey:@"type"];
    } else if (skill.type == 2) {
        [self.param setObject:[NSNumber numberWithInteger:2] forKey:@"type"];
    }
}

- (void)setLocationModel:(ZZRentDropdownModel *)locationModel
{
    _locationModel = locationModel;
    [self.param setObject:locationModel.name forKey:@"address"];
    if (!isNullString(locationModel.city)) {
        [self.param setObject:locationModel.city forKey:@"city_name"];
    }
    if (locationModel.location) {
        [self.param setObject:[NSNumber numberWithFloat:locationModel.location.coordinate.longitude] forKey:@"address_lng"];
        [self.param setObject:[NSNumber numberWithFloat:locationModel.location.coordinate.latitude] forKey:@"address_lat"];
    }
    [self.tableView reloadData];
}

- (UIView *)createTableViewHeaderView {
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bgWhiteView = [UIView new];
    bgWhiteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
    bgWhiteView.backgroundColor = [UIColor whiteColor];
    [view addSubview:bgWhiteView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgWhiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bgWhiteView.bounds;
    maskLayer.path = maskPath.CGPath;
    bgWhiteView.layer.mask = maskLayer;
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [dismissBtn setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dismissBtn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = kLineViewColor;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineViewColor;

    [bgWhiteView addSubview:dismissBtn];
    [bgWhiteView addSubview:lineView];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.leading.equalTo(@15);
        make.height.equalTo(@54);
        make.width.equalTo(@35);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@0.5);
    }];
    return view;
}

- (IBAction)dismissClick:(id)sender {
    BLOCK_SAFE_CALLS(self.dismissBlock);
}

#pragma mark - UITabelViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _skill.type == 2 ? 3 + ([_location isEqualToString:self.locationView.noLimitStr] ? 0 : 1) : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    switch (indexPath.row) {
        case 0: {
            ZZPublishOrderTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task"];
            [cell setData:_skill];
            return cell;
            break;
        }
        case 1: {
            ZZPublishOrderSexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sex"];
            cell.selectedIndex = ^(NSInteger index) {
                [weakSelf.param setObject:[NSNumber numberWithInteger:index] forKey:@"gender"];
            };
            cell.gender = [[self.param objectForKey:@"gender"] integerValue];
            if (_skill.type) {
                cell.imgView.image = [UIImage imageNamed:@"icon_task_sex_p"];
                cell.contentView.userInteractionEnabled = YES;
            } else {
                cell.imgView.image = [UIImage imageNamed:@"icon_task_sex_n"];
                cell.contentView.userInteractionEnabled = NO;
            }
            return cell;
            break;
        }
        default: {
            if (_skill.type == 2 && indexPath.row == 3 && ![_location isEqualToString:self.locationView.noLimitStr]) {
                // 专门增加一个 是否扩充选项cell
                ZZPublishOrderExpandSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZPublishOrderExpandSwitchCell reuseIdentifier] forIndexPath:indexPath];
                
                [_param setObject:cell.isExpand forKey:@"expand_auto"];
                [cell setExpandSwitchBlock:^(NSString *isExpand){
                    [weakSelf.param setObject:isExpand forKey:@"expand_auto"];
                }];
                return cell;
            } else {
                ZZPublishOrderNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
                [cell setData:indexPath skill:_skill param:self.param];
                
                if (indexPath.row == 3) {
                    NSString *dateString = nil;
                    if ([_selectDate isEqualToString:@"尽快"]) {
//                        dateString = @"半小时后";
//                        cell.contentLabel.text = dateString;
                        NSDate *date = [[NSDate new] initWithTimeIntervalSinceNow:30 * 60];
                        [self.param setObject:[[ZZDateHelper shareInstance] getDateStringWithDate:date] forKey:@"dated_at"];
                        cell.contentLabel.text = [NSString stringWithFormat:@"尽快, %@之前", [[ZZDateHelper shareInstance] getDetailDateStringWithDate:date]];
                        
                    } else if ([_selectDate isEqualToString:@"今天"] || [_selectDate isEqualToString:@"明天"] || [_selectDate isEqualToString:@"后天"]) {
                        // 日期文案
                        dateString = _selectDate;
                        // 时间
                        NSString *timeString = @"";
                        NSDate *date = [[ZZDateHelper shareInstance] getDateWithDateString:[self.param objectForKey:@"dated_at"]];
                        if (date) {
                            timeString = [[ZZDateHelper shareInstance] getDetailDateStringWithDate:date];
                        }
                        // 小时
                        NSString *hourString = [NSString stringWithFormat:@"%@小时",[self.param objectForKey:@"hours"]];
                        
                        NSString *sumString = [NSString stringWithFormat:@"%@ %@,%@",dateString,timeString,hourString];
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sumString];
                        [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:[sumString rangeOfString:hourString]];
                        cell.contentLabel.attributedText = attributedString;
                    }
                }
                return cell;
            }
            return nil;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_skill.type == 2) {
            return 90;
        } else {
            return 55;
        }
    } else if (indexPath.row == 1) {
        return 74;
    } else{
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat ruleHeight = 134 * (SCREEN_WIDTH /375.0);
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 188 + 10 + ruleHeight + 5)];
    footView.backgroundColor = [UIColor whiteColor];
    
    [footView addSubview:self.publishView];
    if ([[self.param objectForKey:@"is_anonymous"] integerValue] == 1) {
        self.publishView.isAnonymous = NO;
    } else {
        self.publishView.isAnonymous = YES;
    }
    
    UIImageView *ruleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 188+10, SCREEN_WIDTH, ruleHeight)];
    ruleImgView.image = [UIImage imageNamed:@"icon_livestream_rule"];
    [footView addSubview:ruleImgView];
    ruleImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleBtnClick:)];
    [ruleImgView addGestureRecognizer:recognizer];
    
//    ruleImgView.hidden = [ZZUserHelper shareInstance].configModel.hide_see_wechat;
    ruleImgView.hidden = YES;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 1V1视频规则
    return 188 + 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
//            if (_touchTaskChoose) {
//                _touchTaskChoose();
//            }
            BLOCK_SAFE_CALLS(self.dismissBlock);//外部先收回
            [self showTaskChooseIsAllDismiss:NO];
        }
            break;
        case 1:
        {
            if (!_skill) {
                [self animateCell:0];
            }
        }
            break;
        case 2:
        {
            if (_skill) {
                if (_skill.type == 1) {
//                    if (_touchLocation) {
//                        _touchLocation();
//                    }
                    [self gotoLocationView];
                } else {
                    [self getLocationData];
                }
            } else {
                [self animateCell:0];
            }
        }
            break;
        case 3:
        {
            if (_skill.type == 2) {
                // 线上的没有点击事件(自动扩充cell不需要点击)
                return;
            }
            if (_skill) {
                _timeView = [[ZZTaskTimeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _timeView.delegate = self;
                [self.window addSubview:_timeView];
                NSString *dateString = [self.param objectForKey:@"dated_at"];
                NSInteger hour = [[self.param objectForKey:@"hours"] integerValue];
                if (!isNullString(dateString)) {
                    NSDate *date = [[ZZDateHelper shareInstance] getDateWithDateString:dateString];
                    _timeView.showDate = YES;
                    [_timeView showDatePickerWithDate:date hour:hour?hour:1];
                } else {
                    [_timeView showDatePickerWithDate:nil hour:hour?hour:1];
                }
            } else {
                [self animateCell:0];
            }
        }
            break;
        case 4:
        {
            if (_skill) {
                [self showMoneyInputView];
            } else {
                [self animateCell:0];
            }
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

- (void)publishBtnClick
{
    if (!_skill) {
//        [ZZHUD showErrorWithStatus:@"请选择任务"];
        [self animateCell:0];
        return;
    }
    if (_skill.type == 1) {
        NSInteger hour = [[self.param objectForKey:@"hours"] integerValue];
        if (![self.param objectForKey:@"address"]) {
            [self animateCell:2];
            return;
        }
        if (hour == 0) {
            [self animateCell:3];
            return;
        }
        if (![self.param objectForKey:@"price"]) {
            [self animateCell:4];
            return;
        }
        
        NSString *date = [self.param objectForKey:@"dated_at"];
        NSDate *taskDate = [[ZZDateHelper shareInstance] getDateWithDateString:date];
        if (!isNullString(date) && [taskDate compare:[NSDate date]] == NSOrderedAscending) {
            [ZZHUD showErrorWithStatus:@"时间已过时，请重新选择"];
            return;
        }
    }
    if (_touchPublish) {
        _touchPublish();
    }
}

- (void)animateCell:(NSInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:20 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
}

- (void)managerLocation
{
    if ([_location isEqualToString:self.locationView.noLimitStr]) {
        // 不限地区
        [_param setObject:@"3" forKey:@"region"];
        // 自动扩充
        _isExpand = @"1";
        [_param setObject:_isExpand forKey:@"expand_auto"];
    } else if ([_location isEqualToString:self.locationView.nearStr]) {
        // 附近
        [_param setObject:@"2" forKey:@"region"];
        
    } else {
        // 市
        [_param setObject:_location forKey:@"region"];
    }
}

- (void)ruleBtnClick:(UITapGestureRecognizer *)recognizer
{
    recognizer.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        recognizer.view.userInteractionEnabled = YES;
    });
    if (_touchRule) {
        _touchRule();
    }
}

#pragma mark - ZZTaskTimeViewDelegate

- (void)timeView:(ZZTaskTimeView *)timeView didSelectedString:(NSString *)selectedSting hour:(NSInteger)hour selectDate:(NSString *)selectDate
{
    _selectDate = selectDate;
    if ([[self.param objectForKey:@"hour"] integerValue] != hour) {
        NSInteger minPrice = 100 + 50*(hour - 1);
        if ([ZZUtils compareWithValue1:[NSNumber numberWithInteger:minPrice] value2:[self.param objectForKey:@"price"]] == NSOrderedDescending) {
            [self.param removeObjectForKey:@"price"];
        }
    }
    //1 尽快
    NSInteger type = timeView.showDate ? 0 : 1;
    if (timeView.showDate) {
        [self.param setObject:selectedSting forKey:@"dated_at"];
    } else {
        [self.param removeObjectForKey:@"dated_at"];
    }
    [self.param setObject:[NSNumber numberWithInteger:type] forKey:@"dated_at_type"];
    [self.param setObject:[NSNumber numberWithInteger:hour] forKey:@"hours"];
    [self.tableView reloadData];
    
    if (![self.param objectForKey:@"price"]) {
        [self showMoneyInputView];
    }
}

- (void)showMoneyInputView
{
    _inputView = [[ZZTaskMoneyInputView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _inputView.delegate = self;
    [self.window addSubview:_inputView];
    [_inputView.textField becomeFirstResponder];
    _inputView.textField.text = [self.param objectForKey:@"price"];
    _inputView.hour = [[self.param objectForKey:@"hours"] integerValue];
}

// 选择任务
- (void)showTaskChooseIsAllDismiss:(BOOL)dismiss {
    _allDismiss = dismiss;
    
    [self.presentSlider present];
}

- (void)gotoLocationView {
    
    WEAK_SELF();
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    if ([ZZUserHelper shareInstance].isAbroad) {
        ZZRentAbroadLocationViewController *controller = [[ZZRentAbroadLocationViewController alloc] init];
        controller.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [weakSelf getAddress:model];
            [NSObject asyncWaitingWithTime:0.7 completeBlock:^{
                BLOCK_SAFE_CALLS(weakSelf.presentBlock);
            }];
        };
        controller.hidesBottomBarWhenPushed = YES;
        BLOCK_SAFE_CALLS(weakSelf.dismissBlock);
        [nav pushViewController:controller animated:YES];
    } else {
        
        ZZSearchLocationController *vc = [[ZZSearchLocationController alloc] init];
        vc.title = @"选择通告地点";
        vc.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [weakSelf getAddress:model];
            [NSObject asyncWaitingWithTime:0.7 completeBlock:^{
                BLOCK_SAFE_CALLS(weakSelf.presentBlock);
            }];
        };
        [vc setPresentBlock:^{
            [NSObject asyncWaitingWithTime:0.7 completeBlock:^{
                BLOCK_SAFE_CALLS(weakSelf.presentBlock);
            }];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        BLOCK_SAFE_CALLS(weakSelf.dismissBlock);
        [nav pushViewController:vc animated:YES];

    }
}

- (void)getAddress:(ZZRentDropdownModel *)model
{
    self.locationModel = model;
}

#pragma mark - ZZTaskMoneyInputVieDelegate

- (void)inputView:(ZZTaskMoneyInputView *)inputView price:(NSString *)price
{
    [self.param setObject:price forKey:@"price"];
    [self.tableView reloadData];
}

#pragma mark - layload

- (UITableView *)tableView
{
    if (!_tableView) {
        
        UIView *headerView = [self createTableViewHeaderView];
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(@0);
            make.height.equalTo(@54);
        }];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = kBGColor;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@54);
            make.leading.trailing.bottom.equalTo(@0);
        }];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.randomColor;
        [_tableView registerClass:[ZZPublishOrderTaskCell class] forCellReuseIdentifier:@"task"];
        [_tableView registerClass:[ZZPublishOrderSexCell class] forCellReuseIdentifier:@"sex"];
        [_tableView registerClass:[ZZPublishOrderNormalCell class] forCellReuseIdentifier:@"normal"];
        [_tableView registerClass:[ZZPublishOrderExpandSwitchCell class] forCellReuseIdentifier:[ZZPublishOrderExpandSwitchCell reuseIdentifier]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.alwaysBounceVertical = NO;
//        _tableView.bounces = NO;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
            make.top.equalTo(@54);
            make.leading.trailing.bottom.equalTo(@0);
        }];
    }
    return _tableView;
}

- (ZZPublishOrderPublishView *)publishView
{
    WeakSelf;
    if (!_publishView) {
        _publishView = [[ZZPublishOrderPublishView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 188)];
        _publishView.touchPublish = ^{
            NSLog(@"PY_发布任务");
            [weakSelf publishBtnClick];
        };
        _publishView.touchAnonymous = ^{
            NSInteger value = weakSelf.publishView.isAnonymous ?2:1;
            [weakSelf.param setObject:[NSNumber numberWithInteger:value] forKey:@"is_anonymous"];
        };
    }
    return _publishView;
}

- (NSMutableDictionary *)param
{
    if (!_param) {
        NSDictionary *aDict = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].publishSelections];
        if (aDict) {
            _param = [NSMutableDictionary dictionaryWithDictionary:aDict];
            [_param removeObjectForKey:@"skill_id"];
            [_param removeObjectForKey:@"address"];
            [_param removeObjectForKey:@"address_lng"];
            [_param removeObjectForKey:@"address_lat"];
            [_param removeObjectForKey:@"city_name"];
            [_param removeObjectForKey:@"dated_at"];
            [_param removeObjectForKey:@"dated_at_type"];
            [_param removeObjectForKey:@"hours"];
            [_param removeObjectForKey:@"price"];
        } else {
            _param = [NSMutableDictionary dictionaryWithDictionary:@{@"skill_id":@"59644d1d2f17ad7a5f145544",
                                                                     @"type":[NSNumber numberWithInteger:2],
                                                                     @"gender":[NSNumber numberWithInteger:2],
                                                                     @"region":@"3",
                                                                     @"is_anonymous":[NSNumber numberWithInteger:1]}];
        }
        NSString *location = [_param objectForKey:@"region"];
        if ([location isEqualToString:@"2"]) {
            _location = self.locationView.nearStr;
        } else if ([location isEqualToString:@"3"]) {
            _location = self.locationView.noLimitStr;
        } else {
            _location = location;
        }
        
        [_param setObject:@"1" forKey:@"expand_auto"];  // 默认自动扩充
    }
    return _param;
}

- (NSMutableDictionary *)selectionDict
{
    if (!_selectionDict) {
        _selectionDict = [NSMutableDictionary dictionary];
    }
    return _selectionDict;
}

- (ZZPublishOrderLocationView *)locationView
{
    WeakSelf;
    if (!_locationView) {
        _locationView = [[ZZPublishOrderLocationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _locationView.chooseTime = ^(NSString *showString) {
            weakSelf.location = showString;
            [weakSelf managerLocation];
            [weakSelf.tableView reloadData];
        };
    }
    return _locationView;
}

- (WBActionContainerView *)presentSlider {
    if (!_presentSlider) {
        WEAK_SELF();
//        NSString *skillId = _publishView.skill.id;
        ZZTaskChooseViewController *controller = [[ZZTaskChooseViewController alloc] init];
        controller.view.frame = self.frame;
        controller.skillId = nil;
        controller.hidesBottomBarWhenPushed = YES;
        controller.selectedTask = ^(ZZSkill *skill) {
            weakSelf.skill = skill;
            [weakSelf.presentSlider dismiss];
            [NSObject asyncWaitingWithTime:0.4 completeBlock:^{
                BLOCK_SAFE_CALLS(weakSelf.presentBlock);
            }];
        };
        [controller setDismissBlock:^{
            [weakSelf.presentSlider dismiss];
            if (_allDismiss) {
                BLOCK_SAFE_CALLS(weakSelf.dismissBlock);
            } else {
                [NSObject asyncWaitingWithTime:0.4 completeBlock:^{
                    BLOCK_SAFE_CALLS(weakSelf.presentBlock);
                }];
            }
        }];
        
        CGFloat height = SCALE_SET(700);
        if (isIPhoneX) {
            height = SCALE_SET(850);
        }
        else if (isIPhoneXsMax) {
            height = SCALE_SET(950);
        }
        _presentSlider = [[WBActionContainerView alloc] initWithViewController:controller forHeight:height];
    }
    return _presentSlider;
}

@end
