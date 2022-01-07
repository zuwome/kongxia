//
//  ZZUserCenterBaseCell.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBadgeView.h"
/**
 *  我的页面 图文cell
 */
@class ZZUserCenterBaseCell;

@interface ZZUserCenterBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *readPointView;
@property (nonatomic, strong) ZZBadgeView *badgeView;
@property (nonatomic, strong) UIImageView *infoImgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *orderInfoLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView *editImgView;
@property (nonatomic, strong) UIImageView *rentInfoImgView;
@property (nonatomic,strong) UIView *redIntegralView;//第一次进入的时候显示积分的提醒小红点
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UIView *redView;
- (void)setData:(ZZUser *)user indexPath:(NSIndexPath *)indexPath hideRedPoint:(BOOL)hide;

- (void)setRedDot:(NSInteger)number;

@end
