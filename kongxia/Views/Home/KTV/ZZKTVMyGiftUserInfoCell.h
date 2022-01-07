//
//  ZZKTVMyGiftUserInfoCell.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZKTVConfig.h"

@class ZZKTVMyGiftUserInfoCell;
@protocol ZZKTVMyGiftUserInfoCellDelegate <NSObject>

- (void)cell:(ZZKTVMyGiftUserInfoCell *)cell showUserInfo:(ZZKTVReceivedGiftModel *)model;

- (void)cell:(ZZKTVMyGiftUserInfoCell *)cell startPlay:(ZZKTVReceivedGiftModel *)model;

@end


@interface ZZKTVMyGiftUserInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVMyGiftUserInfoCellDelegate> delegate;

@property (nonatomic, strong) ZZKTVReceivedGiftModel *giftModel;

@property (nonatomic, assign) double profite_rate;

@end

