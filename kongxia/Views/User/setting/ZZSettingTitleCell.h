//
//  ZZSettingTitleCell.h
//  zuwome
//
//  Created by angBiu on 16/9/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  设置 --- 标题
 */
@interface ZZSettingTitleCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImgView;

- (void)setIndexPath:(NSIndexPath *)indexPath;

@end
