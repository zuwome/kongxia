//
//  ZZSongsListController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSongsController.h"

@class ZZSongsController;
@class ZZKTVSongModel;
@protocol ZZSongsControllerDelegate <NSObject>

- (void)controller:(ZZSongsController *)controller choosedSongs:(NSArray *)songs;

@end


@interface ZZSongsController : ZZViewController

@property (nonatomic, weak) id<ZZSongsControllerDelegate> delegate;

@property (nonatomic, copy) NSMutableArray<ZZKTVSongModel *> *selectedSongs;

@end

