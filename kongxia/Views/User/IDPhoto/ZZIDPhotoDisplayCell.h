//
//  ZZIDPhotoDisplayCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZIDPhotoDisplayCell : ZZTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)idPhoto:(ZZIDPhoto *)photo
  hasRealAvatar:(BOOL)hasRealAvatar
       isMyself:(BOOL)isMyself
  canSeeIDPhoto:(BOOL)canSeeIDPhoto;

@end

NS_ASSUME_NONNULL_END
