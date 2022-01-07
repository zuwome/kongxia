//
//  ZZRealNameListCell.h
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;

@interface ZZRealNameListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImgView;//logo
@property (nonatomic, strong) UIImageView *idImgView;//身份认证图标
@property (nonatomic, strong) UILabel *titleLabel;//类别
@property (nonatomic, strong) UIImageView *rzImgView;//认证标志图标
@property (nonatomic, strong) UILabel *rzLabel;//是否认证label
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setUer:(ZZUser *)user IndexPath:(NSIndexPath *)indexPath;

@end
