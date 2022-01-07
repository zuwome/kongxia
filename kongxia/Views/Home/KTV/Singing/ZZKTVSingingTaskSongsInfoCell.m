//
//  ZZKTVSingTaskSongsInfoCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/3.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVSingingTaskSongsInfoCell.h"
#import "ZZKTVConfig.h"

@interface ZZKTVSingingTaskSongsInfoCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *singingTips1Label;

@property (nonatomic, strong) UIView *seperate1Line;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *singingTipsLabel;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UIButton *preBtn;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, assign) NSInteger currentSongsPage;

@property (nonatomic, copy) NSArray<UILabel *> *songTitleLabelArr;

@property (nonatomic, copy) NSArray<UILabel *> *songLyricsLabelArr;

@property (nonatomic, strong) UIButton *singBtn;

@end

@implementation ZZKTVSingingTaskSongsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _currentSongsPage = 0;
        [self layout];
    }
    return self;
}

-(CGFloat)caclulateWithBoundingRect:(NSString *)content {
    CGSize textSize2 = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 * 2, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{
                                              NSFontAttributeName:ADaptedFontSCBoldSize(17)
                                          }
                                             context:nil].size;
    return textSize2.height;
}

- (void)configureData {
    if (_taskDetailModel.task.is_anonymous == 2) {
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:_taskDetailModel.task.anonymous_avatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:45 andSize:CGSizeMake(90, 90)];
            _userIconImageView.image = roundImage;
        }];
    }
    else {
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_taskDetailModel.task.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:45 andSize:CGSizeMake(90, 90)];
            _userIconImageView.image = roundImage;
        }];
    }
    
    _singingTips1Label.text = [NSString stringWithFormat:@"唱歌成功可领取TA一个%@", _taskDetailModel.task.gift.name];
    
    if (_taskDetailModel.receiveStatus == 1 || _taskDetailModel.areGiftsAllCollected) {
        _seperate1Line.hidden = YES;
    }
    else {
        _seperate1Line.hidden = NO;
    }
    
    __block NSInteger page = 0;
    __block CGFloat maxHeight = 0.0;
    [_taskDetailModel.task.song_list enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < _songTitleLabelArr.count) {
            page++;
            
            CGFloat labelHeight = [self caclulateWithBoundingRect:obj.content];
            if (maxHeight < labelHeight) {
                maxHeight = labelHeight;
            }
            
            UILabel *songTitleLabel = _songTitleLabelArr[idx];
            songTitleLabel.text = [NSString stringWithFormat:@"《%@ --- %@》",obj.name, obj.auth];
            
            UILabel *lyricsLabel = _songLyricsLabelArr[idx];
            lyricsLabel.text = obj.content;
        }
    }];
    
    UIFont *font  = ADaptedFontMediumSize(14);
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(maxHeight + font.lineHeight + 36.0));
    }];
    
    _scrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 30 * 2) * page, 0.0);
    
    if (_taskDetailModel.task.song_list.count <= 1) {
        _singingTipsLabel.hidden = YES;
        _preBtn.hidden = YES;
        _nextBtn.hidden = YES;
    }
    else {
        _singingTipsLabel.hidden = NO;
        _preBtn.hidden = NO;
        _nextBtn.hidden = NO;
    }
}

#pragma mark - response method
- (void)preAction {
    if (_taskDetailModel.task.song_list.count <= 1) {
        return;
    }
    
    if (_currentSongsPage <= 0) {
        return;
    }
    _currentSongsPage -= 1;
    [_scrollView setContentOffset:CGPointMake(_currentSongsPage * (SCREEN_WIDTH - 30.0 * 2), 0.0) animated:YES];
}

- (void)nextAction {
    if (_taskDetailModel.task.song_list.count <= 1) {
        return;
    }
    
    if (_currentSongsPage >= 2) {
        return;
    }
    
    _currentSongsPage += 1;
    [_scrollView setContentOffset:CGPointMake(_currentSongsPage * (SCREEN_WIDTH - 30.0 * 2), 0.0) animated:YES];
}

- (void)startSingingAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:startSingSelectedSong:)]) {
        [self.delegate cell:self startSingSelectedSong:_currentSongsPage];
    }
}

- (void)showUserInfo {
    if (_taskDetailModel.task.is_anonymous == 2) {
        [ZZHUD showTaskInfoWithStatus:@"该用户已匿名"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showTaskOwner:)]) {
        [self.delegate cell:self showTaskOwner:_taskDetailModel];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.width;
    _currentSongsPage = currentIndex;
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(54, 54, 54);
    self.clipsToBounds = YES;
    
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.userIconImageView];
    [self.contentView addSubview:self.singingTips1Label];
    [self.contentView addSubview:self.seperate1Line];
    [self.contentView addSubview:self.singingTipsLabel];
    [self.contentView addSubview:self.preBtn];
    [self.contentView addSubview:self.nextBtn];
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.seperateLine];
    [self.contentView addSubview:self.singBtn];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(50.0);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [_singingTips1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_userIconImageView.mas_bottom).offset(10.0);
        make.left.right.equalTo(self.contentView);
    }];
    
    [_seperate1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30.0);
        make.right.equalTo(self.contentView).offset(-30.0);
        make.height.equalTo(@0.5);
        make.top.equalTo(_singingTips1Label.mas_bottom).offset(34.0);
    }];
    
    CGFloat widthHeight = [self caclulateWithBoundingRect:@"1\n2\n3\n4"];
    UIFont *font  = ADaptedFontMediumSize(14);
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_seperate1Line.mas_bottom);
        make.left.equalTo(self.contentView).offset(30.0);
        make.right.equalTo(self.contentView).offset(-30.0);
        make.height.equalTo(@(widthHeight + font.lineHeight + 36.0));
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.contentView).offset(30.0);
        make.right.equalTo(self.contentView).offset(-30.0);
        make.centerX.equalTo(self.contentView);
    }];

    [_singingTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_seperateLine.mas_bottom).offset(15.0);
        make.width.equalTo(@90);
    }];

    [_preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_singingTipsLabel);
        make.right.equalTo(_singingTipsLabel.mas_left).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];

    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_singingTipsLabel);
        make.left.equalTo(_singingTipsLabel.mas_right).offset(10.0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];

    [_singBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_singingTipsLabel.mas_bottom).offset(64.0);
        make.size.mas_equalTo(CGSizeMake(67, 67));
        make.bottom.equalTo(self.contentView                                                                                                                                                                                                           ).offset(-32.0);
    }];

    [self initScrollViewContents];
}

- (void)initScrollViewContents {
    NSMutableArray *titleLabelArr = @[].mutableCopy;
    NSMutableArray *lyricsLabelArr = @[].mutableCopy;
    for (NSInteger i = 0; i < 3; i ++) {
        
        UILabel *lyricsLabel = [[UILabel alloc] init];
        lyricsLabel.font = ADaptedFontSCBoldSize(17);
        lyricsLabel.textColor = RGBACOLOR(255, 255, 255, 1);
        lyricsLabel.numberOfLines = 0;
        lyricsLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:lyricsLabel];
        [lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scrollView).offset((SCREEN_WIDTH - 30 * 2) * i);
            make.top.equalTo(_scrollView).offset(12.0);
            make.width.equalTo(@(SCREEN_WIDTH - 30 * 2));
        }];
        
        UILabel *songTitleLabel = [[UILabel alloc] init];
        songTitleLabel.font = ADaptedFontMediumSize(14);
        songTitleLabel.textColor = RGBACOLOR(255, 255, 255, 0.6);
        songTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:songTitleLabel];
        [songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(lyricsLabel);
            make.top.equalTo(lyricsLabel.mas_bottom).offset(12);
//            make.bottom.equalTo(_scrollView);//.offset(12);
            make.width.equalTo(@((SCREEN_WIDTH - 30.0 * 2)));
        }];
        
        [titleLabelArr addObject:songTitleLabel];
        [lyricsLabelArr addObject:lyricsLabel];
    }
    
    _songTitleLabelArr = titleLabelArr.copy;
    _songLyricsLabelArr = lyricsLabelArr.copy;
}

#pragma mark - getters and setters
- (void)setTaskDetailModel:(ZZKTVDetailsModel *)taskDetailModel {
    _taskDetailModel = taskDetailModel;
    [self configureData];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bgChangpaxiangqing"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UILabel *)singingTips1Label {
    if (!_singingTips1Label) {
        _singingTips1Label = [[UILabel alloc] init];
        _singingTips1Label.text = @"唱歌成功可领取TA一个";
        _singingTips1Label.font = ADaptedFontMediumSize(15);
        _singingTips1Label.textColor = RGBCOLOR(244, 203, 7);
        _singingTips1Label.textAlignment = NSTextAlignmentCenter;
    }
    return _singingTips1Label;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_userIconImageView addGestureRecognizer:tap];
        _userIconImageView.userInteractionEnabled = YES;
    }
    return _userIconImageView;
}

- (UIView *)seperate1Line {
    if (!_seperate1Line) {
        _seperate1Line = [[UIView alloc] init];
        _seperate1Line.backgroundColor = RGBCOLOR(89, 89, 89);
    }
    return _seperate1Line;
}


- (UILabel *)singingTipsLabel {
    if (!_singingTipsLabel) {
        _singingTipsLabel = [[UILabel alloc] init];
        _singingTipsLabel.text = @"滑动换一首";
        _singingTipsLabel.font = [UIFont systemFontOfSize:17.0];
        _singingTipsLabel.textColor = UIColor.whiteColor;
    }
    return _singingTipsLabel;
}

- (UIButton *)preBtn {
    if (!_preBtn) {
        _preBtn = [[UIButton alloc] init];
        _preBtn.normalImage = [UIImage imageNamed:@"icHuadongZuobian"];
        [_preBtn addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        _nextBtn.normalImage = [UIImage imageNamed:@"icHuadongYoubian"];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 30 * 2) * 3, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(89, 89, 89);
    }
    return _seperateLine;
}

- (UIButton *)singBtn {
    if (!_singBtn) {
        _singBtn = [[UIButton alloc] init];
        _singBtn.normalImage = [UIImage imageNamed:@"icChangge"];
        _singBtn.layer.cornerRadius = 67 / 2;
        [_singBtn addTarget:self action:@selector(startSingingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singBtn;
}


@end
