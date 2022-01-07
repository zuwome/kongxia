//
//  ZZTaskListViewController.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTaksListViewModel.h"
#import "ZZTasks.h"

@class ZZTaskListViewController;
@class ZZTaskModel;

@protocol ZZTaskListViewControllerDelegate <NSObject>

- (void)viewController:(ZZTaskListViewController *)viewController chatWith:(ZZTaskModel *)model shouldShowActionView:(BOOL)shouldShow;

- (void)viewController:(ZZTaskListViewController *)viewController showDetailsWith:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath;

- (void)viewController:(ZZTaskListViewController *)viewController showUserInfoWith:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController showLocations:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController showReportView:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController showUploadFaceVC:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController goToUserEditVC:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController showPriceDetails:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController rent:(ZZTaskModel *)task;

- (void)viewController:(ZZTaskListViewController *)viewController buyWechat:(ZZTaskModel *)task;

- (void)viewControllerGoVerify:(ZZTaskListViewController *)viewController;

- (void)switchToMe:(ZZTaskListViewController *)viewController;

- (void)switchToPrivateViewController:(ZZTaskListViewController *)viewController;

- (void)viewControllerGoPub:(ZZTaskListViewController *)viewController;
@end

@interface ZZTaskListViewController : ZZViewController

@property (nonatomic, weak) id<ZZTaskListViewControllerDelegate> delegate;

@property (nonatomic, assign) TaskListType type;

@property (nonatomic, assign) TaskType taskType;

- (instancetype)initWithTaskListType:(NSInteger)type frame:(CGRect)frame taskType:(TaskType)type;

- (void)refreshData;

- (void)firstTimeRefresh;

@end

@interface ZZListAlertView: UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)showUnreadMessage:(NSInteger)unreadCount;

- (void)showAlertMessage:(NSString *)alertMessage;

@end
