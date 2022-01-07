//
//  ZZRankingCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZRankingCell;
@protocol ZZRankingCellDelegate <NSObject>

- (void)cell:(ZZRankingCell *)view showUserInfo:(ZZUser *)userInfo;

- (void)cell:(ZZRankingCell *)view goChat:(ZZUser *)userInfo;

@end

@interface ZZRankingCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZRankingCellDelegate> delegate;

- (void)configureData:(ZZUser *)user index:(NSInteger)index;

@end

