//
//  ZZMemedaAskCell.h
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZMemedaModel;
/**
 *  我的么么答  ---- 我问cell
 */
@interface ZZMemedaAskCell : UICollectionViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, copy) dispatch_block_t touchHead;

- (void)setData:(ZZMemedaModel *)model;

@end
