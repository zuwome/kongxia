//
//  ZZAddLabelCell.h
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUserLabel.h"
/**
 *  添加标签 ----- cell
 */
@interface ZZAddLabelCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setData:(ZZUserLabel *)model selected:(BOOL)selected;

@end
