//
//  ZZIntegralNoviceRollingView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZIntegralNoviceRollingView;
@protocol ZZIntegralNoviceRollingViewDelegate <NSObject>


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
/**
 无限滚动的view
 */
@interface ZZIntegralNoviceRollingView : UIView
/**是否无限循环轮播*/
@property (nonatomic, assign)  BOOL loop;
@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
/**
 服务器返回model的数组
 */
@property (nonatomic, strong) NSArray *modelArray;
/**轮播的数组*/
@property (nonatomic, strong) NSMutableArray *roastingArray;
/**自动轮播时间间隔，默认为0，0表示不开启自动轮播*/
@property (nonatomic, assign)  NSTimeInterval automaticallyScrollDuration;
- (instancetype)initWithFrame:(CGRect)frame cellArray:(NSArray *)cellArray ;
@property (weak, nonatomic) id<ZZIntegralNoviceRollingViewDelegate> delegate;
- (void)adjustWhenControllerViewWillAppera;
@end
