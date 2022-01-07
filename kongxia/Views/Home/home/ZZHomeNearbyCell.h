//
//  ZZHomeNearbyCell.h
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeStatusView.h"
@class ZZHomeNearbyCell;
@class ZZHomeNearbyModel;
@protocol ZZHomeNearbyCellDelegate <NSObject>

- (void)cellTapped:(ZZHomeNearbyCell *)cell model:(ZZHomeNearbyModel *)model;

@end
/**
 *  首页附近cell
 */
@interface ZZHomeNearbyCell : UITableViewCell

@property (nonatomic, weak) id<ZZHomeNearbyCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *wxBgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) ZZHomeStatusView *statusView;
@property (nonatomic, weak) ZZHomeNearbyModel *model;

@end
