//
//  ZZAboutCell.h
//  zuwome
//
//  Created by angBiu on 16/9/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

/**
 关于空虾
 */
@interface ZZAboutCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TTTAttributedLabel *numberLabel;
@property (nonatomic, strong) UIImageView *imgView;

- (void)setIndexPath:(NSIndexPath *)indexPath;

@end
