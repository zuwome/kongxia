//
//  ZZHomeNewRecommendCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/7/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeStatusView.h"
#import "ZZHomeFirstWxGuide.h"
#import "ZZHomeModel.h"

@class ZZHomeNewRecommendCell;
@protocol ZZHomeNewRecommendCellDelegate <NSObject>

- (void)cellTapped:(ZZHomeNewRecommendCell *)cell model:(ZZHomeRecommendDetailModel *)model;

@end

@interface ZZHomeNewRecommendCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZHomeNewRecommendCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *imgView; //用户头像
@property (nonatomic, strong) ZZHomeFirstWxGuide *firstWxGuideView;
@property (nonatomic, strong) UIImageView *wxBgView;    //有微信图标
@property (nonatomic, strong) UILabel *nameLabel;   //用户昵称
@property (nonatomic, strong) UIImageView *sexImgView;  //性别图标
@property (nonatomic, strong) UILabel *skillLabel;  //技能标签
@property (nonatomic, strong) UILabel *moneyLabel;  //金额标签
@property (nonatomic, strong) UIImageView *vImgView;    //v图标
@property (nonatomic, strong) UILabel *vLabel;  //v标签
@property (nonatomic, strong) UILabel *skillIntroduce;  //技能介绍
@property (nonatomic, strong) ZZLevelImgView *levelImgView; //等级图标
@property (nonatomic, strong) ZZHomeStatusView *statusView; //新人图片
@property (nonatomic, weak) ZZHomeRecommendDetailModel *model;

- (void)setupWithIndePath:(NSIndexPath *)indexPath;


@end

