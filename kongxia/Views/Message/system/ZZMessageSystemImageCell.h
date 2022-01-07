//
//  ZZMessageSystemImageCell.h
//  zuwome
//
//  Created by angBiu on 16/8/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSystemMessageModel;
/**
 *  系统消息图文cell
 */
@interface ZZMessageSystemImageCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZSystemMessageModel *)model;



@end
