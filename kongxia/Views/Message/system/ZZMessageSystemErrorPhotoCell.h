//
//  ZZMessageSystemErrorPhotoCell.h
//  zuwome
//
//  Created by angBiu on 2016/10/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSystemMessageModel;

@interface ZZMessageSystemErrorPhotoCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZSystemMessageModel *)model;

@end
