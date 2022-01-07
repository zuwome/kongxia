//
//  ZZInputWithTitleView.h
//  zuwome
//
//  Created by 潘杨 on 2018/7/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 输入框和提示的
 注* 左侧提示右侧输入框  详情看提交证件  姓名  输入姓名
 */
@interface ZZInputWithTitleView : UIView

@property (nonatomic,strong) UITextField *promptTextField;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title placeholderTitle:(NSString *)placeholderTitle;

@end
