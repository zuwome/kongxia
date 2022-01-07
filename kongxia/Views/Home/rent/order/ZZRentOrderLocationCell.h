//
//  ZZRentOrderLocationCell.h
//  zuwome
//
//  Created by angBiu on 16/6/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZOrder;
@class ZZTaskModel;
@class ZZRentOrderLocationCell;
/**
 *  预约地点cell
 */

@protocol ZZRentOrderLocationCellDelegate <NSObject>

- (void)cellShowRecommendLocation:(ZZRentOrderLocationCell *)cell;

- (void)cellShowMap:(ZZRentOrderLocationCell *)cell;

@end

@interface ZZRentOrderLocationCell : UITableViewCell

@property (nonatomic, weak) id<ZZRentOrderLocationCellDelegate> delegate;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) ZZTaskModel *task;

@end
