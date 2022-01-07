//
//  ZZRentDynamicVideoCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoTimeView.h"
#import "ZZUserVideoListModel.h"
#import "ZZDynamicVideoCountView.h"

@interface ZZRentDynamicVideoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *coverImgView;//封面
@property (nonatomic, strong) ZZFindVideoTimeView *videoTimeView;
@property (nonatomic, strong) UILabel *videoContentLabel;
@property (nonatomic, strong) ZZDynamicVideoCountView *readCountView;
@property (nonatomic, strong) ZZDynamicVideoCountView *commentCountView;
@property (nonatomic, strong) ZZDynamicVideoCountView *zanCountView;

- (void)setData:(ZZUserVideoListModel *)model;

@end
