//
//  ZZAllTopicsViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTaskConfig.h"
NS_ASSUME_NONNULL_BEGIN

@class ZZAllTopicsViewController;
@class ZZSkill;

@protocol ZZAllTopicsViewControllerDelegate <NSObject>

- (void)allTopicsController:(ZZAllTopicsViewController *)controller didChooseSkill:(ZZSkill *)skill;

@end

@interface ZZAllTopicsViewController : ZZViewController

@property (nonatomic, weak) id<ZZAllTopicsViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isFromSkillSelectView;

@property (nonatomic, assign) BOOL shouldPopBack;

@property (nonatomic, assign) TaskType taskType;

@end

NS_ASSUME_NONNULL_END
