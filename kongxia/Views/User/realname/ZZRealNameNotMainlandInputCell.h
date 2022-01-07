//
//  ZZRealNameNotMainlandInputCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRealNameNotMainlandInputCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;

- (void)setIndexPath:(NSIndexPath *)indexPath model:(ZZRealname *)model;

@end
