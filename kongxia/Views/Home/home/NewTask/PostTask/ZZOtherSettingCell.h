//
//  ZZOtherSettingCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZPostTaskCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostTaskItem;
@class ZZOtherSettingCell;

@protocol ZZOtherSettingCellDelegate <NSObject>

- (void)showRules:(ZZOtherSettingCell *)cell;

- (void)cell:(ZZOtherSettingCell *)cell didAgreed:(BOOL)didAgreed;

- (void)cell:(ZZOtherSettingCell *)cell anonymous:(BOOL)anonymous;

@end

@interface ZZOtherSettingCell : ZZTableViewCell

@property (nonatomic, strong) UITextView *rulesLabel;

@property (nonatomic, strong) UIButton *rulesBtn;

@property (nonatomic, strong) UIButton *anonymousBtn;

@property (nonatomic, weak) id<ZZOtherSettingCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
