//
//  ZZRentOrderTimeCell.h
//  zuwome
//
//  Created by angBiu on 16/6/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTasks.h"
@class ZZOrder;
/**
 *  预约  时间cell
 */
@interface ZZRentOrderTimeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *line;

- (void)setOrder:(ZZOrder *)order indexPath:(NSIndexPath *)indexPath;

- (void)setTask:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath;

@end
