//
//  ZZKTVSongCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVSongModel;
@class ZZKTVSongCell;

@protocol ZZKTVSongCellDelegate <NSObject>

- (void)cell:(ZZKTVSongCell *)cell addSong:(ZZKTVSongModel *)songModel;

@end

@interface ZZKTVSongCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVSongCellDelegate> delegate;

- (void)configureSong:(ZZKTVSongModel *)song;

- (void)setDidSelect:(BOOL)isSelect;

@end

