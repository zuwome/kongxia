//
//  ZZPostTaskPhotoCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZPostTaskCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PostTaskItem;
@class ZZPostTaskPhotoCell;

@protocol ZZPostTaskPhotoCellDelegate <NSObject>

- (void)cell:(ZZPostTaskPhotoCell *)cell selectedIndex:(NSInteger)index;

@end

@interface ZZPostTaskPhotoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZPostTaskPhotoCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end

@interface ZZPostTaskPhotoView: UIImageView

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *photoImageView;

@end

NS_ASSUME_NONNULL_END
