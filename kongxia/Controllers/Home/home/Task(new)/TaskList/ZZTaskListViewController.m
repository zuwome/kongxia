//
//  ZZTaskListViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskListViewController.h"

#import "ZZSnatchTaskSettingViewController.h"

#import "ZZTaksListViewModel.h"
#import "ZZTaskModel.h"
#import "YYFPSLabel.h"
#import "ZZSkillSelectionView.h"
#import "YBImageBrowser.h"

@interface ZZTaskListViewController () <ZZTaksListViewModelDelegate>

@property (nonatomic, strong) ZZTaksListViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) ZZListAlertView *alertView;

@property (nonatomic, assign) BOOL isFirstTime;

@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UIImageView *publishBtn;

@end

@implementation ZZTaskListViewController

- (instancetype)initWithTaskListType:(NSInteger)type frame:(CGRect)frame taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _taskType = taskType;
        _frame = frame;
        _isFirstTime = YES;
        _type = (TaskListType)type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[ZZTaksListViewModel alloc] initWithTableView:self.tableview currentType:_type taskType:_taskType];
    _viewModel.delegate = self;
    
    if (_taskType == TaskFree && _type == ListMine) {
        self.title = @"我的活动";
        [self refreshData];
        [self navigationLayout];
    }
    
    [self layout];
    [self addNotifications];
//    [self.view showFPSLabel];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [self removeNotifications];
    NSLog(@"************%@ is Deallocing**********", _type == ListAll ? @"list All" : @"my list");
}

#pragma mark - public Method
- (void)refreshData {
    if (_isFirstTime) {
        _isFirstTime = NO;
        [_viewModel refreshing];
    }
}

- (void)firstTimeRefresh {
    [_tableview.mj_header beginRefreshing];
}

- (void)publishBtnAnimation:(BOOL)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _publishBtn.frame;
        if (hidden) {
            frame.origin.y = SCREEN_HEIGHT + 60;
        }
        else {
            frame.origin.y = SCREEN_HEIGHT - 44 - 60 - NAVIGATIONBAR_HEIGHT;
        }
        _publishBtn.frame = frame;
    }];
}

- (void)publish {
    if (![self actionCanProceed:taskActionNone]) {
        return;
    }
    
    [UserHelper.loginer canPublish:_taskType block:^(BOOL canPublish, ToastType failType, NSInteger actionIndex) {
        if (canPublish) {
            if (_taskType == TaskNormal) {
                [ZZSkillSelectionView showsIn:self taskType:_taskType];
            }
            else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerGoPub:)]) {
                    [self.delegate viewControllerGoPub:self];
                }
            }
            
        }
        else {
            if (actionIndex == 1) {
                if (failType == ToastActivityPublishFailDueToNotRent) {
                    // 跳转到我的界面
                    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToMe:)]) {
                        [self.delegate switchToMe:self];
                    }
                }
                else if (failType == ToastActivityPublishFailDueToNotShow) {
                    // 跳转到设置隐私页面
                    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToPrivateViewController:)]) {
                        [self.delegate switchToPrivateViewController:self];
                    }
                }
            }
        }
    }];
}

#pragma mark - Notification
- (void)addNotifications {
    if (_viewModel.taskType == TaskFree && _viewModel.currentType == ListMine) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showOrHidePublishBtn:)
                                                     name:kMsg_PublishBtnShowNotification
                                                   object:nil];
    }
    
    if (_viewModel.taskType == TaskNormal && _viewModel.currentType == ListAll) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showUnreadView:)
                                                     name:kMsg_TaskUnreadCountDidChanged
                                                   object:nil];
    }
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showOrHidePublishBtn:(NSNotification *)notification {
    BOOL shouldShow = [notification.userInfo[@"shouldShow"] boolValue];
    [self publishBtnAnimation:!shouldShow];
}

- (void)showUnreadView:(NSNotification *)notification {
    NSInteger counts = [notification.userInfo[@"unreadCounts"] integerValue];
    if (counts > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView showUnreadMessage:counts];
        });
    }
}


#pragma mark - private method
- (BOOL)actionCanProceed:(TaskAction)taskAction {
    // 未登录
    if (![ZZUserHelper shareInstance].isLogin) {
        UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navCtl = [tabs selectedViewController];
        NSLog(@"PY_登录界面%s",__func__);
        [[LoginHelper sharedInstance] showLoginViewIn:navCtl];
        return NO;
    }
    
    // 被封禁
    if ([ZZUtils isBan]) {
        return NO;
    }
    
    return YES;
}

// 没有人脸，则验证人脸
- (void)gotoVerifyFace {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerGoVerify:)]) {
        [self.delegate viewControllerGoVerify:self];
    }
}

#pragma mark - response method
- (void)showSettings {
    [self showSettingsViewController];
}

#pragma mark - ZZTaksListViewModelDelegate
- (void)viewModelGoVerify:(ZZTaksListViewModel *)model {
    [self gotoVerifyFace];
}

- (void)viewModel:(ZZTaksListViewModel *)model chatWith:(ZZTaskModel *)task shouldShowActionView:(BOOL)shouldShow {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:chatWith:shouldShowActionView:)]) {
        [self.delegate viewController:self chatWith:task shouldShowActionView:shouldShow];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model showDetailWith:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:showDetailsWith:indexPath:)]) {
        [self.delegate viewController:self showDetailsWith:task indexPath:indexPath];
    }
}

/*
 展示网络图片
 */
- (void)viewModel:(ZZTaksListViewModel *)model showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr {
    // 网络图片
    NSString *img = currentImgStr;
    NSMutableArray<YBImageBrowseCellData *> *array = @[].mutableCopy;
    [task.task.imgs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((TaskImageStatus)[task.task.imgsStatus[idx] intValue] == ImageStatusSuccess && [obj isKindOfClass: [NSString class]]) {
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = [NSURL URLWithString:obj];
            [array addObject:data];
        }
    }];

    __block NSInteger imgIndex = -1;
    if (!isNullString(img)) {
        [array enumerateObjectsUsingBlock:^(YBImageBrowseCellData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.url.absoluteString isEqualToString:img]) {
                imgIndex = idx;
                *stop = YES;
            }
        }];
    }
    
    // 设置数据源数组并展示
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.toolBars = @[];
    browser.dataSourceArray = array;
    if (imgIndex != -1) {
        browser.currentIndex = imgIndex;
    }
    [browser show];
}

- (void)viewModel:(ZZTaksListViewModel *)model showUserInfoWith:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:showUserInfoWith:)]) {
        [self.delegate viewController:self showUserInfoWith:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model showLocations:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:showLocations:)]) {
        [self.delegate viewController:self showLocations:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model showReportView:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:showReportView:)]) {
        [self.delegate viewController:self showReportView:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model showUploadFaceVC:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:showUploadFaceVC:)]) {
        [self.delegate viewController:self showUploadFaceVC:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model goToUserEditVC:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:goToUserEditVC:)]) {
        [self.delegate viewController:self goToUserEditVC:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)viewModel showPriceDetails:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:showPriceDetails:)]) {
        [self.delegate viewController:self showPriceDetails:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model showAlertMessage:(NSString *)message {
    if (!isNullString(message)) {
        [_alertView showAlertMessage:message];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model rent:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:rent:)]) {
        [self.delegate viewController:self rent:task];
    }
}

- (void)viewModel:(ZZTaksListViewModel *)model buyWechat:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:buyWechat:)]) {
        [self.delegate viewController:self buyWechat:task];
    }
}

#pragma mark - Navigator
/**
 显示设置页面
 */
- (void)showSettingsViewController {
    ZZSnatchTaskSettingViewController *vc = [[ZZSnatchTaskSettingViewController alloc] init];
    vc.settingType = settingTaskFree;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Layout
- (void)navigationLayout {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 70, 21);
    [rightButton setTitle:@"提示设置" forState:UIControlStateNormal];
    [rightButton setTitle:@"提示设置" forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
}

- (void)layout {
    self.view.backgroundColor = UIColor.whiteColor;
    
    if ((_viewModel.currentType == ListAll && _viewModel.taskType == TaskNormal) || (_viewModel.taskType == TaskFree && _viewModel.currentType == ListAll)) {
        [self.view addSubview:self.alertView];
    }

    [self.view addSubview:self.tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        if ((_viewModel.currentType == ListAll && _viewModel.taskType == TaskNormal) || (_viewModel.taskType == TaskFree && _viewModel.currentType == ListAll) ) {
            make.top.equalTo(self.alertView.mas_bottom);
        }
        else {
            make.top.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    if ((_viewModel.currentType == ListMine && _viewModel.taskType == TaskFree)) {
        [self.view addSubview:self.publishBtn];
        _publishBtn.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 80 * 0.5, SCREEN_HEIGHT - 44 - 60 - NAVIGATIONBAR_HEIGHT, 80.0, 80.0);
    }
}

#pragma mark - Getter&Setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.tableFooterView = [UIView new];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.01f)];
        
        if (SCREEN_HEIGHT >= 812.0 || _taskType == TaskFree) {
            _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 34.0)];
        }
    }
    return _tableview;
}

- (ZZListAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZZListAlertView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 32.0)];
    }
    return _alertView;
}

- (UIImageView *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [[UIImageView alloc] init];
        _publishBtn.image = [UIImage imageNamed:@"icFabuhuodong"];
        _publishBtn.userInteractionEnabled = YES;
        _publishBtn.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publish)];
        [_publishBtn addGestureRecognizer:tap];
    }
    return _publishBtn;
}

@end

@interface ZZListAlertView ()

@property (nonatomic, copy) NSString *unreadMessage;

@property (nonatomic, copy) NSString *alertMessage;

@property (nonatomic, assign) BOOL canShowAlertMessage;

@end

@implementation ZZListAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _canShowAlertMessage = YES;
        [self layout];
    }
    return self;
}

- (void)showUnreadMessage:(NSInteger)unreadCount {
    _canShowAlertMessage = NO;
    _titleLabel.text = [NSString stringWithFormat:@"已刷新%ld条新的通告",(long)unreadCount];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _canShowAlertMessage = YES;
        if (_canShowAlertMessage) {
            _titleLabel.text = _alertMessage;
        }
    });
}

- (void)showAlertMessage:(NSString *)alertMessage {
    _alertMessage = alertMessage;
    if (_canShowAlertMessage) {
        _titleLabel.text = _alertMessage;
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(252, 250, 228);
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
}

#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _titleLabel.text = @"不瞎忙，先沟通。看到邀约先私信问TA具体内容，再决定是否报名";
        _titleLabel.textColor = RGBCOLOR(205, 136, 49);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
