//
//  ZZSettingSubtitleSwitchCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/15.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZSettingSubtitleSwitchCell : ZZTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UISwitch *settingSwitch;

@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
