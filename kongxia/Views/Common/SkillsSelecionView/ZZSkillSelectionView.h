//
//  ZZSkillSelectionView.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSkill.h"

NS_ASSUME_NONNULL_BEGIN
@class SkillSelectionHeadView;
@class SkillSelectionFooterView;
@class SkillSelectionView;
@class SkillView;

@protocol ZZSkillSelectionViewDelegate <NSObject>

@end

@interface ZZSkillSelectionView : UIView

+ (instancetype)showsIn:(UIViewController *)viewController taskType:(TaskType)taskType;

- (instancetype)initWithTaskType:(TaskType)taskType;

@end

@interface SkillSelectionView : UIView

@property (nonatomic, strong) SkillSelectionHeadView *headerView;

@property (nonatomic, strong) SkillSelectionFooterView *footerView;

@property (nonatomic, strong) UIView *skillsView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat totalHeight;

- (instancetype)initWithSkillsArray:(NSArray<ZZSkill *> *)skillsArray frame:(CGRect)frame;

@end

@interface SkillSelectionHeadView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface SkillSelectionFooterView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UILabel *desLabel;

@end

@interface SkillItemView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) ZZSkill *skill;

- (instancetype)initWithIsAll:(BOOL)isAll;

@end

NS_ASSUME_NONNULL_END
