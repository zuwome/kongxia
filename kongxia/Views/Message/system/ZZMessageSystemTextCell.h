//
//  ZZMessageSystemTextCell.h
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSystemMessageModel;
/**
 *  系统消息纯文字
 */
@interface ZZMessageSystemTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *bgImgView;

- (void)setData:(ZZSystemMessageModel *)model;

@end
