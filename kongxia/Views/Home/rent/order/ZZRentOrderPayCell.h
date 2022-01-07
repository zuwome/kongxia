//
//  ZZRentOrderPayCell.h
//  zuwome
//
//  Created by angBiu on 16/6/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZOrder;
/**
 *  预约支付 cell
 */
@interface ZZRentOrderPayCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImgView;

@property (nonatomic, strong) UIView *line;

- (void)setIndexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)index;

@end
