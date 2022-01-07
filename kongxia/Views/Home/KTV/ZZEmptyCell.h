//
//  ZZEmptyCell.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/13.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZEmptyCell;
@protocol ZZEmptyCellDelegate <NSObject>

- (void)cellShowAction:(ZZEmptyCell *)cell;

@end

@interface ZZEmptyCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZEmptyCellDelegate> delegate;

- (void)configureData:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
