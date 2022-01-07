//
//  ZZIDPhotoAddCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZIDPhotoAddCell;

@protocol ZZIDPhotoAddCellDelegate <NSObject>

- (void)cell:(ZZIDPhotoAddCell *)cell shouldAddPhoto:(BOOL)shouldAdd;

@end

@interface ZZIDPhotoAddCell : ZZTableViewCell

@property (nonatomic,   weak) id<ZZIDPhotoAddCellDelegate> delegate;

- (void)idImage:(nullable UIImage *)image;

- (void)idImageStr:(NSString *)imageStr;

- (void)desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
