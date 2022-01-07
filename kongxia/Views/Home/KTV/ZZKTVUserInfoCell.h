//
//  ZZKTVUserInfoCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
@class ZZKTVUserInfoCell;
@class ZZKTVModel;
@class ZZKTVDetailsModel;
@class ZZKTVLeadSongModel;
@class ZZKTVReceiveUserModel;

@protocol ZZKTVUserInfoCellDelegate <NSObject>

- (void)cell:(ZZKTVUserInfoCell *)cell showUserInfo:(id)model;

- (void)cell:(ZZKTVUserInfoCell *)cell startPlay:(id)model;

@end

@interface ZZKTVUserInfoCell : ZZTableViewCell

@property (nonatomic, strong) ZZKTVReceiveUserModel *receiverModel;

@property (nonatomic, strong) ZZKTVLeadSongModel *songModel;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, weak) id<ZZKTVUserInfoCellDelegate> delegate;

- (void)didReceivedGift:(BOOL)didReceived giftModel:(ZZGiftModel *)giftModel;

@end
