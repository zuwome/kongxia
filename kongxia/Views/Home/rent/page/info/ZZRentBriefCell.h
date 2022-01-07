//
//  ZZRentBriefCell.h
//  zuwome
//
//  Created by angBiu on 16/8/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *   自我介绍
 */
@interface ZZRentBriefCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZUser *)user;

@end
