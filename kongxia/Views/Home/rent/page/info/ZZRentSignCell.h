//
//  ZZRentSignCell.h
//  zuwome
//
//  Created by angBiu on 16/6/1.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页 签名
 */
@interface ZZRentSignCell : UITableViewCell

@property (strong, nonatomic) UILabel *signLabel;

- (void)setData:(ZZUser *)user;

@end
