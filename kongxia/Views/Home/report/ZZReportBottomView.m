//
//  ZZReportBottomView.m
//  zuwome
//
//  Created by angBiu on 2016/12/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZReportBottomView.h"

@interface ZZReportImageChooseCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZReportImageChooseCell

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

@implementation ZZReportBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.lineView];
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
    return _selectMaxNumber>0?_selectMaxNumber:3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZReportImageChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            if (self.dataArray.count) {
                cell.imgView.image = self.dataArray[0];
            } else {
                cell.imgView.image = [UIImage imageNamed:@"btn_report_addimg"];
            }
        }
            break;
        case 1:
        {
            if (self.dataArray.count>1) {
                cell.imgView.image = self.dataArray[1];
            } else if (self.dataArray.count > 0) {
                cell.imgView.image = [UIImage imageNamed:@"btn_report_addimg"];
            } else {
                cell.imgView.image = nil;
            }
        }
            break;
        case 2:
        {
            if (self.dataArray.count>2) {
                cell.imgView.image = self.dataArray[2];
            } else if (self.dataArray.count > 1) {
                cell.imgView.image = [UIImage imageNamed:@"btn_report_addimg"];
            } else {
                cell.imgView.image = nil;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex) {
        _selectIndex(indexPath.row);
    }
}

#pragma mark - Lazyload

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        CGFloat width = (SCREEN_WIDTH - 60)/3;
        layout.itemSize = CGSizeMake(width, width);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZZReportImageChooseCell class] forCellWithReuseIdentifier:@"mycell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 0.5)];
        _lineView.backgroundColor = kLineViewColor;
    }
    return _lineView;
}

@end
