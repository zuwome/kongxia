//
//  ZZLiveStreamEndVeiw.h
//  zuwome
//
//  Created by angBiu on 2017/7/19.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLiveStreamEndAlert : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) dispatch_block_t touchSure;

@end
