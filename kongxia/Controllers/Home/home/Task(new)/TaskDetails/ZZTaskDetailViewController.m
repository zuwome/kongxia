//
//  ZZTaskDetailViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskDetailViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZTaskLikesViewController.h"
#import "ZZPayViewController.h"

#import "ZZTaksDetailsViewModel.h"
#import "ZZTaskModel.h"

@interface ZZTaskDetailViewController ()<ZZTaksDetailsViewModelDelegate, ZZRentViewControllerDelegate, ZZChatViewControllerDelegate>

@property (nonatomic, strong) ZZTaksDetailsViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) ZZTaskDetailBottomView *bottomView;

@end

@implementation ZZTaskDetailViewController

- (instancetype)initWithTask:(ZZTaskModel *)task indexPath:(NSIndexPath *)taskIndexPath listType:(TaskListType)listType taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _viewModel = [[ZZTaksDetailsViewModel alloc] initWithTaskModel:task tableView:self.tableview indexPath:taskIndexPath taskType:taskType];
        _viewModel.currentListType = listType;
        _viewModel.delegate = self;
    }
    return self;
}

- (instancetype)initWithTaskID:(NSString *)taskID {
    self = [super init];
    if (self) {
        _viewModel = [[ZZTaksDetailsViewModel alloc] initWithTaskID:taskID tableView:self.tableview];
        _viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _viewModel.delegate = self;
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [_viewModel clearPicked];
}

#pragma mark - response method
- (void)book {
    [_viewModel completeSelect];
}

#pragma mark - ZZRentViewControllerDelegate
- (void)controller:(ZZRentViewController *)controller didPicked:(ZZUser *)user {
    [_viewModel didPickUser:user];
}

#pragma mark - ZZChatViewControllerDelegate
- (void)controller:(ZZChatViewController *)controller chatDidPickUser:(ZZUser *)user {
    [_viewModel didPickUser:user];
}

#pragma mark - Navigator
- (void)gotoChat:(ZZUser *)user isFromTask:(BOOL)isFromTask {
    ZZChatViewController *chatController = [[ZZChatViewController alloc] init];
    chatController.nickName = user.nickname;
    chatController.uid = user.uuid;
    chatController.portraitUrl = user.avatar;
    chatController.delegate = self;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)gotoChatWithID:(NSString *)userID isFromTask:(BOOL)isFromTask {
    ZZChatViewController *chatController = [[ZZChatViewController alloc] init];
    chatController.uid = userID;
    chatController.delegate = self;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)showUserInf:(ZZUser *)user isPick:(BOOL)isPick {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = user.uuid;
    EntryTarget target = TargetNone;
    if (_viewModel.task.task.taskStatus == TaskOngoing || _viewModel.task.task.taskStatus == TaskClose) {
        if ([_viewModel.task.task isNewTask]) {
            target = TargetTonggaoPick;
        }
        else {
            target = isPick ? TargetNormalTaskPick : TargetNone;
        }
    }
    else {
        target = TargetNone;
    }
    controller.entryTarget = target;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showLocation:(ZZTaskModel *)task {
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:task.task.address_lat longitude:task.task.address_lng];
    controller.location = location;
    controller.name = [NSString stringWithFormat:@"%@%@",task.task.city_name, task.task.address];
    controller.navigationItem.title = @"邀约地点";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showPhotos:(ZZTaskModel *)task selectIndex:(NSString *)imageStr {
    // 网络图片
    NSString *img = imageStr;
    
    //    NSMutableArray *displayedArray = @[].mutableCopy;
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

// 没有头像，则上传真实头像
- (void)gotoUploadPicture {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    //    vc.from = _user;//不需要用到
    vc.type = NavigationTypePublishTask;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoLikesDetails:(ZZTaskModel *)taskModel {
    ZZTaskLikesViewController *vc = [[ZZTaskLikesViewController alloc] initWithTaskID:taskModel.task._id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showPriceDetails:(ZZTaskModel *)task {
    NSString *urlString = [NSString stringWithFormat:@"%@/api/pd/getPdPriceDetail?pid=%@&&from=%@&&access_token=%@",kBase_URL,task.task._id,task.from.uid,[ZZUserHelper shareInstance].oAuthToken];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.navigationItem.title = @"价格详情";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 去付尾款
 */
- (void)gotoPay:(NSArray *)selectIDs model:(ZZTaskModel *)taskModel {
    ZZPayViewController *controller = [[ZZPayViewController alloc] init];
    controller.pId = taskModel.task._id;
    controller.type = payTypePayTonggao;
    controller.price = [taskModel.task.price doubleValue];
    controller.tonggaoSelectIDs = selectIDs;
    controller.tonggaoAgencyPrice = taskModel.task.agency_price;
    controller.didPay = ^{
        //支付回调
        [ZZHUD showSuccessWithStatus:@"付款成功"];
        
        if ([taskModel.task isNewTask]) {
            // 新版去聊天
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self gotoChatWithID:selectIDs.firstObject isFromTask:YES];
            });
            [_viewModel taskStatusDidChangedWithAction:taskActionTonggaoPay];
            [self configureFrames];
        }
        else {
            NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
            [vcs removeLastObject];
            [vcs removeLastObject];
            
            if (![vcs.lastObject isKindOfClass: [ZZTasksViewController class]]) {
                ZZTasksViewController *tasksVC = [[ZZTasksViewController alloc] initWithTaskType: _viewModel.taskType];
                tasksVC.hidesBottomBarWhenPushed = YES;
                [vcs addObject:tasksVC];
            }
            [self.navigationController setViewControllers:vcs animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishedTaskNotification object:nil];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ZZTaksDetailsViewModelDelegate
/**
 更新了数据
 */
- (void)viewModel:(ZZTaksDetailsViewModel *)model changeTitle:(NSString *)title {
    self.title = title;
    [self configureFrames];
}

- (void)viewModel:(ZZTaksDetailsViewModel *)model chatWith:(ZZUser *)user {
    [self gotoChat:user isFromTask:YES];
}

- (void)viewModel:(ZZTaksDetailsViewModel *)model showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr {
    [self showPhotos:task selectIndex:currentImgStr];
}

- (void)viewModel:(ZZTaksDetailsViewModel *)model showUserInfoWith:(ZZUser *)user isPick:(BOOL)isPick{
    [self showUserInf:user isPick:isPick];
}

- (void)viewModel:(ZZTaksDetailsViewModel *)model showLocations:(ZZTaskModel *)task {
    [self showLocation:task];
}

- (void)viewModel:(ZZTaksDetailsViewModel *)model showMoreLikedUsers:(ZZTaskModel *)task {
    [self gotoLikesDetails:task];
}

/*
 选人了,还没预约
 */
- (void)viewModelUserDidPicked:(ZZTaksDetailsViewModel *)model {
    [_bottomView configurePriceWithTask:_viewModel.task];
}

- (void)viewModel:(ZZTaksDetailsViewModel *)model showUploadFaceVC:(ZZTaskModel *)task {
    [self gotoUploadPicture];
}

- (void)taskStatusDidChanged:(ZZTaksDetailsViewModel *)model {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewModel:(ZZTaksListViewModel *)viewModel showPriceDetails:(ZZTaskModel *)task {
    [self showPriceDetails:task];
}

/**
 新版的选完人去付尾款
 */
- (void)viewmodel:(ZZTaksDetailsViewModel *)model gotoPay:(NSArray *)selectIDs {
    [self gotoPay:selectIDs model:model.task];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableview];
    
//    [self configureFrames];
}

- (void)configureFrames {
    if (_viewModel.task && [_viewModel.task.task isNewTask]) {
        if (_viewModel.task.task.signupers.count != 0 && (_viewModel.task.task.taskStatus == TaskOngoing || _viewModel.task.task.taskStatus == TaskClose)) {
            _bottomView.hidden = NO;
            CGFloat bottomHeight = isFullScreenDevice ? (50 + 34) : 50;
            [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self.view);
                make.height.equalTo(@(bottomHeight));
            }];
            
            [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.bottom.equalTo(_bottomView.mas_top);
            }];
        }
        else {
            _bottomView.hidden = YES;
            _bottomView.frame = CGRectZero;
            [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    }
    else {
        _bottomView.hidden = YES;
        _bottomView.frame = CGRectZero;
        _tableview.frame = self.view.bounds;
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
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
    }
    return _tableview;
}

- (ZZTaskDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ZZTaskDetailBottomView alloc] init];
        [_bottomView.pickBtn addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

@end


@interface ZZTaskDetailBottomView ()

@end

@implementation ZZTaskDetailBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configurePriceWithTask:(ZZTaskModel *)task {
    if (task.task.pickSignupersArr.count != 0 && task.task.pickSignupersArr.count <= 5) {
        // 钱
        double price = task.task.price.doubleValue;
        NSString *totalPrice = [NSString stringWithFormat:@"%.0f", (price * task.task.pickSignupersArr.count)];
        NSString *priceStr = [NSString stringWithFormat:@"需支付%@元", totalPrice];
        
        NSMutableAttributedString *priceAttriString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [priceAttriString addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"PingFangSC-Medium" size: 15.0f]
                                  range: NSMakeRange(0, priceStr.length)];
        [priceAttriString addAttribute:NSForegroundColorAttributeName
                                  value:RGBCOLOR(63, 58, 58)
                                  range: NSMakeRange(0, priceStr.length)];
        
        NSRange priceRange = [priceStr rangeOfString:totalPrice];
        if (priceRange.location != NSNotFound) {
            [priceAttriString addAttribute:NSForegroundColorAttributeName
                                      value:RGBCOLOR(252, 47, 82)
                                      range: priceRange];
        }
        _priceLabel.attributedText = priceAttriString;
        
        // 人
        NSString *count = [NSString stringWithFormat:@"%ld", task.task.pickSignupersArr.count];
        NSString *picked = [NSString stringWithFormat:@"已选择%@人", count];
        
        NSMutableAttributedString *pickedAttriString = [[NSMutableAttributedString alloc] initWithString:picked];
        [pickedAttriString addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"PingFangSC-Medium" size: 15.0f]
                                  range: NSMakeRange(0, picked.length)];
        [pickedAttriString addAttribute:NSForegroundColorAttributeName
                                  value:RGBCOLOR(63, 58, 58)
                                  range: NSMakeRange(0, picked.length)];
        
        NSRange countRange = [picked rangeOfString:count];
        if (countRange.location != NSNotFound) {
            [pickedAttriString addAttribute:NSFontAttributeName
                                      value:[UIFont boldSystemFontOfSize:15]
                                      range: countRange];
            [pickedAttriString addAttribute:NSForegroundColorAttributeName
                                      value:RGBCOLOR(252, 47, 82)
                                      range: countRange];
        }
        _pickedLabel.attributedText = pickedAttriString;
        
        _pickBtn.backgroundColor = RGBCOLOR(244, 203, 7);
    }
    else {
        _priceLabel.textColor = RGBCOLOR(136, 136, 136);
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        
        if (task.task.pickSignupersArr.count > 5) {
            NSString *count = @"5";
            NSString *picked = [NSString stringWithFormat:@"您最多可选择%@人", count];
            
            NSMutableAttributedString *pickedAttriString = [[NSMutableAttributedString alloc] initWithString:picked];
            [pickedAttriString addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"PingFangSC-Medium" size: 15.0f]
                                      range: NSMakeRange(0, picked.length)];
            [pickedAttriString addAttribute:NSForegroundColorAttributeName
                                      value:RGBCOLOR(136, 136, 136)
                                      range: NSMakeRange(0, picked.length)];
            
            NSRange countRange = [picked rangeOfString:count];
            if (countRange.location != NSNotFound) {
                [pickedAttriString addAttribute:NSFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:15]
                                          range: countRange];
                [pickedAttriString addAttribute:NSForegroundColorAttributeName
                                          value:RGBCOLOR(252, 47, 82)
                                          range: countRange];
            }
            _priceLabel.attributedText = pickedAttriString;
            _pickBtn.backgroundColor = RGBCOLOR(216, 216, 216);
        }
        else {
            _priceLabel.text = @"请选人";
            _pickBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        }
        
        _pickedLabel.text = @"";
        
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowRadius = 1;
    
    [self addSubview:self.pickBtn];
    [self addSubview:self.priceLabel];
    [self addSubview:self.pickedLabel];
    
    [_pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.equalTo(@160);
        make.height.equalTo(@50);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14.5);
        make.left.equalTo(self).offset(15);
    }];
    
    [_pickedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14.5);
        make.right.equalTo(_pickBtn.mas_left).offset(-15);
    }];
}

#pragma mark - getters and setters
- (UIButton *)pickBtn {
    if (!_pickBtn) {
        _pickBtn = [[UIButton alloc] init];
        _pickBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        [_pickBtn setTitle:@"马上预约" forState:UIControlStateNormal];
        [_pickBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _pickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _pickBtn;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"请选人";
        _priceLabel.textColor = RGBCOLOR(136, 136, 136);
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _priceLabel;
}

- (UILabel *)pickedLabel {
    if (!_pickedLabel) {
        _pickedLabel = [[UILabel alloc] init];
        _pickedLabel.text = @"";
        _pickedLabel.textColor = RGBCOLOR(63, 58, 58);
        _pickedLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _pickedLabel;
}

@end
