//
//  ZZFindHotTopicView.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZFindHotTopicView.h"

@interface ZZFindHotTopicCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZFindHotTopicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.layer.cornerRadius = 3;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = kBlackTextColor;
        coverView.layer.cornerRadius = 3;
        coverView.alpha = 0.5;
        [_imgView addSubview:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imgView);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"秀秀好身材好身材";
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}

@end

@interface ZZFindHotTopicView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat rightOriginWidth;
@property (nonatomic, assign) CGFloat rightMaxWidth;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *rightInfoLabel;

@end

@implementation ZZFindHotTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel.text = @"热门话题";
        
        _rightOriginWidth = 25;
        _rightMaxWidth = 50;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.rightView];
    }
    
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZFindHotTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    
    ZZTopicModel *model = self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.group.cover_url]];
    cell.titleLabel.text = model.group.content;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTopicModel *model = self.dataArray[indexPath.row];
    if (_selectItem) {
        _selectItem(model);
    }
}

- (void)moreBtnClick
{
    if (_touchMore) {
        _touchMore();
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_didStartScroll) {
        _didStartScroll();
    }
    CGFloat contentWidth = self.collectionView.contentSize.width;
    CGFloat offset = scrollView.contentOffset.x - (contentWidth - SCREEN_WIDTH);
    if (offset>0) {
        _rightView.frame = CGRectMake(SCREEN_WIDTH - offset, 50, MAX(_rightOriginWidth, offset), _rightView.height);
        [self updateShapeLayerPath];
    } else {
        _rightView.frame = CGRectMake(SCREEN_WIDTH, 50, _rightOriginWidth, _rightView.height);
    }
    if (offset>=_rightMaxWidth) {
        _rightInfoLabel.text = @"释\n放\n查\n看";
    } else {
        _rightInfoLabel.text = @"查\n看\n更\n多";
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_didEndScroll) {
        _didEndScroll();
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat contentWidth = self.collectionView.contentSize.width;
    CGFloat offset = scrollView.contentOffset.x - (contentWidth - SCREEN_WIDTH);
    if (offset>=_rightMaxWidth) {
        if (_touchMore) {
            _touchMore();
        }
    }
    if (decelerate) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)updateShapeLayerPath
{
    // 更新_shapeLayer形状
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointMake(_rightView.width, 0)];//右上
    [tPath addLineToPoint:CGPointMake(_rightView.width, _rightView.height)];//右下
    [tPath addLineToPoint:CGPointMake(_rightView.width - _rightOriginWidth,  _rightView.height)];//左下
    [tPath addQuadCurveToPoint:CGPointMake(_rightView.width - _rightOriginWidth, 0)//左上
                  controlPoint:CGPointMake(0, _rightView.height/2)];//左中心
    [tPath closePath];
    _shapeLayer.path = tPath.CGPath;
}

#pragma mark - lazyload

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(8);
            make.top.mas_equalTo(self.mas_top);
            make.height.mas_equalTo(@50);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-13);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 12));
        }];
        
        UILabel *moreLabel = [[UILabel alloc] init];
        moreLabel.textColor = kGrayContentColor;
        moreLabel.font = [UIFont systemFontOfSize:14];
        moreLabel.text = @"全部";
        [self addSubview:moreLabel];
        
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(arrowImgView.mas_centerY);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self);
            make.bottom.mas_equalTo(_titleLabel.mas_bottom);
        }];
        
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.itemSize = CGSizeMake(70*2, 70);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 70) collectionViewLayout:layout];
        [_collectionView registerClass:[ZZFindHotTopicCell class] forCellWithReuseIdentifier:@"mycell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 50, _rightOriginWidth, 70)];
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = HEXCOLOR(0xf5f5f5).CGColor;
        [_rightView.layer addSublayer:_shapeLayer];
        
        [self updateShapeLayerPath];
        
        _rightInfoLabel = [[UILabel alloc] init];
        _rightInfoLabel.textAlignment = NSTextAlignmentCenter;
        _rightInfoLabel.textColor = kGrayContentColor;
        _rightInfoLabel.font = [UIFont systemFontOfSize:13];
        _rightInfoLabel.text = @"查\n看\n更\n多";
        _rightInfoLabel.numberOfLines = 0;
        [_rightView addSubview:_rightInfoLabel];
        
        [_rightInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(_rightView);
            make.width.mas_equalTo(_rightOriginWidth);
        }];
    }
    return _rightView;
}

@end
