//
//  ZZRecordStickerChooseView.m
//  zuwome
//
//  Created by angBiu on 2016/12/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordChooseView.h"
#import "ZZRecordChooseTopView.h"

#import "ZZDownloadHelper.h"
#import "SSZipArchive.h"
#import "ZZLiveStreamHelper.h"

#define kStickerCellWidth  44

@interface ZZRecordStickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *cancelImgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *downImgView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation ZZRecordStickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.layer.borderColor = kYellowColor.CGColor;
        
        self.cancelImgView.image = [UIImage imageNamed:@"icon_record_config_0_n"];
        self.imgView.hidden = NO;
        self.downImgView.hidden = YES;
        self.loadingView.hidden = NO;
    }
    
    return self;
}

#pragma mark - lazyload

- (UIImageView *)cancelImgView
{
    if (!_cancelImgView) {
        _cancelImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_cancelImgView];
        
        [_cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _cancelImgView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kStickerCellWidth, kStickerCellWidth));
        }];
    }
    return _imgView;
}

- (UIImageView *)downImgView
{
    if (!_downImgView) {
        _downImgView = [[UIImageView alloc] init];
        _downImgView.image = [UIImage imageNamed:@"icon_record_down"];
        [self.contentView addSubview:_downImgView];
        
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(_imgView);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }
    return _downImgView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.color = HEXACOLOR(0xffffff, 0.8);
        [self.contentView addSubview:_loadingView];
        
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _loadingView;
}

@end

@interface ZZRecordChooseView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SSZipArchiveDelegate>

@property (nonatomic, strong) ZZRecordChooseTopView *topView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *stickerBtn;
@property (nonatomic, assign) NSInteger stickerIndex;
@property (nonatomic, assign) NSInteger filterIndex;
@property (nonatomic, strong) ZZRecordStickerCell *currentCell;
@property (nonatomic, strong) NSMutableArray *downloadArray;

@end

@implementation ZZRecordChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self addSubview:self.topView];
        [self addSubview:self.collectionView];
//        [self addSubview:self.bottomView];
//        self.top = SCREEN_HEIGHT + self.topView.height;
//        self.top = SCREEN_HEIGHT - self.height;
    }
    
    return self;
}

- (BOOL)checkFileIsExist:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *savePath = [[ZZFileHelper createPathWithChildPath:stickers_savepath] stringByAppendingPathComponent:name];
    if ([fileManager fileExistsAtPath:savePath]) {
        return YES;
    }
    return NO;
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.stickerDataArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZRecordStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.loadingView.hidden = YES;
        cell.imgView.hidden = YES;
        cell.downImgView.hidden = YES;
        cell.cancelImgView.hidden = NO;
    } else {
        cell.loadingView.hidden = NO;
        cell.imgView.hidden = NO;
        cell.cancelImgView.hidden = YES;
        [cell.loadingView startAnimating];
        ZZRecordStickerModel *model = self.stickerDataArray[indexPath.row - 1];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.loadingView stopAnimating];
            cell.loadingView.hidden = YES;
        }];
        if ([self checkFileIsExist:model.name]) {
            cell.downImgView.hidden = YES;
        } else {
            cell.downImgView.hidden = NO;
        }
    }
    if (indexPath.row == _stickerIndex) {
        cell.contentView.layer.borderWidth = 1;
    } else {
        cell.contentView.layer.borderWidth = 0;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _stickerIndex = indexPath.row;
    if (indexPath.row == 0) {
        [self.collectionView reloadData];
    } else {
        ZZRecordStickerModel *model = self.stickerDataArray[indexPath.row - 1];
        if ([self checkFileIsExist:model.name]) {
            [self.collectionView reloadData];
        } else {
            ZZRecordStickerCell *cell = (ZZRecordStickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (![self.downloadArray containsObject:cell]) {
                [self.downloadArray addObject:cell];
                _currentCell = cell;
            } else {
                _currentCell.contentView.layer.borderWidth = 0;
                cell.contentView.layer.borderWidth = 1;
            }
        }
        [self saveRecordStickerModel:model];//缓存选中的贴纸
    }
}

-(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor
{
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - UIButtonMethod

- (void)viewUp
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = SCREEN_HEIGHT - self.height ;
    } completion:^(BOOL finished) {
        _isViewUp = YES;
    }];
}

- (void)viewDown
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = SCREEN_HEIGHT + self.topView.height;
    } completion:^(BOOL finished) {
        _isViewUp = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(chooseView:isViewUp:)]) {
            [_delegate chooseView:self isViewUp:NO];
        }
    }];
}

#pragma mark - lazyload

- (UIView *)topView
{
    if (!_topView) {
//        _topView = [[ZZRecordChooseTopView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 60)];
        _topView = [[ZZRecordChooseTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _topView.backgroundColor = HEXACOLOR(0x000000, 0.4);
        _topView.hidden = YES;
        _topView.touchIndex = ^(NSInteger index){
        };
    }
    return _topView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kStickerCellWidth, kStickerCellWidth);
        layout.sectionInset = UIEdgeInsetsMake(30, 20, 30, 20);
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 20;
        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 193) collectionViewLayout:layout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 206) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXACOLOR(0x000000, 0.4);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZZRecordStickerCell class] forCellWithReuseIdentifier:@"mycell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.height, SCREEN_WIDTH, 42+SafeAreaBottomHeight)];
        _bottomView.backgroundColor = HEXACOLOR(0x1F1F1F, 0.89);
        
        [_bottomView addSubview:self.stickerBtn];
    }
    return _bottomView;
}

- (UIButton *)stickerBtn
{
    if (!_stickerBtn) {
        _stickerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bottomView.height-SafeAreaBottomHeight)];
        [_stickerBtn setImage:[UIImage imageNamed:@"icon_record_sticker"] forState:UIControlStateNormal];
    }
    return _stickerBtn;
}

- (NSMutableArray *)downloadArray
{
    if (!_downloadArray) {
        _downloadArray = [NSMutableArray array];
    }
    return _downloadArray;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint touchPoint = [_topView convertPoint:point fromView:self];
        if (CGRectContainsPoint(_topView.bounds, touchPoint) && !_topView.hidden) {
            view = _topView;
        }
    }
    
    return view;
}

- (void)dealloc
{

}

@end
