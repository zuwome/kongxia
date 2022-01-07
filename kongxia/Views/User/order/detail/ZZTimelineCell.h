//
//  ZZTimelineCell.h
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZMessage;

@interface ZZTimelineCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *cycleImgView;
@property (nonatomic, strong) UIView *cycleView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) ZZMessage *message;

- (void)setMessage:(ZZMessage *)message indexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

@end
