//
//  ZZSignuperCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZSignuperCell;
@protocol ZZSignuperCellDelegate <NSObject>

- (void)cell:(ZZSignuperCell *)cell showSignUpUserInfoWith:(ZZUser *)user;

- (void)cell:(ZZSignuperCell *)cell goChat:(ZZUser *)user;

- (void)cell:(ZZSignuperCell *)cell pickUser:(TaskSignuperItem *)item;

@end


@interface ZZSignuperCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZSignuperCellDelegate> delegate;

@property (nonatomic, strong) TaskSignuperItem *item;

- (void)didPicked:(BOOL)didPicked;

@end

