//
//  ZZPayTypeCell.h
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  支付方式cell
 */
@interface ZZPayTypeCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImgView;

- (void)setDataIndexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)index;

@end
