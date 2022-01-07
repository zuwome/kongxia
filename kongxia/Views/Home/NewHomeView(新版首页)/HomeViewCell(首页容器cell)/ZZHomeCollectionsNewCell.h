//
//  ZZHomeCollectionsNewCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/6/13.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZNewHomeBaseCell.h"
#import "ZZNewHomeBaseCell.h"
#import "kongxia-Swift.h"

@protocol ZZHomeCollectionsNewCellDelegate <NSObject>

- (void)showTasks;

- (void)showRanks;

- (void)showPopularityRanks;

@end

@interface ZZHomeCollectionsNewCell : ZZNewHomeBaseCell

@property (nonatomic, weak) id<ZZHomeCollectionsNewCellDelegate> delegate;

- (void)configureTopThree:(ZZRankResponeModel *)rankResponeMode;

@end

