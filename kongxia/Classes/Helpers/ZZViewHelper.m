//
//  ZZLabelHelper.m
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewHelper.h"

@implementation ZZViewHelper

+ (UILabel *)createLabelWithAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = text;
    
    return label;
}

 + (UIView *)createWebView
{
    UIView *webView = [[WKWebView alloc] init];
    return webView;
}

@end
