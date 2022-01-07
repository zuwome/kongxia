//
//  PYCycleScrollView.m
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "PYCycleScrollView.h"
#import "PYImageCollectionViewCell.h"
#import "PYImageAndTitileCell.h"
#import <SDWebImageManager.h>

static NSString *imageId = @"ImageID";
static NSString *imageAndTitleId = @"ImageAndTitleID";
@interface PYCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) NSTimer *timer;

/**当前滚动的位置*/
@property (nonatomic, assign)  NSInteger currentIndex;

/**上次滚动的位置*/
@property (nonatomic, assign)  NSInteger lastIndex;

@end

@implementation PYCycleScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupMainView];
        self.backgroundColor = HEXCOLOR(0xf5f5f5);
    }
    return self;
}


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
{
    PYCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    return cycleScrollView;
}


// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    _flowLayout = flowLayout;
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5,SCREEN_WIDTH , 64) collectionViewLayout:flowLayout];
    _mainView = mainView;
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.scrollEnabled  = NO;
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.scrollsToTop = NO;
    _mainView.contentSize = _mainView.bounds.size;
    _mainView.contentInset = UIEdgeInsetsZero;
    _mainView.scrollIndicatorInsets = UIEdgeInsetsZero;
    _mainView.pagingEnabled = NO;
    [self addSubview:mainView];
    [_mainView registerClass:[PYImageCollectionViewCell class] forCellWithReuseIdentifier:imageId];
    [_mainView registerClass:[PYImageAndTitileCell class] forCellWithReuseIdentifier:imageAndTitleId];

}

- ( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
}
#pragma mark 自动滚动时间设置

- (void)setAutomaticallyScrollDuration:(NSTimeInterval)automaticallyScrollDuration
{
    _automaticallyScrollDuration = automaticallyScrollDuration;
    if (_automaticallyScrollDuration > 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.automaticallyScrollDuration target:self selector:@selector(startScrollAutomtically) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    }
    else
    {
        [self.timer invalidate];
    }
}
#pragma mark 构造新的图片数组

- (NSMutableArray *)roastingArray
{

    _roastingArray = [NSMutableArray arrayWithArray:self.modelArray];
    if (self.loop && self.modelArray.count > 0)
    {
        [_roastingArray insertObject:[self.modelArray lastObject] atIndex:0];
        [_roastingArray addObject:self.modelArray[0]];
    }
 
    return _roastingArray;
}
#pragma mark 自动滚动
- (void)startScrollAutomtically
{
    NSInteger currentIndex = self.currentIndex + 1;
    currentIndex = (currentIndex == self.roastingArray.count) ? 1 : currentIndex;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    
    BOOL isNeedAnim = self.automaticallyScrollDuration <= 0.3 ? NO : YES;
    [self scrollToIndexPath:indexPath animated:isNeedAnim];
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if (self.roastingArray.count > indexPath.row)
    {
        [self.mainView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //默认滚动到第一张图片
    if (self.loop && self.mainView.contentOffset.y == 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToIndexPath:indexPath animated:NO];
        self.currentIndex = 1;
    }
}

#pragma mark 代理方法

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>self.roastingArray.count) {
        return [[UICollectionViewCell alloc] init];
    }
    PYCycleItemModel *model = self.roastingArray[indexPath.row];
    if (model.modelStyle == PYCycleItemModel_title) {
        PYImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageId forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }else {
        PYImageAndTitileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageAndTitleId forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roastingArray.count;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = self.frame.size.height;
    NSInteger index = (scrollView.contentOffset.y + height * 0.5) / height;
    if (self.loop)
    {
        //当滚动到最后一张图片时，继续滚向后动跳到第一张
        if (index == self.modelArray.count + 1)
        {
            self.currentIndex = 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
            [self scrollToIndexPath:indexPath animated:NO];
            return;
        }
        
        //当滚动到第一张图片时，继续向前滚动跳到最后一张
        if (scrollView.contentOffset.y < height * 0.5)
        {
            self.currentIndex = self.modelArray.count;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
            [self scrollToIndexPath:indexPath animated:NO];
            return;
        }
    }
    
    //避免多次调用currentIndex的setter方法
    if (self.currentIndex != self.lastIndex)
    {
        self.currentIndex = index;
    }
    self.lastIndex = index;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemModel:)])
    {
        PYCycleItemModel *model = self.roastingArray[indexPath.row];
        [self.delegate cycleScrollView:self didSelectItemModel:model];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //关闭自动滚动
    [self.timer invalidate];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.automaticallyScrollDuration > 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.automaticallyScrollDuration target:self selector:@selector(startScrollAutomtically) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    [self.mainView reloadData];

}
#pragma mark - 清理图片
+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
}
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}
- (void)adjustWhenControllerViewWillAppera
{
    long targetIndex = [self currentIndex];
    if (targetIndex < self.roastingArray.count) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

@end
