//
//  ZZTaskPhotosCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"
#import "ZZTasks.h"
@class ZZTaskPhotosCell;
@protocol ZZTaskPhotosCellDelegate <NSObject>

- (void)cell:(ZZTaskPhotosCell *)cell showPhotoWith:(ZZTaskModel *)task currentSelectIdx:(NSInteger)idx;

- (void)cell:(ZZTaskPhotosCell *)cell showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr;

@end

@interface ZZTaskPhotosCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskPhotosCellDelegate> delegate;

@property (nonatomic, strong) TaskItem *item;

@end

@interface ZZTaskPhotosImageView: UIView

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *photoImageView;

- (instancetype)initWithScale:(NSInteger)scale;

- (void)hideDes;

- (void)configureDataWithStatue:(TaskImageStatus)status imageStr:(NSString *)imageStr;

@end

