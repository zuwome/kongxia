//
//  ZZMessageSystemHideVideo.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//全站隐藏视频,或者删除视频,或者么币充值引导

#import <UIKit/UIKit.h>
@class ZZSystemMessageModel;
@interface ZZMessageSystemHideVideoCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
- (void)setData:(ZZSystemMessageModel *)model;
@end
