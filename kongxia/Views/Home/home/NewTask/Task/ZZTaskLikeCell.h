//
//  ZZTaskLikeCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZTaskLikeModel;
@class ZZTaskLikeCell;

@protocol ZZTaskLikeCellDelegate <NSObject>

- (void)cell:(ZZTaskLikeCell *)cell showUserInfo:(ZZTaskLikeModel *)likeModel;

@end

@interface ZZTaskLikeCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskLikeCellDelegate> delegate;

@property (nonatomic, strong) ZZTaskLikeModel *likeModel;

@end

