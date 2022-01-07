//
//  ZZTaksListViewModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTaskListViewController.h"
#import "ZZTaskConfig.h"

@class ZZTaskModel;
@class ZZTaksListViewModel;
@class ZZTaskSignuperModel;
@class ZZTaskLikeModel;

@protocol ZZTaksListViewModelDelegate <NSObject>

- (void)viewModel:(ZZTaksListViewModel *)model chatWith:(ZZTaskModel *)task shouldShowActionView:(BOOL)shouldShow;

- (void)viewModel:(ZZTaksListViewModel *)model showPhotoWith:(ZZTaskModel *)task selecteIdx:(NSInteger)index;

- (void)viewModel:(ZZTaksListViewModel *)model showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr;

- (void)viewModel:(ZZTaksListViewModel *)model showDetailWith:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath;

- (void)viewModel:(ZZTaksListViewModel *)model showMoreAction:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model showUserInfoWith:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model showLocations:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model showReportView:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model showUploadFaceVC:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model goToUserEditVC:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)viewModel showPriceDetails:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model showAlertMessage:(NSString *)message;

- (void)viewModel:(ZZTaksListViewModel *)model rent:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksListViewModel *)model buyWechat:(ZZTaskModel *)task;

- (void)viewModelGoVerify:(ZZTaksListViewModel *)model;

@end

@interface ZZTaksListViewModel : NSObject 

@property (nonatomic, assign) TaskListType currentType;

@property (nonatomic, weak) id<ZZTaksListViewModelDelegate> delegate;

@property (nonatomic, assign) TaskType taskType;

- (instancetype)initWithTableView:(UITableView *)tableView
                      currentType:(TaskListType)type
                         taskType:(TaskType)type;

- (void)refreshing;

@end

#pragma mark - TaskItem
@interface TaskItem: NSObject

- (TaskItemType)type;

- (NSString *)identifier;

- (UITableViewCellAccessoryType)accessoryType;

@property (nonatomic, assign) TaskListType listType;

@property (nonatomic, strong) ZZTaskModel *task;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) TaskType taskType;

@property (nonatomic, assign) BOOL isNewTask;

@end

#pragma mark - TaskUserInfoItem
@interface TaskUserInfoItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskActivityUserInfoItem
@interface TaskActivityUserInfoItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskInfoItem
@interface TaskInfoItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskActivityInfoItem
@interface TaskActivityInfoItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskPhotoItem
@interface TaskPhotoItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskActionsItem
@interface TaskActionsItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskActivityActionsItem
@interface TaskActivityActionsItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskLikesItem
@interface TaskLikesItem: TaskItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel;

@end

#pragma mark - TaskLikesListItem
@interface TaskLikesListItem: TaskItem

@property (nonatomic, strong) ZZTaskLikeModel *likeModel;

- (instancetype)initWithLikeModel:(ZZTaskLikeModel *)likeModel;

@end

#pragma mark - TaskSignuperItem
@interface TaskSignuperItem: TaskItem

- (instancetype)initWithSignUper:(ZZTaskSignuperModel *)signUper;

@property (nonatomic, strong) ZZTaskSignuperModel *signUper;

@end

#pragma mark - TaskEmptyItem
@interface TaskEmptyItem: TaskItem

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithEmptyTitle:(NSString *)title;

@end
