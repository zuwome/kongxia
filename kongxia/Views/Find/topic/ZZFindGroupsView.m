//
//  ZZFindGroupsView.m
//  zuwome
//
//  Created by YuTianLong on 2018/2/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFindGroupsView.h"
#import "ZZFindGroupModel.h"
#import "ZZFindGroupsCell.h"

@interface ZZFindGroupsView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ZZFindGroupModel *> *models;
@property (nonatomic, strong) ZZFindGroupModel *currentSelectGropus;
@property (nonatomic, assign) NSInteger currentRow;//当前选中 row, 用于选中 UI 样式
@end

@implementation ZZFindGroupsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZFindGroupsView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZFindGroupsView);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

commonInitImplementationSafe(ZZFindGroupsView) {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    
    [self asyncFetchGroups];
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZZFindGroupsCell class] forCellWithReuseIdentifier:[ZZFindGroupsCell reuseIdentifier]];
       
    }
    return _collectionView;
}

#pragma mark - Private methods

- (void)asyncFetchGroups {
    WEAK_SELF();
    
    [ZZRequest method:@"GET" path:@"/video/main_groups" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            weakSelf.currentSelectGropus = nil;
            BLOCK_SAFE_CALLS(weakSelf.fetchGroupsFailBlock, error,weakSelf.models);
        } else {
            NSMutableArray<ZZFindGroupModel *> *array = [ZZFindGroupModel arrayOfModelsFromDictionaries:data error:nil];
            if (array.count>0) {
                weakSelf.models = array;
                weakSelf.currentSelectGropus = weakSelf.models[0];//默认选中第一个
                weakSelf.currentRow = 0;
                [weakSelf.collectionView reloadData];
                weakSelf.userInteractionEnabled = NO;
                BLOCK_SAFE_CALLS(weakSelf.fetchGroupsSuccessBlock, weakSelf.currentSelectGropus);
            }
        }
    }];
}


#pragma mark - Public methods

- (void)againReloadGropusIfNeeded {
    if (self.models == nil || self.models.count == 0) {
        [self asyncFetchGroups];
    }
}

- (void)updateUIWithIndexPath:(NSIndexPath *)indexPath {
    
    self.currentSelectGropus = self.models[indexPath.row];
    self.currentRow = indexPath.row;
    [self.collectionView reloadData];
}

- (void)selectClickWithIndexPath:(NSIndexPath *)indexPath {
    BLOCK_SAFE_CALLS(self.didSelectGroupsBlock, self.currentSelectGropus);
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZFindGroupsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZZFindGroupsCell reuseIdentifier] forIndexPath:indexPath];
    [cell setupWithModel:self.models[indexPath.row]];
    cell.isSelectGruops = self.currentRow == indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(getTextWidth([UIFont systemFontOfSize:14], self.models[indexPath.row].content, 20).width + 35, 40);
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.userInteractionEnabled = NO;
    [self updateUIWithIndexPath:indexPath];
    [self selectClickWithIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BLOCK_SAFE_CALLS(self.didStartScroll);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    BLOCK_SAFE_CALLS(self.didEndScroll);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end
