//
//  ZZTaskUserInfoCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskUserInfoCell;
@protocol ZZTaskUserInfoCellDelegate <NSObject>

- (void)cell:(ZZTaskUserInfoCell *)cell showUserInfoWith:(TaskUserInfoItem *)item;

- (void)cell:(ZZTaskUserInfoCell *)cell showMoreAction:(TaskUserInfoItem *)item;

- (void)cell:(ZZTaskUserInfoCell *)cell cancelAction:(TaskUserInfoItem *)item;

@end

@interface ZZTaskUserInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskUserInfoCellDelegate> delegate;

@property (nonatomic, strong) TaskUserInfoItem *item;

@property (nonatomic, strong) UIButton *moreBtn;

@end
