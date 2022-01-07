//
//  ZZTaskLiskesCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskLiskesCell;
@protocol ZZTaskLiskesCellDelegate <NSObject>

- (void)cell:(ZZTaskLiskesCell *)cell showLikedUserInfoWith:(ZZUser *)user;

- (void)cell:(ZZTaskLiskesCell *)cell showMoreUsers:(TaskLikesItem *)item;

@end

@interface ZZTaskLiskesCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskLiskesCellDelegate> delegate;

@property (nonatomic, strong) TaskItem *item;

@end


