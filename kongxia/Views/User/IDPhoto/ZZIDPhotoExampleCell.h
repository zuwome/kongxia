//
//  ZZIDPhotoExampleCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZIDPhotoExampleCell;

@protocol ZZIDPhotoExampleCellDelegate <NSObject>

- (void)cell:(ZZIDPhotoExampleCell *)cell shouldExampleOf:(NSInteger)index;

@end

@interface ZZIDPhotoExampleCell : ZZTableViewCell

@property (nonatomic,   weak) id<ZZIDPhotoExampleCellDelegate> delegate;

- (void)tips:(NSString *)tips;

@end

NS_ASSUME_NONNULL_END
