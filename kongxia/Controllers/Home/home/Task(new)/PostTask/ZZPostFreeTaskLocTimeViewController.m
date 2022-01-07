//
//  ZZPostFreeTaskLocTimeViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/9/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostFreeTaskLocTimeViewController.h"
#import "ZZRentAbroadLocationViewController.h"
#import "ZZSearchLocationController.h"

#import "ZZTimeSelector.h"
#import "ZZTaskTimeView.h"
#import "ZZPostTaskRulesToastView.h"

#import "ZZTimeSelectorModel.h"
#import "ZZPostTaskViewModel.h"

@interface ZZPostFreeTaskLocTimeViewController () <ZZPostTaskViewModelDelegate, ZZTimeSelectorDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *proceedBtn;

@end

@implementation ZZPostFreeTaskLocTimeViewController

- (instancetype)initWithViewModel:(ZZPostTaskViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善活动信息";
    [self layout];
    [_viewModel configTableView:self.tableview];
}

- (void)dealloc {
    NSLog(@"ZZPostFreeTaskLocTimeViewController is dealloced");
}

#pragma mark - private method
- (void)getAddress:(ZZRentDropdownModel *)model{
    [_viewModel chooseLocation:model];
}

#pragma mark - response method
- (void)navigationLeftBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didSelectedLocation:startTime:startTimeDescript:durationDes:didAgreed:)]) {
        [self.delegate controller:self didSelectedLocation:_viewModel.location startTime:_viewModel.startTime startTimeDescript:_viewModel.startTimeDescript durationDes:_viewModel.durantionDes didAgreed:_viewModel.didAgreed];
    }
    [super navigationLeftBtnClick];
}

- (void)proceed {
    // 必须要有地点
    if (!_viewModel.location || isNullString(_viewModel.location.name)) {
        [ZZHUD showErrorWithStatus:@"请选择地点"];
        return;
    }
    
    // 必须要有时长
    if (isNullString(_viewModel.startTime) || isNullString(_viewModel.durantionDes)) {
        [ZZHUD showErrorWithStatus:@"请选择时间"];
        return;
    }
    
    if (isNullString(_viewModel.location.name) || !_viewModel.location.location) {
        [ZZHUD showErrorWithStatus:@"地点有误,请重新选择"];
        return;
    }
    
    // 必须要同意规则才能发布
    if (!_viewModel.didAgreed) {
        [ZZHUD showErrorWithStatus:@"请先同意发布规则, 才能发布活动"];
        return;
    }
    
    [_viewModel confirm];
}

#pragma mark - ZZPostTaskViewModelDelegate
// 具体位置
- (void)showLocationView:(ZZPostTaskViewModel *)model {
    [self goToLocationView];
}

/*
    显示选择时间view
 */
- (void)chooseTime:(ZZPostTaskViewModel *)model {
    [self showTimeChooseView:postTime];
}

/*
 显示发布规则
 */
- (void)showRules:(ZZPostTaskViewModel *)model {
    if (_viewModel.taskType == TaskFree) {
        [ZZPostTaskRulesToastView showWithRulesType:RulesTypePostActivity];
    }
    else {
       [ZZPostTaskRulesToastView showWithRulesType:RulesTypePostTask];
    }
}

- (void)taskFreePublished:(ZZPostTaskViewModel *)model {
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    [vcs removeLastObject];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [self.navigationController setViewControllers:vcs.copy animated:YES];
    
    if (![vcs.lastObject isKindOfClass:[ZZTasksViewController class]] && ![vcs.lastObject isKindOfClass:[ZZTaskListViewController class]]) {
        ZZTasksViewController *viewController = [[ZZTasksViewController alloc] initWithTaskType:_viewModel.taskType];
        viewController.hidesBottomBarWhenPushed = YES;
        if (_viewModel.taskType == TaskFree) {
            viewController.taskFreeJumpToMyList = YES;
        }
        [vcs addObject:viewController];
    }
    else if ([vcs.lastObject isKindOfClass:[ZZTasksViewController class]]) {
        ZZTasksViewController *listVC = (ZZTasksViewController *)vcs.lastObject;
        if (_viewModel.taskType == TaskFree) {
            listVC.taskFreeJumpToMyList = YES;
        }
    }
    [self.navigationController setViewControllers:vcs.copy animated:YES];
}

#pragma mark - ZZTimeSelectorDelegate
/*
    通告选择时间
 */
- (void)timeView:(ZZTimeSelector *)timeView time:(ZZTimeSelectorModel *)timeModel duration:(NSInteger)duration {
    [_viewModel starTime:timeModel.timeDesc startDescript:timeModel.dayDesc durantion:duration];
    [self showTimeChooseView:postDuration];
}

/*
 通告选择时长
 */
- (void)timeView:(ZZTimeSelector *)timeView chooseDuration:(NSInteger)duration {
    [_viewModel configureDuration:duration];
}

/*
    活动选择时间
 */
- (void)timeView:(ZZTimeSelector *)timeView time:(ZZTimeSelectorModel *)timeModel durationDes:(NSString *)durationDes {
    [_viewModel starTime:timeModel.day startDescript:timeModel.dayDesc durationDes:durationDes];
}

#pragma mark - ZZTaskTimeViewDelegate
- (void)timeView:(ZZTaskTimeView *)timeView didSelectedString:(NSString *)selectedSting hour:(NSInteger)hour selectDate:(NSString *)selectDate {
    [_viewModel starTime:selectedSting startDescript:selectDate durantion:hour];
}

#pragma mark - Navigator

/*
 跳转到Location
 */
- (void)goToLocationView {
    WEAK_SELF();
    if ([ZZUserHelper shareInstance].isAbroad) {
        // 海外
        ZZRentAbroadLocationViewController *controller = [[ZZRentAbroadLocationViewController alloc] init];
        controller.currentSelectCity = _viewModel.city;
        if (_viewModel.taskType == TaskFree) {
            controller.isFromTaskFree = YES;
        }
        controller.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [weakSelf getAddress:model];
        };
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        // 国内
        ZZSearchLocationController *vc = [[ZZSearchLocationController alloc] initWithSelectCity:_viewModel.taskType == TaskNormal ? nil :_viewModel.city];
        if (_viewModel.taskType == TaskNormal) {
            vc.title = @"选择通告地点";
        }
        else {
            vc.title = @"选择邀约地点";
            vc.isFromTaskFree = YES;
        }
        vc.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [weakSelf getAddress:model];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
 时间
 */
- (void)showTimeChooseView:(PostTaskItemType)timeType {
    ZZTimeSelector *timeView = [[ZZTimeSelector alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) taskType:_viewModel.taskType timeType:timeType];
    timeView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:timeView];
    if (_viewModel.taskType == TaskNormal) {
        if (timeType == postTime) {
            [timeView showDate:_viewModel.startTime dateDesc:_viewModel.startTimeDescript duration:_viewModel.durantion];
        }
        else if (timeType == postDuration) {
            [timeView showDurations:_viewModel.durantion];
        }
    }
    else {
        [timeView showDate:_viewModel.startTime dateDesc:_viewModel.startTimeDescript duratioDes:_viewModel.durantionDes];
    }
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.proceedBtn];
    
    [_proceedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0);
        make.right.equalTo(self.view).offset(-15.0);
        make.height.equalTo(@50.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15.0);
        } else {
            make.bottom.equalTo(self.view).offset(-15.0);
        }
    }];
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(_proceedBtn.mas_top);
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
    }
    return _tableview;
}

- (UIButton *)proceedBtn {
    if (!_proceedBtn) {
        _proceedBtn = [[UIButton alloc] init];
        _proceedBtn.normalTitle = @"立刻发布";
        [_proceedBtn addTarget:self action:@selector(proceed) forControlEvents:UIControlEventTouchUpInside];
        _proceedBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _proceedBtn.titleLabel.font = ADaptedFontMediumSize(15);
        _proceedBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        
        _proceedBtn.layer.cornerRadius = 25.0;
    }
    return _proceedBtn;
}

@end
