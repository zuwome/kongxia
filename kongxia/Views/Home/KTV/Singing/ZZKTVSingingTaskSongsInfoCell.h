//
//  ZZKTVSingTaskSongsInfoCell.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/3.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVModel;
@class ZZKTVDetailsModel;
@class ZZKTVSingingTaskSongsInfoCell;
@protocol ZZKTVSingingTaskSongsInfoCellDelegate <NSObject>

- (void)cell:(ZZKTVSingingTaskSongsInfoCell *)cell startSingSelectedSong:(NSInteger)index;

- (void)cell:(ZZKTVSingingTaskSongsInfoCell *)cell showTaskOwner:(ZZKTVDetailsModel *)taskModel;

@end

@interface ZZKTVSingingTaskSongsInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVSingingTaskSongsInfoCellDelegate> delegate;

@property (nonatomic, strong) ZZKTVDetailsModel *taskDetailModel;

@end

