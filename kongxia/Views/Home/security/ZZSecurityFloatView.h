//
//  ZZSecurityFloatView.h
//  zuwome
//
//  Created by angBiu on 2017/8/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTranigleView.h"

/**
 提示view
 */
@interface ZZSecurityFloatView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZTranigleView *traingleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, assign) BOOL isUp;//小三角的方向
@property (nonatomic, assign) BOOL showClose;

@property (nonatomic, copy) dispatch_block_t touchClose;


@end
