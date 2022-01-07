//
//  ZZRentMemedaQuestionCell.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZMemedaQuestionModel;
/**
 *  他人页么么答问题选择cell
 */
@interface ZZRentMemedaQuestionCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setData:(ZZMemedaQuestionModel *)model;

@end
