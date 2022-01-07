//
//  ZZKTVSongsSelectedVIew.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZKTVSongModel;
@class ZZKTVSongsSelectedVIew;

@protocol ZZKTVSongsSelectedVIewDelegate <NSObject>

- (void)view:(ZZKTVSongsSelectedVIew *)view confirmSelection:(NSArray<ZZKTVSongModel *> *)songs;

- (void)viewClearAll:(ZZKTVSongsSelectedVIew *)view;

- (void)view:(ZZKTVSongsSelectedVIew *)view editSong:(ZZKTVSongModel *)model;

@end

@interface ZZKTVSongsSelectedVIew : UIView

@property (nonatomic, weak) id<ZZKTVSongsSelectedVIewDelegate> delegate;

- (instancetype)initWithSongs:(NSArray<ZZKTVSongModel *> *)songs;

- (void)show;

@end

