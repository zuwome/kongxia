//
//  ZZApplyUploadView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZApplyUploadView.h"

@interface ZZApplyUploadViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZApplyUploadViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imgView];
        _imgView.contentMode =  UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

@end

@implementation ZZApplyUploadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count+1>_selectMaxNumber?_selectMaxNumber:self.dataArray.count+1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZApplyUploadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZApplyUploadViewCellID" forIndexPath:indexPath];
    if ((indexPath.item<=self.dataArray.count-1)&&self.dataArray.count>0) {
        cell.imgView.image = self.dataArray[indexPath.row];
    }else{
        cell.imgView.image = [UIImage imageNamed:@"applyRefundUploadView"];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex) {
        _selectIndex(indexPath.item);
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - Lazyload

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
        CGFloat width = (SCREEN_WIDTH - 60)/3;
        layout.itemSize = CGSizeMake(width, width);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) collectionViewLayout:layout];
        [_collectionView registerClass:[ZZApplyUploadViewCell class] forCellWithReuseIdentifier:@"ZZApplyUploadViewCellID"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

@end
