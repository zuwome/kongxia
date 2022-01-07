//
//  ZZPostTaskBasicInfoController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskBasicInfoController.h"

#import "ZZPostTaskOtherInfoController.h"
#import "ZZCityViewController.h"
#import "ZZRentAbroadLocationViewController.h"
#import "ZZSearchLocationController.h"
#import "ZZAllTopicsViewController.h"
#import "ZZChooseSkillViewController.h"

#import "ZZTimeSelector.h"

#import "ZZPostTaskViewModel.h"
#import "ZZTimeSelectorModel.h"

@interface ZZPostTaskBasicInfoController () <ZZPostTaskViewModelDelegate, ZZTimeSelectorDelegate, ZZChooseSkillViewControllerDelegate>

@property (nonatomic, strong) ZZPostTaskViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *proceedBtn;

@end

@implementation ZZPostTaskBasicInfoController

/**
 * 普通的
 */
- (instancetype)initWithSkill:(ZZSkill *)skill taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _viewModel = [[ZZPostTaskViewModel alloc] initWithSkill:skill taskType:taskType];
        _viewModel.delegate = self;
    }
    return self;
}

- (instancetype)initTaskType:(TaskType)taskType taskInfo:(NSDictionary *)taskInfo {
    self = [super init];
    if (self) {
        _viewModel = [[ZZPostTaskViewModel alloc] initTaskType:taskType taskInfo:taskInfo];
        _viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写发布信息";
    
    [self layout];
    [_viewModel configTableView:self.tableview];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    NSLog(@"ZZPostTaskBasicInfoController is Dealloced");
}


#pragma mark - response method
- (void)proceed {
    if (!_viewModel.currentSkill) {
        [ZZHUD showErrorWithStatus:@"请选择技能"];
        return;
    }
    
    if (isNullString(_viewModel.location.name)) {
        [ZZHUD showErrorWithStatus:@"请选择见面地点"];
        return;
    }
    
    if (isNullString(_viewModel.startTime)) {
        [ZZHUD showErrorWithStatus:@"请填写你与达人的约见时间"];
        return;
    }
    
    if (_viewModel.durantion <= 0) {
        [ZZHUD showErrorWithStatus:@"请填写你与达人的约见时长"];
        return;
    }
    
    [self showOtherInfo];
}


#pragma mark - private method
- (void)getAddress:(ZZRentDropdownModel *)model{
    [_viewModel chooseLocation:model];
}

#pragma mark - ZZAllTopicsViewControllerDelegate
- (void)allTopicsController:(ZZAllTopicsViewController *)controller didChooseSkill:(ZZSkill *)skill {
    if (skill) {
        [_viewModel chooseSkill:skill];
    }
}

#pragma mark - ZZChooseSkillViewControllerDelegate
- (void)controller:(ZZChooseSkillViewController *)controller didChooseSkill:(ZZSkill *)skill {
    if (skill) {
        [_viewModel chooseSkill:skill];
    }
}

#pragma mark - ZZPostTaskViewModelDelegate
- (void)showSkillThemes:(ZZPostTaskViewModel *)model {
    [self gotoSelectSkills:model];
}

/*
   具体位置
*/
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
   显示选择时长view
*/
- (void)chooseDuration:(ZZPostTaskViewModel *)model {
    [self showTimeChooseView:postDuration];
}

/*
 跳转到标签
*/
- (void)viewModel:(ZZPostTaskViewModel *)model chooseTags:(ZZSkill *)skill {
    WeakSelf
    ZZChooseTagViewController *controller = [[ZZChooseTagViewController alloc] init];
    controller.selectedArray = [skill.tags mutableCopy];
    controller.catalogId = skill.pid ? skill.pid : skill.id;
    [controller setChooseTagCallback:^(NSArray *tags) {
        skill.tags = (NSArray<ZZSkillTag> *)tags;
        [weakSelf.viewModel updateSkillTags:skill];
    }];
    [self.navigationController pushViewController:controller animated:YES];
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
//    [self showMoneyInputView];
}


#pragma mark - Navigator
- (void)showOtherInfo {
    ZZPostTaskViewModel *viewModel = [[ZZPostTaskViewModel alloc] initWithSkill:_viewModel.currentSkill taskType:_viewModel.taskType];
    viewModel.currentStep = TaskStep2;
    
    if (_viewModel.location) {
        viewModel.location = _viewModel.location;
    }
    
    if (!isNullString(_viewModel.startTime)) {
        viewModel.startTime = _viewModel.startTime;
    }
    
    if (!isNullString(_viewModel.startTimeDescript)) {
        viewModel.startTimeDescript = _viewModel.startTimeDescript;
    }
    
    if (!isNullString(_viewModel.durantionDes)) {
        viewModel.durantionDes = _viewModel.durantionDes;
    }
    
    if (_viewModel.durantion > 0) {
        viewModel.durantion = _viewModel.durantion;
    }
    
    ZZPostTaskOtherInfoController *controller = [[ZZPostTaskOtherInfoController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToChooseTagsView:(ZZSkill *)skill {
    WeakSelf
    ZZChooseTagViewController *controller = [[ZZChooseTagViewController alloc] init];
    controller.selectedArray = [skill.tags mutableCopy];
    controller.catalogId = skill.pid ? skill.pid : skill.id;
    [controller setChooseTagCallback:^(NSArray *tags) {
        skill.tags = (NSArray<ZZSkillTag> *)tags;
        [weakSelf.viewModel updateSkillTags:skill];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

/*
 跳转到城市选择
 */
- (void)gotoCitySelectView {
    ZZCityViewController *controller = [[ZZCityViewController alloc] init];
    controller.isPush = YES;
    controller.selectedCity = ^(ZZCity *city) {
        [_viewModel chooseCity:city];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

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

- (void)gotoSelectSkills:(ZZPostTaskViewModel *)model {
    if (_viewModel.taskType == TaskFree) {
        ZZChooseSkillViewController *allSkills = [[ZZChooseSkillViewController alloc] init];
        allSkills.taskType = model.taskType;
        allSkills.isFromSkillSelectView = YES;
        allSkills.shouldPopBack = YES;
        allSkills.delegate = self;
        allSkills.title = @"选择你想开展的活动主题";
        [self.navigationController pushViewController:allSkills animated:YES];
    }
    else {
        ZZAllTopicsViewController *allTopics = [[ZZAllTopicsViewController alloc] init];
        allTopics.delegate = self;
        allTopics.shouldPopBack = YES;
        allTopics.isFromSkillSelectView = YES;
        [self.navigationController pushViewController:allTopics animated:YES];
    }
}


#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
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
    }
    return _tableview;
}

- (UIButton *)proceedBtn {
    if (!_proceedBtn) {
        _proceedBtn = [[UIButton alloc] init];
        _proceedBtn.normalTitle = @"下一步(1/2)  填写您对达人的要求";
        _proceedBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _proceedBtn.titleLabel.font = ADaptedFontMediumSize(16);
        [_proceedBtn addTarget:self action:@selector(proceed) forControlEvents:UIControlEventTouchUpInside];
        _proceedBtn.backgroundColor = kGoldenRod;
        _proceedBtn.layer.cornerRadius = 25.0;
    }
    return _proceedBtn;
}

@end


