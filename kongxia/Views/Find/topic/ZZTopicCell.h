//
//  ZZTopicCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTopicModel.h"

@interface ZZTopicCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *countLabel;

- (void)setData:(ZZTopicModel *)model;

@end
