//
//  ZZNewHomeRentEntryCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZNewHomeRentEntryCell;

@protocol ZZNewHomeRentEntryCellDelegate <NSObject>

- (void)cellShowRent:(ZZNewHomeRentEntryCell *)cell;

@end

@interface ZZNewHomeRentEntryCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZNewHomeRentEntryCellDelegate> delegate;

- (void)configureTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end

