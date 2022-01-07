//
//  ZZKTVChoosenSongCell.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVSongModel;
@class ZZKTVChoosenSongCell;

@protocol ZZKTVChoosenSongCellDelegate <NSObject>

- (void)cell:(ZZKTVChoosenSongCell *)cell addSong:(ZZKTVSongModel *)songModel;

@end

@interface ZZKTVChoosenSongCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVChoosenSongCellDelegate> delegate;

- (void)configureSong:(ZZKTVSongModel *)song;

@end


