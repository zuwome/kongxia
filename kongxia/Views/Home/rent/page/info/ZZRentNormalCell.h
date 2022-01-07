//
//  ZZRentNormalCell.h
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页 资料 共用的cell
 */
@interface ZZRentNormalCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) void(^longPress)(UIView *targetView);

- (void)setUser:(ZZUser *)user indexPath:(NSIndexPath *)indexPath;

@end
