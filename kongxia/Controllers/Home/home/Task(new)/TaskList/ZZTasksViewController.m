//
//  ZZTasksViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTasksViewController.h"
#import "ZZTaskListViewController.h"
#import "ZZPostTaskBasicInfoController.h"
#import "ZZTaskDetailViewController.h"
#import "ZZSnatchTaskSettingViewController.h"
#import "ZZReportViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZSettingPrivacyViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZRentOrderInfoViewController.h"

#import "ZZSkillSelectionView.h"
#import "WBActionContainerView.h"
#import "ZZPublishOrderView.h"
#import "ZZNewTasksView.h"

#import "ZZTaskModel.h"
#import "ZZTaksListViewModel.h"
#import "YYFPSLabel.h"

@interface ZZTasksViewController () <UIScrollViewDelegate, ZZTaskListViewControllerDelegate, ZZTasksTitleHeaderDelegate, ZZTaskDetailViewControllerDelegate, ZZReportViewControllerDelegate>

@property (nonatomic, strong) ZZTasksTitleHeader *titleHeaderView;

@property (nonatomic, strong) ZZScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView *publishBtn;

@property (nonatomic, strong) WBActionContainerView *presentSlider; //闪租任务背景半透明容器

@property (nonatomic, strong) ZZPublishOrderView *publishView;  //闪租任务发布界面

@property (nonatomic,   copy) NSArray<ZZTaskListViewController *> *viewControllers;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) ZZTaskModel *tempedSaveReportTask;

@property (nonatomic, assign) TaskType taskType;

@end

@implementation ZZTasksViewController

- (instancetype)initWithTaskType:(TaskType)type {
    self = [super init];
    if (self) {
        _onlyShowMyActivities = NO;
        _taskFreeJumpToMyList = NO;
        _taskType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 0;
    [self navigationLayout];
    [self layout];
    if (@available(iOS 11.0, *)) {
        self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self shouldJumpToMyList];
}

- (void)dealloc {
    NSLog(@"ZZTasksViewController is dealloced");
    [self removeNotifications];
}

#pragma mark - private method
- (void)shouldJumpToMyList {
    if (_taskType == TaskFree) {
        if (_taskFreeJumpToMyList) {
            [self showMyActivities];
            _taskFreeJumpToMyList = NO;
        }
    }
}

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

/**
 * 发布
 */
- (void)publish {
    if (![self actionCanProceed:taskActionNone]) {
        return;
    }
    
    if (_taskType != TaskFree) {
        [ZZSkillSelectionView showsIn:self taskType:_taskType];
    }
    else {
        [UserHelper.loginer canPublish:_taskType block:^(BOOL canPublish, ToastType failType, NSInteger actionIndex) {
            if (canPublish) {
                [self goToChooseSkillsView];
            }
            else {
                if (actionIndex == 1) {
                    if (failType == ToastActivityPublishFailDueToNotRent) {
                        // 跳转到我的界面
                        [self switchToMe];
                    }
                    else if (failType == ToastActivityPublishFailDueToNotShow) {
                        // 跳转到设置隐私页面
                        [self goToPrivateSettingView];
                    }
                    else if (failType == ToastRealAvatarNotFound) {
                        // 去上传真实头像
                        [self gotoUploadPicture];
                    }
                }
            }
        }];
    }
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

#pragma mark - Notifications
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(publishedTask)
                                                 name:kMsg_PublishedTaskNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrHidePublishBtn:)
                                                 name:kMsg_PublishBtnShowNotification
                                               object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)publishedTask {
    if (_taskType == TaskNormal) {
        if (_currentPage != 0) {
            _currentPage = 0;
            [_titleHeaderView scrollToIndex:_currentPage];
            [_contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _currentPage, 0) animated:YES];
        }
    }
}

- (void)showOrHidePublishBtn:(NSNotification *)notification {
    BOOL shouldShow = [notification.userInfo[@"shouldShow"] boolValue];
    [self publishBtnAnimation:!shouldShow];
}

- (void)goVerify {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeSignUpForTask inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    helper.checkSuccess = ^{
        [SVProgressHUD showInfoWithStatus:@"提交成功，我们将在1个工作日内审核"];
    };
    
    [helper start];
}

#pragma mark - ZZReportViewControllerDelegate
- (void)viewController:(ZZReportViewController *)viewController reportSuccess:(BOOL)isSuccess {
//    NSMutableDictionary *userInfo = @{
//                                      @"task": _tempedSaveReportTask,
//                                      @"from": @"taskIndex",
//                                      @"action": @(taskActionReport),
//                                      }.mutableCopy;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_TaskStatusDidChanged object:nil userInfo:userInfo];
}

#pragma mark - ZZTasksTitleHeaderDelegate
- (void)header:(ZZTasksTitleHeader *)header changedToIndex:(NSInteger)index {
    _currentPage = index;
    [_contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}

#pragma mark - ZZTaskListViewControllerDelegate
- (void)viewController:(ZZTaskListViewController *)viewController chatWith:(ZZTaskModel *)model shouldShowActionView:(BOOL)shouldShow {
    [self gotoChat:model.from model:model shouldShowActionView:shouldShow];
}

- (void)viewController:(ZZTaskListViewController *)viewController showDetailsWith:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath {
    [self showDetalsWithTaks:task indexPath:indexPath];
}

- (void)viewController:(ZZTaskListViewController *)viewController showUserInfoWith:(ZZTaskModel *)task {
    EntryTarget target = TargetNone;
    if (_taskType == TaskNormal) {
        if (task.task.push_count != 1 && !task.task.isTaskFinished) {
            target = TargetNormalTaskSignup;
        }
    }
    else {
        target = TargetActivitesRent;
    }
    
    [self showUserInfo:task.from task:task entryTarget:target];
}

- (void)viewController:(ZZTaskListViewController *)viewController showLocations:(ZZTaskModel *)task {
    [self showLocation:task];
}

- (void)viewController:(ZZTaskListViewController *)viewController showReportView:(ZZTaskModel *)task {
    [self showReportViewWithTask:task];
}

- (void)viewController:(ZZTaskListViewController *)viewController showUploadFaceVC:(ZZTaskModel *)task {
    [self gotoUploadPicture];
}

- (void)viewController:(ZZTaskListViewController *)viewController goToUserEditVC:(ZZTaskModel *)task {
    [self gotoEditVC];
}

- (void)viewController:(ZZTaskListViewController *)viewController showPriceDetails:(ZZTaskModel *)task {
    [self showPriceDetails:task];
}

- (void)viewController:(ZZTaskListViewController *)viewController rent:(ZZTaskModel *)task {
    [self gotoRentVC:task];
}

- (void)viewController:(ZZTaskListViewController *)viewController buyWechat:(ZZTaskModel *)task {
    [self showUserInfo:task.from task:task entryTarget:TargetBuyWechat];
}

- (void)switchToPrivateViewController:(ZZTaskListViewController *)viewController {
    [self goToPrivateSettingView];
}

- (void)switchToMe:(ZZTaskListViewController *)viewController {
    [self switchToMe];
}

- (void)viewControllerGoPub:(ZZTaskListViewController *)viewController {
    [self goToChooseSkillsView];
}

-(void)viewControllerGoVerify:(ZZTaskListViewController *)viewController {
    [self goVerify];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    _currentPage = page;
    if (page == 1) {
        [_viewControllers[1] refreshData];
    }
    else if (page == 0) {
        [_viewControllers[0] refreshData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_titleHeaderView scrollToIndex:_currentPage];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self publishBtnAnimation:velocity.y > 0];
}

#pragma mark - Navigator

/**
 *  发布活动跳转到全部技能的页面
*/
- (void)goToChooseSkillsView {
    ZZChooseSkillViewController *allSkills = [[ZZChooseSkillViewController alloc] init];
    allSkills.taskType = TaskFree;
    allSkills.title = @"选择你想开展的活动主题";
    allSkills.isFromSkillSelectView = YES;
    allSkills.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allSkills animated:YES];
}

/**
 *  跳转到个人隐私页面
 */
- (void)goToPrivateSettingView {
    ZZSettingPrivacyViewController *vc = [[ZZSettingPrivacyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = [ZZUserHelper shareInstance].loginer;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 我的界面
 */
- (void)switchToMe {
    ZZTabBarViewController *rootVC = (ZZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [rootVC setSelectedIndex:3];
}

/**
 发布
 */
- (void)goToPublishWithSkill:(ZZSkill *)skill {
    ZZPostTaskBasicInfoController *viewController = [[ZZPostTaskBasicInfoController alloc] initWithSkill:skill taskType:_taskType];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 聊天
 */
- (void)gotoChat:(ZZUser *)user model:(ZZTaskModel *)taskModel shouldShowActionView:(BOOL)shouldShow {
    ZZChatViewController *chatController = [[ZZChatViewController alloc] init];
    chatController.nickName = user.nickname;
    chatController.uid = user.uid;
    chatController.user = user;
    chatController.portraitUrl = user.avatar;

    if (_taskType == TaskFree && shouldShow) {
        [chatController configureTaskFreeModel: taskModel];
    }
    
    [self.navigationController pushViewController:chatController animated:YES];
}

/**
 task详情
 */
- (void)showDetalsWithTaks:(ZZTaskModel *)model indexPath:(NSIndexPath *)indexPath {
    ZZTaskDetailViewController *viewController = [[ZZTaskDetailViewController alloc] initWithTask:model indexPath:indexPath listType:_currentPage == 0 ? ListAll : ListMine taskType:_taskType];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 用户信息
 */
- (void)showUserInfo:(ZZUser *)user task:(ZZTaskModel *)task entryTarget:(EntryTarget)entryTarget {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    
    NSString *uid = user.uid;
    if (!isNullString(user.uid)) {
        uid = user.uid;
    }
    else if (!isNullString(user.uuid)) {
        uid = user.uuid;
    }
    controller.uid = uid;
    controller.task = task;
    controller.entryTarget = entryTarget;
    controller.isTaskFree = _taskType == TaskFree;
    if (entryTarget == TargetBuyWechat) {
        controller.showWX = YES;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 显示地点
 */
- (void)showLocation:(ZZTaskModel *)task {
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:task.task.address_lat longitude:task.task.address_lng];
    controller.location = location;
    controller.name = [NSString stringWithFormat:@"%@%@",task.task.city_name, task.task.address];
    controller.navigationItem.title = @"邀约地点";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 显示设置页面
 */
- (void)showSettingsViewController {
    ZZSnatchTaskSettingViewController *vc = [[ZZSnatchTaskSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 没有头像，则上传真实头像
 */
- (void)gotoUploadPicture {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = NavigationTypePublishTask;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 举报
 */
- (void)showReportViewWithTask:(ZZTaskModel *)task {
    ZZReportViewController *viewController = [[ZZReportViewController alloc] init];
    viewController.isFromTask = YES;
    viewController.pd_user = task.from.uid;
    viewController.pid = task.task._id;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
    _tempedSaveReportTask = task;
}

/**
 编辑用户信息页面
 */
- (void)gotoEditVC {
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 显示价格详情
 */
- (void)showPriceDetails:(ZZTaskModel *)task {
    
    NSString *uid = nil;
    if (isNullString(task.from.uid)) {
        uid = task.from.uuid;
    }
    else {
        uid = task.from.uid;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/pd/getPdPriceDetail?pid=%@&&from=%@&&access_token=%@",kBase_URL,task.task._id,uid,[ZZUserHelper shareInstance].oAuthToken];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.navigationItem.title = @"价格详情";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 显示线下租人的页面
 */
- (void)gotoRentVC:(ZZTaskModel *)task {
    ZZRentOrderInfoViewController *vc = [[ZZRentOrderInfoViewController alloc] init];
    vc.isFromTask = YES;
    vc.taskType = _taskType;
    vc.taskModel = task;
    vc.title = @"马上预约";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 显示我的活动列表页面
 */
- (void)showMyActivities {
    // 我的发布页
    ZZTaskListViewController *myTaskListViewController = [[ZZTaskListViewController alloc] initWithTaskListType:ListMine frame:self.view.bounds taskType:_taskType];
    myTaskListViewController.delegate = self;
    [self.navigationController pushViewController:myTaskListViewController animated:YES];
}

#pragma mark - Layout
- (void)navigationLayout {
    if (_taskType == TaskFree) {
        [self taskActivityNavigationLayout];
    }
    else {
        [self taskNormalNavigationLayout];
    }
}

- (void)taskNormalNavigationLayout {
    self.title = @"全部通告";
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 70, 21);
    [rightButton setTitle:@"提示设置" forState:UIControlStateNormal];
    [rightButton setTitle:@"提示设置" forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton addTarget:self action:@selector(showSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
}

- (void)taskActivityNavigationLayout {
    if (_onlyShowMyActivities) {
        self.title = @"我的活动";
    }
    else {
        self.title = @"全部活动";
        UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 90, 44)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMyActivities)];
        [userView addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userView.width - 60.0, 0.0, 60.0, 44.0)];
        nameLabel.textColor = RGBCOLOR(63, 58, 58);
        nameLabel.font = CustomFont(14);
        nameLabel.text = @"我的活动";
        [userView addSubview:nameLabel];
        
        UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.left - 5 - 20, userView.height * 0.5 - 10, 20, 20)];
        userIcon.userInteractionEnabled = YES;
        userIcon.layer.cornerRadius = 10.0;
        userIcon.layer.masksToBounds = YES;
        [userView addSubview:userIcon];
        [userIcon sd_setImageWithURL:[NSURL URLWithString:[UserHelper.loginer displayAvatar]]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userView];
    }
}

- (void)layout {
    if (_taskType == TaskFree) {
        [self taskActivityLayout];
    }
    else {
        [self taskNormalLayout];
    }
}

- (void)taskActivityLayout {
    TaskListType listType = ListAll;
    if (_onlyShowMyActivities) {
        listType = ListMine;
    }
    
    ZZTaskListViewController *taskListViewController = [[ZZTaskListViewController alloc] initWithTaskListType:listType frame:self.view.bounds taskType:_taskType];
    [self.view addSubview:taskListViewController.view];
    [taskListViewController refreshData];
    taskListViewController.delegate = self;
    [self addChildViewController:taskListViewController];
    
    if (!_onlyShowMyActivities) {
        [self.view addSubview:self.publishBtn];
        _publishBtn.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 80 * 0.5, SCREEN_HEIGHT - 44 - 60 - NAVIGATIONBAR_HEIGHT, 80, 80);
    }
}

- (void)taskNormalLayout {
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.titleHeaderView];
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.publishBtn];
    
    [_titleHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleHeaderView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    CGSize size = CGSizeZero;
    if (_taskType == TaskFree) {
        size = CGSizeMake(80.0, 80.0);
    }
    else {
        size = CGSizeMake(106, 60);
    }
    _publishBtn.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 106 * 0.5, SCREEN_HEIGHT - 44 - 60 - NAVIGATIONBAR_HEIGHT, size.width, size.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createViewControllers];
    });
}

- (void)createViewControllers {
    // 发布列表
    ZZTaskListViewController *taskListViewController = [[ZZTaskListViewController alloc] initWithTaskListType:ListAll frame:self.contentScrollView.bounds taskType:_taskType];
    [_contentScrollView addSubview:taskListViewController.view];
    [taskListViewController refreshData];
    taskListViewController.delegate = self;
    [self addChildViewController:taskListViewController];

    // 我的发布页
    ZZTaskListViewController *myTaskListViewController = [[ZZTaskListViewController alloc] initWithTaskListType:ListMine frame:self.contentScrollView.bounds taskType:_taskType];
    myTaskListViewController.delegate = self;
    [_contentScrollView addSubview:myTaskListViewController.view];
    [self addChildViewController:myTaskListViewController];
   
    taskListViewController.view.frame = CGRectMake(0.0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    myTaskListViewController.view.frame = CGRectMake(SCREEN_WIDTH,  0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
    
    _viewControllers = @[taskListViewController, myTaskListViewController];
    [_contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, 0.0)];
}

#pragma mark - Getter&Setter
- (ZZTasksTitleHeader *)titleHeaderView {
    if (!_titleHeaderView) {
        _titleHeaderView = [[ZZTasksTitleHeader alloc] init];
        _titleHeaderView.delegate = self;
    }
    return _titleHeaderView;
}

- (ZZScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[ZZScrollView alloc] init];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

- (UIImageView *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [[UIImageView alloc] init];
        _publishBtn.image = [UIImage imageNamed: _taskType == TaskFree ? @"icFabuhuodong" : @"Group16"];
        _publishBtn.userInteractionEnabled = YES;
        _publishBtn.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publish)];
        [_publishBtn addGestureRecognizer:tap];
    }
    return _publishBtn;
}

- (WBActionContainerView *)presentSlider {
    if (nil == _presentSlider) {
        _presentSlider = [[WBActionContainerView alloc] initWithView:self.publishView forHeight:self.publishView.frame.size.height];
        _presentSlider.maskViewClickEnable = NO;
    }
    return _presentSlider;
}

- (ZZPublishOrderView *)publishView {
    WeakSelf
    if (nil == _publishView) {
        CGFloat height = SCALE_SET(700);
        if (isIPhoneX) {
            height = SCALE_SET(850);
        }
        else if (isIPhoneXsMax) {
            height = SCALE_SET(950);
        }
        _publishView = [[ZZPublishOrderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [_publishView setDismissBlock:^{
            // 点击取消
            [weakSelf.presentSlider dismiss];
        }];
        [_publishView setPresentBlock:^{
            // 点击任务
            [weakSelf goToPublishWithSkill:weakSelf.publishView.skill];
        }];
    }
    return _publishView;
}
@end

@interface ZZTasksTitleHeader ()

@property (nonatomic, copy) NSArray<NSString *> *titles;

@property (nonatomic, strong) UIButton *allTasksBtn;

@property (nonatomic, strong) UIButton *myTasksBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *currentBtn;

@end

@implementation ZZTasksTitleHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineHeight = 5.0;
        _lineWidth = 17.0;
        [self layout];
        _currentIndex = 0;
        _currentBtn = _allTasksBtn;
    }
    return self;
}

#pragma mark - public Method
- (void)scrollToIndex:(NSInteger)index {
    _currentIndex = index;
    [self aniamation];
}

#pragma mark - private method
- (void)aniamation {
    CGFloat lineY = 36.0;
    UIButton *previewBtn = _currentBtn;
    _currentBtn = _currentIndex == 0 ? _allTasksBtn : _myTasksBtn;
    CGFloat lineX = _currentBtn.frame.size.width * 0.5 + _currentBtn.frame.origin.x - _lineWidth * 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        _line.frame = CGRectMake(lineX, lineY, _lineWidth, _lineHeight);
    } completion:^(BOOL finished) {
        [previewBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_currentBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
    }];
}

- (void)allTasksClick {
    _currentIndex = 0;
    [self aniamation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:changedToIndex:)]) {
        [self.delegate header:self changedToIndex:0];
    }
}

- (void)myTasksClick {
    _currentIndex = 1;
    [self aniamation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:changedToIndex:)]) {
        [self.delegate header:self changedToIndex:1];
    }
}

#pragma mark Layout
- (void)layout {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.allTasksBtn];
    [self addSubview:self.myTasksBtn];
    [self addSubview:self.line];
    
    [_allTasksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX).offset(-25);
        make.width.equalTo(@100.0);
        make.top.bottom.equalTo(self);
    }];
    
    [_myTasksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_centerX).offset(25);
        make.width.equalTo(@100.0);
        make.top.bottom.equalTo(self);
    }];

    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat lineY = 36.0;
        CGFloat lineX = _allTasksBtn.frame.size.width * 0.5 + _allTasksBtn.frame.origin.x - _lineWidth * 0.5;
        _line.frame = CGRectMake(lineX, lineY, _lineWidth, _lineHeight);
    });
}

#pragma mark - Getter&Setter
- (UIButton *)allTasksBtn {
    if (!_allTasksBtn) {
        _allTasksBtn = [[UIButton alloc] init];
        [_allTasksBtn setTitle:@"推荐通告" forState:(UIControlStateNormal)];
        [_allTasksBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_allTasksBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
        [_allTasksBtn addTarget:self action:@selector(allTasksClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _allTasksBtn;
}

- (UIButton *)myTasksBtn {
    if (!_myTasksBtn) {
        _myTasksBtn = [[UIButton alloc] init];
        [_myTasksBtn setTitle:@"我的发布" forState:(UIControlStateNormal)];
        [_myTasksBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_myTasksBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_myTasksBtn addTarget:self action:@selector(myTasksClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _myTasksBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kYellowColor;
        _line.layer.cornerRadius = 2;
        _line.layer.masksToBounds = YES;
    }
    return _line;
}

@end
