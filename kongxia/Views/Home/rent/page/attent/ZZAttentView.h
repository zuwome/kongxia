//
//  ZZAttentView.h
//  zuwome
//
//  Created by angBiu on 16/8/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页关注view
 */
@interface ZZAttentView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *attentBgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *attentLabel;

@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, assign) NSInteger follow_status;//他人页
@property (nonatomic, assign) NSInteger listFollow_status;//列表
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) dispatch_block_t touchAttent;

@end
