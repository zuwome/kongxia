//
//  ZZRentSkillCell.h
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"
/**
 *  他人页信息技能cell
 */
@interface ZZRentSkillCell : UITableViewCell

@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *skillIcon;
@property (nonatomic, strong) UILabel *skillContent;
@property (nonatomic, strong) SKTagView *tagView;

- (void)setData:(ZZTopic *)topic indexPath:(NSIndexPath *)indexPath;

@end
