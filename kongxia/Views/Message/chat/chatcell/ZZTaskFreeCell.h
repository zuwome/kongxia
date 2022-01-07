//
//  ZZTaskFreeCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/13.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaskConfig.h"
#import "ZZChatBaseModel.h"

@class ZZTaskFreeCell;

@protocol ZZTaskFreeCellDelegate <NSObject>

- (void)cell:(ZZTaskFreeCell *)cell didSelect:(ZZTask *)taskModel;

@end

@interface ZZTaskFreeCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskFreeCellDelegate> delegate;

- (void)configureModel:(ZZChatBaseModel *)model userAvatar:(NSString *)userAvatar;

@end
