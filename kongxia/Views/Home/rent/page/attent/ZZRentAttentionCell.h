//
//  ZZRentAttentionCell.h
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUserFollowModel;
#import "ZZAttentView.h"

@interface ZZRentAttentionCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) ZZAttentView *attentView;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UIView *lineView;

- (void)setData:(ZZUserFollowModel *)model;

@end
