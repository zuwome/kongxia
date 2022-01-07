//
//  ZZKTVGiftsView.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVGiftsView.h"
#import "ZZGiftItemsCell.h"
#import "ZZGiftModel.h"

@interface ZZKTVGiftsView () <UICollectionViewDelegate, UICollectionViewDataSource, ZZGiftItemsCellDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, copy) NSArray<ZZGiftModel *> *giftsArr;

@property (nonatomic, strong) ZZGiftModel *selectedGiftModel;

@end

@implementation ZZKTVGiftsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - public Method
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
        _contentView.top = self.height - _contentView.height;
    } completion:^(BOOL finished) {
        _bgView.userInteractionEnabled = YES;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        _contentView.top = self.height;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark - private method
- (void)configureData {
    WeakSelf
    [_giftHelper fetchGiftsListWithCompleteBlock:^(NSArray<ZZGiftModel *> *giftsArr) {
        weakSelf.giftsArr = giftsArr;
        [_collectionView reloadData];
        
        if (_giftsArr.count % 8 == 0) {
            _pageControl.numberOfPages = _giftsArr.count / 8;
        }
        else {
            _pageControl.numberOfPages = _giftsArr.count / 8 + 1;
        }
    }];
}

- (void)sendGift {
    if (self.delegate && [self.delegate respondsToSelector:@selector(giftView:chooseGift:)]) {
        [self.delegate giftView:self chooseGift:_selectedGiftModel];
    }
}


#pragma mark - response method
- (void)hideView {
    [self hide];
}

- (void)confirmAction {
    [self sendGift];
    [self hideView];
}


#pragma mark - ZZGiftItemsCellDelegate
- (void)cell:(ZZGiftItemsCell *)view chooseGift:(ZZGiftModel *)giftModel {
    _selectedGiftModel = giftModel;
    [_collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_giftsArr.count % 8 == 0) {
        return _giftsArr.count / 8;
    }
    else {
        return _giftsArr.count / 8 + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZGiftItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZGiftItemCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSArray<ZZGiftModel *> *subArr = nil;
    NSInteger startIndex = 8 * indexPath.item;
    if (startIndex + 8 < _giftsArr.count) {
        subArr = [_giftsArr subarrayWithRange:NSMakeRange(startIndex, 8)];
    }
    else {
        subArr = [_giftsArr subarrayWithRange:NSMakeRange(startIndex, _giftsArr.count - startIndex)];
    }
    [cell configureGifts:subArr selectedGift:_selectedGiftModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, 220);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}


#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.seperateLine];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pageControl];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_titleLabel.mas_bottom).offset(11.5);
        make.height.equalTo(@0.5);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView).offset(-15.0);
        make.centerY.equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(59, 28));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_seperateLine.mas_bottom).offset(10.0);
        make.height.equalTo(@220);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.top.equalTo(_collectionView.mas_bottom).offset(5);
        make.height.equalTo(@7);
    }];
}



#pragma mark - getters and setters
- (void)setGiftHelper:(ZZGiftHelper *)giftHelper {
    _giftHelper = giftHelper;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_bgView addGestureRecognizer:tap];
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bottom, self.width, 293 + SafeAreaBottomHeight)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"送点小礼物，增加亲密度";
        _titleLabel.font = ADaptedFontMediumSize(14);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(229, 229, 229);
    }
    return _seperateLine;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ZZGiftItemsCell class] forCellWithReuseIdentifier:@"ZZGiftItemCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 2;
        _pageControl.pageIndicatorTintColor = [kBlackColor colorWithAlphaComponent:0.3];
        _pageControl.currentPageIndicatorTintColor = kGoldenRod;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"确定";
        _confirmBtn.normalTitleColor = UIColor.blackColor;
        _confirmBtn.titleLabel.font = ADaptedFontMediumSize(14);
        _confirmBtn.backgroundColor = kGoldenRod;
        _confirmBtn.layer.cornerRadius = 14.0;
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


@end
