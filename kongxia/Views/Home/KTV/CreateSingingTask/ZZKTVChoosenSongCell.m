//
//  ZZKTVChoosenSongCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVChoosenSongCell.h"
#import "ZZKTVSongListView.h"

#import "ZZKTVConfig.h"

@interface ZZKTVChoosenSongCell ()<ZZKTVSongListViewDelegate>

@property (nonatomic, strong) ZZKTVSongListView *songView;

@end

@implementation ZZKTVChoosenSongCell

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
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.songView];
    [_songView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
    }];
}

#pragma mark - getters and setters
- (ZZKTVSongListView *)songView {
    if (!_songView) {
        _songView = [[ZZKTVSongListView alloc] init];
        _songView.delegate = self;
        _songView.backgroundColor = UIColor.whiteColor;
    }
    return _songView;
}
@end
