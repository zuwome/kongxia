//
//  ZZActivityUserInfoCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZActivityUserInfoCell;
@protocol ZZActivityUserInfoCellDelegate <NSObject>

- (void)cell:(ZZActivityUserInfoCell *)cell activityShowUserInfoWith:(TaskActivityUserInfoItem *)item;

- (void)cell:(ZZActivityUserInfoCell *)cell showMoreAction:(TaskUserInfoItem *)item;

@end

@interface ZZActivityUserInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZActivityUserInfoCellDelegate> delegate;

@property (nonatomic, strong) TaskActivityUserInfoItem *item;



@end


