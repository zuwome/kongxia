//
//  ZZPostTaskDefaultTableViewCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZPostTaskCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostTaskItem;

@interface ZZPostTaskDefaultTableViewCell : ZZTableViewCell

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
