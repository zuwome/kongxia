//
//  ZZTasksViewController.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTasks.h"

@interface ZZTasksViewController : ZZViewController

@property (nonatomic, assign) BOOL onlyShowMyActivities;

@property (nonatomic, assign) BOOL taskFreeJumpToMyList;

- (instancetype)initWithTaskType:(TaskType)type;
/**
 显示我的活动列表页面
 */
- (void)showMyActivities;

@end


@class ZZTasksTitleHeader;

@protocol ZZTasksTitleHeaderDelegate <NSObject>

- (void)header:(ZZTasksTitleHeader *)header changedToIndex:(NSInteger)index;

@end

@interface ZZTasksTitleHeader : UIView

@property (nonatomic, weak) id<ZZTasksTitleHeaderDelegate> delegate;

- (void)scrollToIndex:(NSInteger)index;

@end
