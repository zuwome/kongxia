//
//  ZZRecommendVideoCell.h
//  zuwome
//
//  Created by angBiu on 2017/3/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoModel.h"

/*
 *  附近视频cell
 */

@interface ZZRecommendVideoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
//@property (nonatomic, strong) UIImageView *zanImgView;
@property (nonatomic, strong) UIButton *zanButton;
@property (nonatomic, strong) UIButton *commentButton;
//@property (nonatomic, strong) UILabel *zanCountLabel;
//@property (nonatomic, strong) UIImageView *locationImgView;
//@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *boomBgImgView;

- (void)setData:(ZZFindVideoModel *)model;

@property (nonatomic, copy) void (^zanBlock)(void);
@property (nonatomic, copy) void (^commentBlock)(void);

@end
