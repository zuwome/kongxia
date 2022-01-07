//
//  ZZTaskFreeActionCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/12.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaskConfig.h"

@class ZZTaskFreeActionCell;

@protocol ZZTaskFreeActionCellDelegate <NSObject>

- (void)cell:(ZZTaskFreeActionCell *)cell didSend:(ZZTaskModel *)taskModel;

@end

@interface ZZTaskFreeActionCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskFreeActionCellDelegate> delegate;

@property (nonatomic, strong) id info;

@end

