//
//  ZZKTVChooseGiftCountsCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZTaskModel;
@class ZZKTVChooseGiftCountsCell;
@protocol ZZKTVChooseGiftCountsCellDelegate <NSObject>

- (void)cell:(ZZKTVChooseGiftCountsCell *)cell counts:(NSInteger)count;

@end


@interface ZZKTVChooseGiftCountsCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVChooseGiftCountsCellDelegate> delegate;

- (void)configureKTVModel:(ZZKTVModel *)model;

@end


