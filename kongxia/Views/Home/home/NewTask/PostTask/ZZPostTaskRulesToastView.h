//
//  ZZInfoToastView.h
//  zuwome
//
//  Created by qiming xiao on 2019/2/14.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RulesType) {
    RulesTypePostTask, // 发布任务
    RulesTypePostActivity, // 发布活动
    RulesTypeAddSkill, // 添加技能
};

@class ZZPostTaskRulesToastView;

@protocol ZZPostTaskRulesToastViewDelegate <NSObject>

- (void)toastView:(ZZInfoToastView *)toastView;

@end

@interface ZZPostTaskRulesToastView : UIView

@property (nonatomic, assign) RulesType rulesType;

@property (nonatomic,   weak) id<ZZPostTaskRulesToastViewDelegate> delegate;

+ (instancetype)show;

+ (instancetype)showWithRulesType:(RulesType)rulesType;

@end


@interface ZZPostTaskRulesView: UIView

@property (nonatomic, assign) RulesType rulesType;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *datasArray;

- (instancetype)initWithRulesType:(RulesType)rulesType;

@end

