//
//  ZZRentVCell.h
//  zuwome
//
//  Created by angBiu on 16/6/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  V认证cell
 */
@interface ZZRentVCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;

- (void)setData:(ZZUser *)user;

@end
