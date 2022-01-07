//
//  ZZRookieRankCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZRookieRankCell;
@protocol ZZRookieRankCellDelegate <NSObject>

- (void)cell:(ZZRookieRankCell *)view showUserInfo:(ZZUser *)userInfo;

- (void)cell:(ZZRookieRankCell *)view goChat:(ZZUser *)userInfo;

@end


@interface ZZRookieRankCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZRookieRankCellDelegate> delegate;

- (void)configureData:(ZZUser *)user index:(NSInteger)index;

@end

