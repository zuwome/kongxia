//
//  ZZUserVideoFailureCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 我的视频 作品 --- 发布失败的视频
 */
@interface ZZUserVideoFailureCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *retryImgView;
@property (nonatomic, strong) UIImageView *deleteImgView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) dispatch_block_t touchRetry;
@property (nonatomic, copy) dispatch_block_t touchDelete;

- (void)hideViews;
- (void)showViews;

@end
