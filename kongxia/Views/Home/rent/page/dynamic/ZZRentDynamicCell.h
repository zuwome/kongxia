//
//  ZZRentDynamicCell.h
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZRentDynamicContributionView.h"
#import "ZZFindVideoTimeView.h"
#import "ZZUserVideoListModel.h"

/**
 *  他人页动态cell
 */
@interface ZZRentDynamicCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *videoImgView;//预览图
@property (nonatomic, strong) ZZFindVideoTimeView *timeView;
@property (nonatomic, strong) UILabel *readCountLabel;//阅读
@property (nonatomic, strong) UILabel *commentCountLabel;//评论
@property (nonatomic, strong) UILabel *zanCountLabel;//点赞
@property (nonatomic, strong) UIImageView *zanImgView;
@property (nonatomic, strong) ZZRentDynamicContributionView *contributionView;

- (void)setData:(ZZUserVideoListModel *)model;
- (void)setMMDData:(ZZMemedaModel *)model;

@end
