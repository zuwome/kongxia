//
//  ZZSecurityView.h
//  zuwome
//
//  Created by angBiu on 2017/8/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZSecurityFloatView.h"

@interface ZZSecurityView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *testBtn;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) ZZSecurityFloatView *floatView;

@property (nonatomic, assign) BOOL test;

@property (nonatomic, copy) dispatch_block_t touchHelp;
@property (nonatomic, copy) dispatch_block_t touchTest;

@end
