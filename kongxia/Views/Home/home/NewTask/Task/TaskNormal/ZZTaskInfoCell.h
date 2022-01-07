//
//  ZZTaskInfoCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskInfoCell;
@protocol ZZTaskInfoCellDelegate <NSObject>

- (void)cell:(ZZTaskInfoCell *)cell showLocations:(ZZTaskModel *)task;

- (void)cell:(ZZTaskInfoCell *)cell showPriceDetails:(ZZTaskModel *)task;

@end

@interface ZZTaskInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskInfoCellDelegate> delegate;

@property (nonatomic, strong) TaskItem *item;

@end


