//
//  ZZUserBlackCell.h
//  zuwome
//
//  Created by angBiu on 16/9/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUserBlackModel;
/**
 *  设置 ---- 黑名单 cell
 */
@interface ZZUserBlackCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) dispatch_block_t touchCancel;

- (void)setData:(ZZUserBlackModel *)model;

@end
