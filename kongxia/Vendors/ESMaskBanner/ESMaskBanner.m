//
//  ESMaskBanner.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ESMaskBanner.h"
#import "ESBackMask.h"
#import "ESCycleScrollCell.h"
#import "ESBannerModel.h"

#define ESIsIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)
#define ESNaviBarH ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88 : 64)

@interface ESMaskBanner() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) ESCycleScroll *cycleScroll;   //轮播图

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *frontImage;      //背景顶部图片

@property (nonatomic, strong) UIImageView *backImage;       //背景底部图片

@property (nonatomic, strong) UIView *maskView;             //banner背景遮罩

@property (nonatomic, strong) ESBackMask *leftBackMask;     //banner左侧遮罩层

@property (nonatomic, strong) ESBackMask *rightBackMask;    //banner右侧遮罩层

@property (nonatomic, assign) NSInteger currentIndex;       //当前所在页数

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat timerInterval;        //定时器循环周期

@property (nonatomic, assign) CGFloat transformInterval;    //比例缩放用时

@property (nonatomic, assign) CGFloat transformScale;       //缩放比例

@property (nonatomic, assign) CGFloat originScale;          //原始比例

@property (nonatomic, assign) CGFloat bannerWidth;          //banner宽度

@property (nonatomic, assign) CGFloat bannerHeight;         //banner高度

@end

@implementation ESMaskBanner

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bannerMarginTop = ESNaviBarH;
        self.transformScale = 0.85;
        self.originScale = 1;
        self.transformInterval = 0.2;
        self.timerInterval = 3;
        self.bannerWidth = frame.size.width;
        self.bannerHeight = frame.size.height;
        self.pageControlSelectColor = [UIColor blackColor];
        self.pageControlUnselectColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.backImage];
    [self addSubview:self.frontImage];
    [self addSubview:self.cycleScroll];
    [self addSubview:self.pageControl];
    //add mask
    self.frontImage.maskView = self.maskView;
    [self.maskView addSubview:self.leftBackMask];
    [self.maskView addSubview:self.rightBackMask];
    
    self.bannerArray = [NSArray array];
}

#pragma mark -- setter
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if (showPageControl) {
        self.pageControl.hidden = showPageControl ? NO : YES;
    }
}

- (void)setPageControlSelectImage:(UIImage *)pageControlSelectImage {
    _pageControlSelectImage = pageControlSelectImage;
    if (pageControlSelectImage) {
        [self.pageControl setValue:pageControlSelectImage forKeyPath:@"_currentPageImage"];
    }
}

- (void)setPageControlUnselectImage:(UIImage *)pageControlUnselectImage {
    _pageControlUnselectImage = pageControlUnselectImage;
    if (pageControlUnselectImage) {
        [self.pageControl setValue:pageControlUnselectImage forKeyPath:@"_pageImage"];
    }
}

- (void)setPageControlSelectColor:(UIColor *)pageControlSelectColor {
    _pageControlSelectColor = pageControlSelectColor;
    if (pageControlSelectColor) {
        [self.pageControl setCurrentPageIndicatorTintColor:pageControlSelectColor];
    }
}

- (void)setPageControlUnselectColor:(UIColor *)pageControlUnselectColor {
    _pageControlUnselectColor = pageControlUnselectColor;
    if (pageControlUnselectColor) {
        [self.pageControl setPageIndicatorTintColor:pageControlUnselectColor];
    }
}

- (void)setBannerArray:(NSArray *)bannerArray {
    if (bannerArray.count <= 0) {
        return;
    }
    //添加首尾实现简易轮播
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:bannerArray];
    [tempArray insertObject:[bannerArray lastObject] atIndex:0];
    [tempArray addObject:[bannerArray firstObject]];
    bannerArray = [NSArray arrayWithArray:tempArray];
    _bannerArray = bannerArray;
    [self.cycleScroll reloadData];
    [self.cycleScroll scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    //设置初始背景图片
    ESBannerModel *frontModel = self.bannerArray[1];
    ESBannerModel *backModel = self.bannerArray[2];
    [self.frontImage sd_setImageWithURL:[NSURL URLWithString:frontModel.backImage]];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:backModel.backImage]];
    //设置pageControl
    self.pageControl.numberOfPages = MAX(_bannerArray.count - 2, 0);
    self.pageControl.currentPage = 0;
    //首个显示的cell还原原始比例
    ESCycleScrollCell *cell = (ESCycleScrollCell *)[self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    if (cell == nil) {
        [self.cycleScroll layoutIfNeeded];
        cell = (ESCycleScrollCell *)[self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    }
    cell.transform = CGAffineTransformMakeScale(_originScale, _originScale);
    //开启定时器
    if (self.bannerArray.count > 0) {
        [self startTimer];
    }
}

//背景图片切换（根据滑动方向设置）
- (void)updateBackgroundImagesByDirection:(ESMaskDirection)direction {
    NSInteger topCurrent;
    NSInteger bottomCurrent = self.currentIndex;
    if (direction == ESMaskDirectionRight) {
        topCurrent = self.currentIndex + 1;
    }
    else {
        topCurrent = self.currentIndex - 1;
    }
    if (topCurrent <= 0) {
        topCurrent = self.bannerArray.count - 2;
    } else if (topCurrent >= self.bannerArray.count - 1) {
        topCurrent = 1;
    }
    ESBannerModel *frontModel = self.bannerArray[topCurrent];
    ESBannerModel *backModel = self.bannerArray[bottomCurrent];
    [self.frontImage sd_setImageWithURL:[NSURL URLWithString:frontModel.backImage]];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:backModel.backImage]];
}

//设置PageControl
- (void)updatePageControlCurrentIndicator {
    NSInteger currentPage = [self getCurrentIndex];
    if (currentPage == 0) {
        currentPage = self.bannerArray.count - 2;
    } else if (self.currentIndex == self.bannerArray.count - 1) {
        currentPage = 1;
    }
    currentPage = MAX(currentPage - 1, 0);
    [self.pageControl setCurrentPage:currentPage];
}

//获取当前的页数，偏移量超过一半则取下一页
- (NSInteger)getCurrentIndex {
    if (self.bannerArray.count == 0) {
        return 0;
    } else {
        NSInteger index = (NSInteger)(self.cycleScroll.contentOffset.x / _bannerWidth);
        CGFloat remainder = self.cycleScroll.contentOffset.x - index * _bannerWidth;
        index += remainder >= (_bannerWidth / 2) ? 1 : 0;
        return index;
    }
}

//获取当前页数，偏移量下取整
- (NSInteger)getCurrentIndexFloor {
    if (self.bannerArray.count == 0) {
        return 0;
    } else {
        return self.cycleScroll.contentOffset.x / _bannerWidth;
    }
}

//添加定时器
- (void)startTimer {
    [self timerInvalidate];
    self.timer = [NSTimer timerWithTimeInterval:_timerInterval target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//定时器周期
- (void)timerRun {
    self.currentIndex = [self getCurrentIndex];
    UICollectionViewCell *cell = [self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    [UIView animateWithDuration:_transformInterval animations:^{
        cell.transform = CGAffineTransformMakeScale(_transformScale, _transformScale);
    } completion:^(BOOL finished) {
        NSInteger nextIndex = self.currentIndex < self.bannerArray.count - 1 ? self.currentIndex + 1 : self.currentIndex;
        
        if (nextIndex < [_cycleScroll numberOfItemsInSection:0]) {
            [self.cycleScroll scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }];
}
//移除定时器
- (void)timerInvalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -- scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentIndex = [self getCurrentIndex];
    UICollectionViewCell *cell = [self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    [UIView animateWithDuration:_transformInterval animations:^{
        cell.transform = CGAffineTransformMakeScale(_transformScale, _transformScale);
    }];
    [self timerInvalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        UICollectionViewCell *cell = [self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        if (cell == nil) {
            [self.cycleScroll layoutIfNeeded];
            cell = [self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        }
        [UIView animateWithDuration:_transformInterval animations:^{
            cell.transform = CGAffineTransformMakeScale(_originScale, _originScale);
        }];
        if (self.timer == nil) {
            [self startTimer];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;   //当前偏移量
    CGFloat originOffsetX = self.currentIndex * _bannerWidth;   //当前页数对应的偏移量
    CGFloat subOffsetX = ABS(originOffsetX - offsetX);  //偏移量差的绝对值
    CGFloat scale = subOffsetX / _bannerWidth;  //偏移量差与视图宽度的比例
    NSInteger scrollIndex = [self getCurrentIndexFloor];
    
    CGFloat maskMaxRadio = sqrt(pow(_bannerWidth, 2) + pow(_bannerHeight, 2));
    if (scrollIndex >= self.currentIndex) { //当前页右侧
        [self.leftBackMask setMaskRadius:0 direction:(ESMaskDirectionLeft)];
        [self.rightBackMask setMaskRadius:(maskMaxRadio * scale) direction:(ESMaskDirectionRight)];
        [self updateBackgroundImagesByDirection:(ESMaskDirectionRight)];
    } else {    //当前页左侧
        [self.leftBackMask setMaskRadius:(maskMaxRadio * scale) direction:(ESMaskDirectionLeft)];
        [self.rightBackMask setMaskRadius:0 direction:(ESMaskDirectionRight)];
        [self updateBackgroundImagesByDirection:(ESMaskDirectionLeft)];
    }
    [self updatePageControlCurrentIndicator];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView { //setOffset结束滚动回调
    [self cycleScrollDidEndScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {   //手动滑动结束滚动后回调
    [self cycleScrollDidEndScroll];
}

- (void)cycleScrollDidEndScroll {
    self.currentIndex = [self getCurrentIndex];
    if (self.currentIndex == 0) {
        self.currentIndex = self.bannerArray.count - 2;
        [self.cycleScroll scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    } else if (self.currentIndex == self.bannerArray.count - 1) {
        self.currentIndex = 1;
        [self.cycleScroll scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    }
    UICollectionViewCell *cell = [self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    if (cell == nil) {
        [self.cycleScroll layoutIfNeeded];
        cell = [self.cycleScroll cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    }
    [UIView animateWithDuration:_transformInterval animations:^{
        cell.transform = CGAffineTransformMakeScale(_originScale, _originScale);
    }];
    if (self.timer == nil) {
        [self startTimer];
    }
}

#pragma mark -- collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ESCycleScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ESCycleScrollCellId forIndexPath:indexPath];
    ESBannerModel *model = self.bannerArray[indexPath.row];
    cell.imageUrl = model.bannerImage;
    cell.transform = CGAffineTransformMakeScale(_transformScale, _transformScale);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    if (index == 0) {
        index = self.bannerArray.count - 2;
    } else if (index == self.bannerArray.count - 1) {
        index = 1;
    }
    !self.didClickBannerAtIndex ? : self.didClickBannerAtIndex(index - 1);
}

#pragma mark -- getter
- (ESCycleScroll *)cycleScroll {
    if (nil == _cycleScroll) {
        CGRect frame = self.frame;
        frame.origin.y = self.bannerMarginTop;
        frame.size.height -= self.bannerMarginTop;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = frame.size;
        
        _cycleScroll = [[ESCycleScroll alloc] initWithFrame:frame collectionViewLayout:layout];
        _cycleScroll.backgroundColor = [UIColor clearColor];
        _cycleScroll.delegate = self;
        _cycleScroll.dataSource = self;
        _cycleScroll.showsHorizontalScrollIndicator = NO;
        _cycleScroll.pagingEnabled = YES;
        [_cycleScroll registerClass:[ESCycleScrollCell class] forCellWithReuseIdentifier:ESCycleScrollCellId];
    }
    return _cycleScroll;
}

- (UIPageControl *)pageControl {
    if (nil == _pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(_bannerWidth / 2, _bannerHeight - 20);
        [_pageControl sizeToFit];
    }
    return _pageControl;
}

- (UIImageView *)frontImage {
    if (nil == _frontImage) {
        CGRect frame = self.frame;
//        frame.size.height -= 30;
        _frontImage = [[UIImageView alloc] initWithFrame:frame];
        _frontImage.contentMode = UIViewContentModeScaleAspectFill;
        _frontImage.clipsToBounds = YES;
    }
    return _frontImage;
}

- (UIImageView *)backImage {
    if (nil == _backImage) {
        CGRect frame = self.frame;
//        frame.size.height -= 30;
        _backImage = [[UIImageView alloc] initWithFrame:frame];
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.clipsToBounds = YES;
    }
    return _backImage;
}

- (UIView *)maskView {
    if (nil == _maskView) {
        CGRect frame = self.frame;
//        frame.size.height -= 30;
        _maskView = [[UIView alloc] initWithFrame:frame];
    }
    return _maskView;
}

- (ESBackMask *)leftBackMask {
    if (nil == _leftBackMask) {
        CGRect frame = self.frame;
//        frame.size.height -= 30;
        _leftBackMask = [[ESBackMask alloc] initWithFrame:frame];
    }
    return _leftBackMask;
}

- (ESBackMask *)rightBackMask {
    if (nil == _rightBackMask) {
        CGRect frame = self.frame;
//        frame.size.height -= 30;
        _rightBackMask = [[ESBackMask alloc] initWithFrame:frame];
    }
    return _rightBackMask;
}

@end
