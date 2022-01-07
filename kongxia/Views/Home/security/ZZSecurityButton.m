//
//  ZZSecurityButton.m
//  zuwome
//
//  Created by angBiu on 2017/8/24.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityButton.h"

#import "ZZTabBarViewController.h"
#import "ZZSecurityViewController.h"

@implementation ZZSecurityButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_security_outside"];
        imgView.userInteractionEnabled = NO;
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)btnClick
{
    UINavigationController *navCtl = [ZZTabBarViewController sharedInstance].selectedViewController;
    ZZSecurityViewController *controller = [[ZZSecurityViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.orderId = _orderId;
    [navCtl pushViewController:controller animated:YES];
}

@end
