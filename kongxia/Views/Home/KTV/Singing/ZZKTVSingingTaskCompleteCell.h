//
//  ZZKTVSingingTaskCompleteCell.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVDetailsModel;
@class ZZKTVSingingTaskCompleteCell;

@protocol ZZKTVSingingTaskCompleteCellDelegate <NSObject>

- (void)comepleteCellStartToPlay:(ZZKTVSingingTaskCompleteCell *)cell;

- (void)comepleteCellGoPostTask:(ZZKTVSingingTaskCompleteCell *)cell;

- (void)completeCell:(ZZKTVSingingTaskCompleteCell *)cell showTaskOwner:(ZZKTVDetailsModel *)taskModel;

@end


@interface ZZKTVSingingTaskCompleteCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVSingingTaskCompleteCellDelegate> delegate;

@property (nonatomic, strong) ZZKTVDetailsModel *taskDetailModel;

@end

