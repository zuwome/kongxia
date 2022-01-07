//
//  ZZPostTaskThmemeCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZPostTaskCellModel;
@class ZZPostTaskThmemeCell;

@protocol ZZPostTaskThmemeCellDelegate <NSObject>

- (void)themeCellChooseTags:(ZZPostTaskThmemeCell *)cell;

@end


@interface ZZPostTaskThmemeCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZPostTaskThmemeCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end


