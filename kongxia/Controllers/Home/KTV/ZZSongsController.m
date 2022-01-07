//
//  ZZSongsListController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSongsController.h"
#import "ZZSongsListController.h"

#import "ZZKTVSongsSelectedVIew.h"
#import "JXCategoryView.h"

#import "ZZKTVConfig.h"

@interface ZZSongsController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, ZZSongsListControllerDelegate, ZZKTVSongsSelectedVIewDelegate>

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) ZZKTVSongListResponesModel *repsonseModel;

@property (nonatomic, strong) JXCategoryTitleView *titleView;

@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UILabel *selectedCountsLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ZZKTVSongsSelectedVIew *selectedView;

@end

@implementation ZZSongsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _maxCount = 3;
    _pageIndex = 1;
    [self fetchSongLists];
    [self layout];
}


- (void)configureData {
    NSMutableArray *mArr = @[].mutableCopy;
    
    [_repsonseModel.typeList enumerateObjectsUsingBlock:^(ZZKTVSongTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isNullString(obj.name)) {
            [mArr addObject:obj.name];
        }
    }];
    
    _titleView.titles = mArr.copy;
    _titleView.averageCellSpacingEnabled = YES;
    
    [_titleView reloadData];
    
    id controller = _containerView.validListDict[@(_titleView.selectedIndex)];
    if (controller && [controller isKindOfClass:[ZZSongsListController class]]) {
        ZZSongsListController *listView = (ZZSongsListController *)controller;
        listView.selectedSongs = _selectedSongs;
        [listView reloadData];
    }
}

- (void)didSelectSong:(ZZKTVSongModel *)songModel {
    BOOL isSelected = NO;
    NSMutableArray<ZZKTVSongModel *> *songsM = _selectedSongs.mutableCopy;
    if (!songsM) {
        songsM = @[].mutableCopy;
    }
    
    if (songsM.count == 0) {
        [songsM addObject:songModel];
        isSelected = YES;
    }
    else {
        __block BOOL didSelecteSong = NO;
        __block NSInteger index = -1;
        [songsM enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj._id isEqualToString:songModel._id]) {
                didSelecteSong = YES;
                index = idx;
                *stop = YES;
            }
        }];
        
        if (didSelecteSong) {
            [songsM removeObjectAtIndex:index];
        }
        else {
            if (songsM.count == _maxCount) {
                [ZZHUD showTaskInfoWithStatus:@"最多只能选择3首"];
            }
            else {
                [songsM addObject:songModel];
                isSelected = YES;
            }
        }
    }
    songModel.isSelected = isSelected;
    _selectedSongs = songsM.copy;

    [self editSelecLabel];
    
    id controller = _containerView.validListDict[@(_titleView.selectedIndex)];
    if (controller && [controller isKindOfClass:[ZZSongsListController class]]) {
        ZZSongsListController *listView = (ZZSongsListController *)controller;
        listView.selectedSongs = _selectedSongs;
        [listView reloadData];
    }
}

- (void)editSelecLabel {
    if (_selectedSongs.count == 0) {
        _selectedCountsLabel.hidden = YES;
    }
    else {
        _selectedCountsLabel.hidden = NO;
        _selectedCountsLabel.text = [NSString stringWithFormat:@"%ld", _selectedSongs.count];
    }
}


#pragma mark - response method
- (void)confirmSelect {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:choosedSongs:)]) {
        [self.delegate controller:self choosedSongs:_selectedSongs];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ZZKTVSongsSelectedVIewDelegate
- (void)view:(ZZKTVSongsSelectedVIew *)view editSong:(ZZKTVSongModel *)model {
    if (_selectedSongs.count == 0) {
        return;
    }
    
    NSMutableArray *songsM = _selectedSongs.mutableCopy;
    
    __block BOOL didSelecteSong = NO;
    __block NSInteger index = -1;
    [songsM enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj._id isEqualToString:model._id]) {
            didSelecteSong = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (didSelecteSong) {
        [songsM removeObjectAtIndex:index];
        [self relayout];
        _selectedSongs = songsM.copy;
    }
    
    [self editSelecLabel];
    
    id controller = _containerView.validListDict[@(_titleView.selectedIndex)];
    if (controller && [controller isKindOfClass:[ZZSongsListController class]]) {
        ZZSongsListController *listView = (ZZSongsListController *)controller;
        listView.selectedSongs = _selectedSongs;
        [listView reloadData];
    }
}

- (void)viewClearAll:(ZZKTVSongsSelectedVIew *)view {
    _selectedSongs = nil;
    [self hideSelectedViews];
    
    [self editSelecLabel];
    
    id controller = _containerView.validListDict[@(_titleView.selectedIndex)];
    if (controller && [controller isKindOfClass:[ZZSongsListController class]]) {
        ZZSongsListController *listView = (ZZSongsListController *)controller;
        listView.selectedSongs = _selectedSongs;
        [listView reloadData];
    }
}


#pragma mark - ZZSongsListControllerDelegate
- (void)controller:(ZZSongsListController *)controller didSelectSong:(ZZKTVSongModel *)model {
    [self didSelectSong:model];
}


#pragma mark - JXCategoryListContainerViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    id controller = _containerView.validListDict[@(_titleView.selectedIndex)];
    if (controller && [controller isKindOfClass:[ZZSongsListController class]]) {
        ZZSongsListController *listView = (ZZSongsListController *)controller;
        listView.selectedSongs = _selectedSongs;
        [listView reloadData];
    }
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    ZZSongsListController *list = [[ZZSongsListController alloc] init];
    list.delegate = self;
    list.typeModel = _repsonseModel.typeList[index];
//    if (index == 0 && list.isFirstTime) {
//        [list configureData:_repsonseModel.songList];
//    }
    list.selectedSongs = _selectedSongs;
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.repsonseModel.typeList.count;
}


#pragma mark - Request
- (void)fetchSongLists {
    [ZZKTVServer fetchSongListWithSongType:nil
                                 pageIndex:_pageIndex
                           completeHandler:^(BOOL isSuccess, ZZKTVSongListResponesModel *responseModel) {
            
        if (!isSuccess) {
            return;
        }
        _repsonseModel = responseModel;
        
        [self configureData];
    }];
}


#pragma mark - Layout
- (void)layout {
    self.title = @"唱歌领礼物";
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.selectedBtn];
    [self.view addSubview:self.selectedCountsLabel];
    
    _selectedBtn.frame = CGRectMake(0.0, self.view.bounds.size.height - SafeAreaBottomHeight - NAVIGATIONBAR_HEIGHT - 50.0, 125, 50.0);
    _confirmBtn.frame = CGRectMake(_selectedBtn.right, _selectedBtn.top, SCREEN_WIDTH - 125, 50.0);
    _containerView.frame = CGRectMake(0, 44.0, self.view.bounds.size.width, _selectedBtn.top - 44.0);
    
    
    [_selectedCountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_selectedBtn).offset(-36.0);
        make.top.equalTo(_selectedBtn).offset(8.0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(_confirmBtn);
    }];
}

- (void)showSelectedViews {
    if (_selectedSongs.count == 0) {
        return;
    }
    
    _selectedView = [[ZZKTVSongsSelectedVIew alloc] initWithSongs:_selectedSongs];
    _selectedView.delegate = self;
    [self.view addSubview:_selectedView];
    
    [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        [_selectedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_selectedBtn.mas_top).offset(-_selectedView.height);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)relayout {
    [self.view layoutIfNeeded];
    [_selectedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_selectedBtn.mas_top).offset(-_selectedView.height);
    }];
}

- (void)hideSelectedViews {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        [_selectedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_selectedView removeFromSuperview];
        _selectedView = nil;
    }];
}

#pragma mark - getters and setters
- (void)setSelectedSongs:(NSMutableArray<ZZKTVSongModel *> *)selectedSongs {
    _selectedSongs = selectedSongs;
    [self editSelecLabel];
    
    id controller = _containerView.validListDict[@(_titleView.selectedIndex)];
    if (controller && [controller isKindOfClass:[ZZSongsListController class]]) {
        ZZSongsListController *listView = (ZZSongsListController *)controller;
        listView.selectedSongs = _selectedSongs;
        [listView reloadData];
    }
}

- (JXCategoryTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44.0)];
        _titleView.delegate = self;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorWidth = 20;
        _titleView.indicators = @[lineView];
    }
    return _titleView;
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        //关联到categoryView
        self.titleView.listContainer = _containerView;
    }
    return _containerView;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [[UIButton alloc] init];
        _selectedBtn.normalTitle = @"已选";
        _selectedBtn.normalTitleColor = UIColor.whiteColor;
        _selectedBtn.titleLabel.font = ADaptedFontSCBoldSize(16);
        _selectedBtn.backgroundColor = RGBCOLOR(255, 103, 2);
        [_selectedBtn addTarget:self action:@selector(showSelectedViews) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}

- (UILabel *)selectedCountsLabel {
    if (!_selectedCountsLabel) {
        _selectedCountsLabel = [[UILabel alloc] init];
        _selectedCountsLabel.font = ADaptedFontSCBoldSize(13);
        _selectedCountsLabel.backgroundColor = kGoldenRod;
        _selectedCountsLabel.textColor = UIColor.blackColor;
        _selectedCountsLabel.layer.cornerRadius = 7.0;
        _selectedCountsLabel.textAlignment = NSTextAlignmentCenter;
        _selectedCountsLabel.layer.masksToBounds = YES;
        _selectedCountsLabel.hidden = _selectedSongs.count == 0;
        _selectedCountsLabel.text = [NSString stringWithFormat:@"%ld", _selectedSongs.count];
    }
    return _selectedCountsLabel;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"选好了";
        _confirmBtn.normalTitleColor = UIColor.whiteColor;
        _confirmBtn.titleLabel.font = ADaptedFontSCBoldSize(16);
        _confirmBtn.backgroundColor = kGoldenRod;
        [_confirmBtn addTarget:self action:@selector(confirmSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectedViews)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

@end
