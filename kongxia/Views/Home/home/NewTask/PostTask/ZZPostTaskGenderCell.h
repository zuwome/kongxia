//
//  ZZPostTaskGenderCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZPostTaskCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostTaskItem;
@class ZZPostTaskGenderCell;

@protocol ZZPostTaskGenderCellDelegate <NSObject>

- (void)cell:(ZZPostTaskGenderCell *)cell chooseGender:(NSInteger)gender;

@end

@interface ZZPostTaskGenderCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZPostTaskGenderCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end

NS_ASSUME_NONNULL_END
