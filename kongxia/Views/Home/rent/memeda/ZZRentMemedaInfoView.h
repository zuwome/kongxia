//
//  ZZRentMemedaInfoView.h
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他的么么答个人页头部用户信息view
 */
@interface ZZRentMemedaInfoView : UIView

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *memehaoLabel;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, strong) UILabel *vLabel;

@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, strong) UIImage *shareImg;

- (void)setData:(ZZUser *)user;

@end
