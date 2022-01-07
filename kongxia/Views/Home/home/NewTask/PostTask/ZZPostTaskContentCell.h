//
//  ZZPostTaskContentCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZPostTaskCellModel.h"

@class PostTaskItem;
@class ZZPostTaskContentCell;

@protocol ZZPostTaskContentCellDelegate <NSObject>

- (void)cell:(ZZPostTaskContentCell *)cell didInputContent:(NSString *)content;

- (void)cell:(ZZPostTaskContentCell *)cell cellHeight:(CGFloat)cellHeight;

@end

@interface ZZPostTaskContentCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZPostTaskContentCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) CGFloat limitHeight;

- (void)configureHeight:(NSString *)str isDefault:(BOOL)isDefault;

@end


