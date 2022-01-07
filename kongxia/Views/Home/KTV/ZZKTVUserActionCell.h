//
//  ZZKTVUserActionCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVUserActionCell;
@class ZZKTVModel;
@class ZZKTVReceiveUserModel;
@class ZZKTVLeadSongModel;

@protocol ZZKTVUserActionCellDelegate <NSObject>

- (void)cell:(ZZKTVUserActionCell *)cell chat:(id)model;

- (void)cell:(ZZKTVUserActionCell *)cell sendGift:(id)model;

@end

@interface ZZKTVUserActionCell : ZZTableViewCell

@property (nonatomic, strong) ZZKTVReceiveUserModel *receiverModel;

@property (nonatomic, strong) ZZKTVLeadSongModel *songModel;

@property (nonatomic, weak) id<ZZKTVUserActionCellDelegate> delegate;

@end

