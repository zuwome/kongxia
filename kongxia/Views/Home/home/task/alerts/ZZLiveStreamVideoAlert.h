//
//  ZZLiveStreamVideoAlert.h
//  zuwome
//
//  Created by angBiu on 2017/7/19.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLiveStreamVideoAlert : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) dispatch_block_t touchRight;

@property (nonatomic, assign) NSInteger type;//1、女方拒绝视频弹窗 2、女方前两分钟挂断 3、女方两分钟后挂断 4、男方前两分钟挂断
@property (nonatomic, assign) NSInteger during;
@property (nonatomic, assign) CGFloat money;

@end
