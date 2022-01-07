//
//  ZZMemedaHeadView.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  我的么么答头部
 */
@interface ZZMemedaHeadView : UIView

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) UILabel *memehaoLabel;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, strong) UILabel *vLabel;

@property (nonatomic, strong) UIImage *shareImg;

- (void)setData:(ZZUser *)user;

@end
