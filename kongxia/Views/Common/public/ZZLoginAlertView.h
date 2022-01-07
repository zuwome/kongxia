//
//  ZZLoginAlertView.h
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLoginAlertView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

- (void)showAlertMsg:(NSString *)msg;

@end
