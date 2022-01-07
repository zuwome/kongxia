//
//  ZZHomeRecommendCell.h
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeStatusView.h"
@class ZZHomeNearbyModel;
@class ZZHomeRefreshCell;
@protocol ZZHomeRefreshCellDelegate <NSObject>

- (void)cellTapped:(ZZHomeRefreshCell *)cell model:(ZZHomeNearbyModel *)model;

@end
/**
 *  首页新鲜cell
 */
@interface ZZHomeRefreshCell : UITableViewCell
@property (nonatomic, weak) id<ZZHomeRefreshCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *wxBgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, strong) UILabel *vLabel;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) ZZHomeStatusView *statusView;
@property (nonatomic, weak) ZZHomeNearbyModel *model;

@property (nonatomic, copy) dispatch_block_t touchCancel;

@end
