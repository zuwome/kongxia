//
//  ZZAttentionCell.h
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUserFollowModel;
#import "ZZAttentView.h"
/**
 *  我的关注cell
 */
@interface ZZAttentionCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) ZZAttentView *attentView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *distanceImgView;
@property (nonatomic, strong) UIView *lineView;

- (void)setData:(ZZUserFollowModel *)model;

@end
