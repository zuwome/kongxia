//
//  ZZSettingSecurityCell.h
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  账号安全cell
 */
@interface ZZSettingSecurityCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImgView;

- (void)setIndexPath:(NSIndexPath *)indexPath;

@end
