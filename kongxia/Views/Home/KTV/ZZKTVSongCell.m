//
//  ZZKTVSongCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVSongCell.h"
#import "ZZKTVSongListView.h"

#import "ZZKTVConfig.h"

@interface ZZKTVSongCell ()<ZZKTVSongListViewDelegate>

@property (nonatomic, strong) ZZKTVSongListView *songView;

@end

@implementation ZZKTVSongCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureSong:(ZZKTVSongModel *)song {
    _songView.songModel = song;
}

- (void)setDidSelect:(BOOL)isSelect {
    [_songView setDidSelect:isSelect];
}

#pragma mark - UICollectionViewDelegate
- (void)view:(ZZKTVSongListView *)view addSong:(ZZKTVSongModel *)songModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:addSong:)]) {
        [self.delegate cell:self addSong:songModel];
    }
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.songView];
    [_songView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - getters and setters
- (ZZKTVSongListView *)songView {
    if (!_songView) {
        _songView = [[ZZKTVSongListView alloc] init];
        _songView.delegate = self;
    }
    return _songView;
}

@end
