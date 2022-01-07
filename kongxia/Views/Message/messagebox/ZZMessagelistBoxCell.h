//
//  ZZMessagelistBoxCell.h
//  zuwome
//
//  Created by angBiu on 2017/6/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMessagelistBoxCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unreadCountLabel;//未读

- (void)setData;

@end
