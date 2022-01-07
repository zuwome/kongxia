//
//  ZZTaksDetailsViewModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTaskModel.h"
#import "ZZTaksListViewModel.h"
#import "ZZTaskConfig.h"

@class ZZTaksDetailsViewModel;

@protocol ZZTaksDetailsViewModelDelegate <NSObject>

- (void)viewModel:(ZZTaksDetailsViewModel *)model changeTitle:(NSString *)title;

- (void)viewModel:(ZZTaksDetailsViewModel *)model chatWith:(ZZUser *)user;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showPhotoWith:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showPhotoWith:(ZZTaskModel *)task selecteIdx:(NSInteger)index;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showDetailWith:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showUserInfoWith:(ZZUser *)user isPick:(BOOL)isPick;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showLocations:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showMoreLikedUsers:(ZZTaskModel *)task;

- (void)viewModelUserDidPicked:(ZZTaksDetailsViewModel *)model picked:(ZZUser *)user;

- (void)viewModelUserDidPicked:(ZZTaksDetailsViewModel *)model;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showUploadFaceVC:(ZZTaskModel *)task;

- (void)viewModel:(ZZTaksDetailsViewModel *)model showPriceDetails:(ZZTaskModel *)task;

- (void)taskStatusDidChanged:(ZZTaksDetailsViewModel *)model;

/**
 新版的选完人去付尾款
 */
- (void)viewmodel:(ZZTaksDetailsViewModel *)model gotoPay:(NSArray *)selectIDs;

@end

@interface ZZTaksDetailsViewModel : NSObject

@property (nonatomic, weak) id<ZZTaksDetailsViewModelDelegate> delegate;

@property (nonatomic, assign) TaskListType currentListType;

@property (nonatomic, assign) TaskType taskType;

@property (nonatomic, strong) ZZTaskModel *task;

- (instancetype)initWithTaskModel:(ZZTaskModel *)task tableView:(UITableView *)tableView indexPath:(NSIndexPath *)taskIndexPath taskType:(TaskType)taskType;

- (instancetype)initWithTaskID:(NSString *)taskID tableView:(UITableView *)tableView;

- (void)taskStatusDidChangedWithAction:(TaskAction)action;

- (void)clearPicked;

/*
 完成选人去付款
 */
- (void)completeSelect;

/*
 *  每次进入详情页的时候要去判断是否需要弹出提示
 */
- (void)showAlertView;

- (void)didPickUser:(ZZUser *)user;


@end

#pragma mark - TaskSection
@interface TaskSection: NSObject

@property (nonatomic, assign) TaskItemType type;

@property (nonatomic, copy) NSString *sectionTitle;

@property (nonatomic, copy) NSArray<TaskItem *> *items;

- (instancetype)initWithItems:(NSArray<TaskItem *> *)items;

@end
