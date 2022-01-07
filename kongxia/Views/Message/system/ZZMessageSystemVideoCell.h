//
//  ZZMessageSystemVideoCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/11/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSystemMessageModel;

/**
 *  系统消息视频审核cell
 */
@interface ZZMessageSystemVideoCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *againLabel;
@property (nonatomic, strong) UIView *lineView;
- (void)setData:(ZZSystemMessageModel *)model;

@end
