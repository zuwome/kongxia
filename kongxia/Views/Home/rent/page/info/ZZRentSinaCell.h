//
//  ZZRentSinaCell.h
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页新浪cell
 */
@interface ZZRentSinaCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sinaImgView;
@property (nonatomic, strong) UIView *lineView;

- (void)setData:(ZZUser *)user;

@end
