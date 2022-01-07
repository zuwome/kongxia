//
//  ZZPostTaskPriceCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZPostTaskCellModel;
@class ZZPostTaskPriceCell;
@protocol ZZPostTaskPriceCellDelegate <NSObject>

- (void)priceCellChoosePrice:(ZZPostTaskPriceCell *)cell;

@end


@interface ZZPostTaskPriceCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZPostTaskPriceCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end


