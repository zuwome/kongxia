//
//  ZZRentPageHeadView.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
#import "ZZAttentView.h"
#import "AdView.h"
/**
 *  他人页头部图片视图
 */
@interface ZZRentPageHeadView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZZRentCollectionView *collectionView;
//@property (nonatomic, strong) AdView *adView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImage *shareImg;//第一张图片（分享）
@property (nonatomic, strong) ZZAttentView *attentView;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, copy) dispatch_block_t touchEdit;
@property (nonatomic, copy) dispatch_block_t touchAttentCount;
@property (nonatomic, copy) dispatch_block_t touchFansCount;
@property (nonatomic, copy) void (^playVideo)(void);//播放达人视频

- (void)setData:(ZZUser *)user;

@end
