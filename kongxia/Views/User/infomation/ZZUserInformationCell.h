//
//  ZZUserInformationCell.h
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
@class ZZRedPointView;

@interface ZZUserInformationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) ZZRedPointView *redPointView;

- (void)data:(ZZUser *)user indexPath:(NSIndexPath *)indexPath;

- (void)setData:(ZZUser *)user indexPath:(NSIndexPath *)indexPath;

@end
