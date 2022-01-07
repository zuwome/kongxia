//
//  ZZFindNewCell.h
//  zuwome
//
//  Created by angBiu on 16/8/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoModel.h"
@class ZZCornerRadiuImageView;
/**
 *  发现 --- 最新 cell
 */
@interface ZZFindNewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
//@property (nonatomic, strong) UIImageView *zanImgView;
@property (nonatomic, strong) UIButton *zanButton;
//@property (nonatomic, strong) UILabel *zanCountLabel;
@property (nonatomic, strong) ZZCornerRadiuImageView *headImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *commentButton;
//@property (nonatomic, strong) UIImageView *boomBgImgView;

@property (nonatomic, strong) ZZFindVideoModel *model;

- (void)setMMDData:(ZZFindVideoModel *)model;
- (void)setSkData:(ZZFindVideoModel *)videModel;

@property (nonatomic, copy) void (^zanBlock)(void);
@property (nonatomic, copy) void (^commentBlock)(void);

@end
