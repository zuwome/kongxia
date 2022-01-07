//
//  ZZLabelHelper.h
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

@interface ZZViewHelper : NSObject

+ (UILabel *)createLabelWithAlignment:(NSTextAlignment)textAlignment
                            textColor:(UIColor *)textColor
                             fontSize:(CGFloat)fontSize
                                 text:(NSString *)text;

+ (UIView *)createWebView;

@end
