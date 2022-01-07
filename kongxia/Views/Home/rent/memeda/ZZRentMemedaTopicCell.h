//
//  ZZRentMemedaTopicCell.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZMemedaTopicModel;
/**
 *  他人页么么答标签选择cell
 */
@interface ZZRentMemedaTopicCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setData:(ZZMemedaTopicModel *)model;

@end
