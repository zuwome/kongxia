//
//  ZZOrderArCheckEvidenceDetailPhoneCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderArCheckEvidenceDetailPhoneCell.h"
#import "ZZShowOriginalImageView.h"

/**
 查看证据的图片
 */
@interface ZZCheckEvidenceCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation ZZCheckEvidenceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode =  UIViewContentModeScaleAspectFill;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

@end
@interface ZZOrderArCheckEvidenceDetailPhoneCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) UIImageView *currentImageView;
@property (nonatomic,strong) UILabel *reasonTitleLab;
@property (nonatomic,strong) UIViewController *viewController;
@end
@implementation ZZOrderArCheckEvidenceDetailPhoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.currentImageView];
        [self.contentView addSubview:self.reasonTitleLab];
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self.currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(14.5);
        make.width.equalTo(@16);
    }];
    
    [self.reasonTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentImageView.mas_right).offset(9.5);
        make.centerY.equalTo(self.currentImageView.mas_centerY);
        make.right.offset(-14.5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.equalTo(self.reasonTitleLab.mas_bottom);
    }];
    
}
- (void)setShowTitle:(NSString *)title detailTitle:(NSString *)detailTitle dataArray:(NSArray*)array viewController:(UIViewController *)viewController {
    [super setShowTitle:title detailTitle:detailTitle dataArray:array viewController:viewController];
     self.dataArray = array;
    self.viewController = viewController;
    CGFloat height = (SCREEN_WIDTH - 60)/3*(ceil(array.count/3.0f))+40;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [self.collectionView reloadData];
    
}




- (UIImageView *)currentImageView {
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc]init];
        _currentImageView.image = [UIImage imageNamed:@"icPicEvidence"];
        _currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _currentImageView;
}
- (UILabel *)reasonTitleLab {
    if (!_reasonTitleLab) {
        _reasonTitleLab = [[UILabel alloc]init];
        _reasonTitleLab.textColor = kBlackColor;
        _reasonTitleLab.textAlignment = NSTextAlignmentLeft;
        _reasonTitleLab.font = CustomFont(15);
        _reasonTitleLab.numberOfLines = 0;
        _reasonTitleLab.text = @"图片证据";
    }
    return _reasonTitleLab;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
        CGFloat width = (SCREEN_WIDTH - 60)/3;
        flowLayout.itemSize = CGSizeMake(width, width);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[ZZCheckEvidenceCell class] forCellWithReuseIdentifier:@"ZZCheckEvidenceCellID"];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }

    return _collectionView;
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZCheckEvidenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZCheckEvidenceCellID" forIndexPath:indexPath];
    NSString *urlStr = self.dataArray[indexPath.row];
    NSString *urlString ;
    if (!isNullString(urlStr)) {
        if ([urlStr containsString:@"http"]) {
            urlString = urlStr;
        } else {
            urlString =[NSString stringWithFormat:@"%@%@",kQNPrefix_url,urlStr];
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZShowOriginalImageView *imageView = [[ZZShowOriginalImageView alloc]init];
    NSString *urlStr = self.dataArray[indexPath.row];
    NSString *urlString ;
    if (!isNullString(urlStr)) {
        if ([urlStr containsString:@"http"]) {//安卓上传字段直接是完整的导致这边显示出问题  ,iOS 为什么没有完整的  因为七牛返回的没有  安卓会在上传完图片都请求拼接的  导致  性能不高
            urlString = urlStr;
        }else{
            urlString =[NSString stringWithFormat:@"%@%@",kQNPrefix_url,urlStr];
        }
        [imageView ShowOriginalImageViewWithImageUrl:[NSURL URLWithString:urlString] viewController:self.viewController];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
