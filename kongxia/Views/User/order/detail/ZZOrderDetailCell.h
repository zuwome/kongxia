//
//  ZZOrderDetailCell.h
//  zuwome
//
//  Created by wlsy on 16/1/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZOrderDetailCell : UICollectionViewCell

@property (nonatomic, copy) dispatch_block_t touchBlock;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end
