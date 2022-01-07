//
//  ZZUserBindCell.h
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
@class ZZRedPointView;

@interface ZZUserBindCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bindTypeView;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView *phoneImgView;
@property (nonatomic, strong) UIImageView *wxImgView;
@property (nonatomic, strong) UIImageView *qqImgView;
@property (nonatomic, strong) UIImageView *wbImgView;
@property (nonatomic, strong) ZZRedPointView *redPointView;
@property (nonatomic, strong) ZZUser *user;

@end
