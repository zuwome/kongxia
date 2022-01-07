//
//  ZZUserVideoSuccessCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZUserVideoListModel.h"

/**
 我的视频 作品 --- 发布成功的视频
 */
@interface ZZUserVideoSuccessCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *boomBgImgView;
@property (nonatomic, strong) UIButton *zanButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, copy) void (^zanBlock)(void);
@property (nonatomic, copy) void (^commentBlock)(void);

- (void)setData:(ZZUserVideoListModel *)model;

@end
