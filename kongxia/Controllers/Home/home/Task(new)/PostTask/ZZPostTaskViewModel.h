//
//  ZZPostTaskViewModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTasks.h"
#import "ZZRentDropdownModel.h"
#import "ZZTaskConfig.h"

@class ZZPostTaskViewModel;
@class ZZOtherSettingCell;
@protocol ZZPostTaskViewModelDelegate <NSObject>
@optional

- (void)showSkillThemes:(ZZPostTaskViewModel *)model;

- (void)showCityView:(ZZPostTaskViewModel *)model;

- (void)showLocationView:(ZZPostTaskViewModel *)model;

- (void)choosePrice:(ZZPostTaskViewModel *)model;

- (void)chooseTime:(ZZPostTaskViewModel *)model;

- (void)chooseDuration:(ZZPostTaskViewModel *)model;

- (void)showRules:(ZZPostTaskViewModel *)model;

- (void)viewModel:(ZZPostTaskViewModel *)model showSelection:(BOOL)canDelete;

- (void)viewModel:(ZZPostTaskViewModel *)model orderID:(NSString *)orderID price:(NSString *)price;

- (void)viewModel:(ZZPostTaskViewModel *)model taskFreeDidInputContent:(NSString *)content;
 
- (void)taskFreePublished:(ZZPostTaskViewModel *)model;

- (void)viewModel:(ZZPostTaskViewModel *)model chooseTags:(ZZSkill *)skill;

@end

@interface ZZPostTaskViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<ZZPostTaskViewModelDelegate> delegate;

@property (nonatomic, assign) BOOL isFirstTime;

@property (nonatomic, assign) TaskType taskType;

// 发布活动步骤
@property (nonatomic, assign) TaskActionStep currentStep;

// 选择的技能
@property (nonatomic, strong) ZZSkill *currentSkill;

// 详情
@property (nonatomic, copy) NSString *content;

// 匿名
@property (nonatomic, assign) BOOL isAnonymous;

// 性别
@property (nonatomic, assign) NSInteger gender;

// 城市
@property (nonatomic, strong) ZZCity *city;

// 位置
@property (nonatomic, strong) ZZRentDropdownModel *location;

// 开始时间介绍
@property (nonatomic,   copy) NSString *startTimeDescript;

// 开始时间
@property (nonatomic,   copy) NSString *startTime;

// 时长
@property (nonatomic, assign) NSInteger durantion;

// 活动时常介绍
@property (nonatomic, copy) NSString *durantionDes;

// 价格
@property (nonatomic,   copy) NSString *price;

// 照片
@property (nonatomic, copy) NSArray<ZZPhoto *> *photosArray;

// 活动是否同意规则
@property (nonatomic, assign) BOOL didAgreed;

@property (nonatomic, strong) ZZOtherSettingCell *cell;

/*
 通告的
 */
- (instancetype)initWithSkill:(ZZSkill *)skill taskType:(TaskType)taskType;

/*
 从线下发布跳到通告的
*/
- (instancetype)initTaskType:(TaskType)taskType taskInfo:(NSDictionary *)taskInfo;

- (void)configTableView:(UITableView *)tableView;

- (void)chooseSkill:(ZZSkill *)skill;

- (void)updateSkillTags:(ZZSkill *)skill;

- (void)chooseCity:(ZZCity *)city;

- (void)chooseLocation:(ZZRentDropdownModel *)location;

- (void)choosePrice:(NSString *)price;

- (void)starTime:(NSString *)startTime startDescript:(NSString *)startTimeDescript durantion:(NSInteger)durantion;

- (void)starTime:(NSString *)startTime startDescript:(NSString *)startTimeDescript durationDes:(NSString *)durationDes;

- (void)configureDuration:(NSInteger)duration;

- (void)choosePhoto:(UIImage *)photo;


/**
 *  确认发布
 */
- (void)confirm;

- (void)publishPhotos;

@end

