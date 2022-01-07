//
//  ZZMessageSystemDetailCell.h
//  zuwome
//
//  Created by angBiu on 16/7/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@class ZZSystemMessageModel;
/**
 *  系统消息文字带链接
 */
@interface ZZMessageSystemDetailCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, copy) dispatch_block_t touchLinkUrl;

- (void)setData:(ZZSystemMessageModel *)model;

@end
