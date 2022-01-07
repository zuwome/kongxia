//
//  ZZRentLabelCell.h
//  zuwome
//
//  Created by angBiu on 16/6/20.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSInteger, LabelType) {
    LabelTypeInterest = 0,          // 兴趣爱好
    LabelTypePersonalLabel,         // 个人标签
    LabelTypeLocation,              // 出没商圈
};

#import <UIKit/UIKit.h>
#import "ZZRedPointView.h"
@class SKTagView;
@class ZZRedPointView;
@class ZZRentLabelCell;
@class ZZMyLocationModel;
/**
 *  他人页 带有标签的cell
 */


@protocol ZZRentLabelCellDelegate <NSObject>

- (void)cell:(ZZRentLabelCell *)cell showLocation:(ZZMyLocationModel *)model;

@end

@interface ZZRentLabelCell : UITableViewCell

@property (nonatomic, weak) id<ZZRentLabelCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) SKTagView *tagView;
@property (nonatomic, strong) ZZRedPointView *redPointView;

- (void)setUser:(ZZUser *)user labelType:(LabelType)tye;

@end
