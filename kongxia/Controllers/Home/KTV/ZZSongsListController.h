//
//  ZZSongsListController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

#import "JXCategoryView.h"

#import "ZZKTVConfig.h"

@class ZZSongsListController;
@protocol ZZSongsListControllerDelegate <NSObject>

- (void)controller:(ZZSongsListController *)controller didSelectSong:(ZZKTVSongModel *)model;

@end

@interface ZZSongsListController : ZZViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id<ZZSongsListControllerDelegate> delegate;

@property (nonatomic, strong) ZZKTVSongTypeModel *typeModel;

@property (nonatomic, assign) BOOL isPreLoaded;

@property (nonatomic, assign) BOOL isFirstTime;

@property (nonatomic, copy) NSArray<ZZKTVSongModel *> *selectedSongs;

- (void)reloadData;

- (void)configureData:(NSArray<ZZKTVSongModel *> *)songs;

@end
