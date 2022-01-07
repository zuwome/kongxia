//
//  ZZKTVMyTasksCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVModel;
@class ZZKTVMyTasksCell;

@protocol ZZKTVMyTasksCellDelegate <NSObject>

- (void)cell:(ZZKTVMyTasksCell *)cell showDetails:(ZZKTVModel *)taskModel;

@end

@interface ZZKTVMyTasksCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVMyTasksCellDelegate> delegate;

@property (nonatomic, weak) ZZKTVModel *taskModel;

@end

