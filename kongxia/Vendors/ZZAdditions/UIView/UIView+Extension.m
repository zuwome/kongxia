//
//  UIView+Extension.m
//  YLYForIos
//
//  Created by YuTianLong on 2017/8/14.
//  Copyright © 2017年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "UIView+Extension.h"
#import "YYFPSLabel.h"

#define FUNCTION_XIB_LOAD(name, obj) [[[NSBundle mainBundle] loadNibNamed:name owner:obj options:nil] firstObject]

@implementation UIView (Extension)

- (void)showFPSLabel {
    YYFPSLabel *label = [[YYFPSLabel alloc] init];
    label.frame = CGRectMake(66, 66, 100, 100);
    [self addSubview:label];
}

- (id)loadViewForXibWithName:(NSString *)xibName {
    
    if (xibName.length == 0) {
        xibName = [NSString stringWithUTF8String:object_getClassName(self)];
    }
    id view = FUNCTION_XIB_LOAD(xibName, self);
    return view;
}

- (void)loadCurrentViewForXibAndAddSubview {
    UIView *view = [self loadViewForXibWithName:nil];
    [self addSubviewDefault:view];
}

- (void)addSubviewDefault:(UIView *)view {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
}

- (void)addBottomLine:(UIColor *)color inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (void)addBorderAtDirection:(ViewDirection)direction color:(UIColor *)color borderWidth:(CGFloat)width {
    CGRect frame;
    switch (direction) {
        case ViewDirectionTop: {
            frame = CGRectMake(0.0, 0.0, self.frame.size.width, width);
            break;
        }
        case ViewDirectionBottom: {
            frame = CGRectMake(0.0, self.frame.size.height, self.frame.size.width, width);
            break;
        }
        case ViewDirectionLeft: {
            frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
            break;
        }
        case ViewDirectionRight: {
            frame = CGRectMake(self.frame.size.width, 0.0, width, self.frame.size.height);
            break;
        }
    }
    CALayer *borderLayer        = [[CALayer alloc] init];
    borderLayer.backgroundColor = color.CGColor;
    borderLayer.frame           = frame;
    [self.layer addSublayer:borderLayer];
}

- (void)dlj_addRounderCornerWithRadius:(CGFloat)radius size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cxt, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(cxt, [UIColor redColor].CGColor);
    
    CGContextMoveToPoint(cxt, size.width, size.height-radius);
    CGContextAddArcToPoint(cxt, size.width, size.height, size.width-radius, size.height, radius);//右下角
    CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-radius, radius);//左下角
    CGContextAddArcToPoint(cxt, 0, 0, radius, 0, radius);//左上角
    CGContextAddArcToPoint(cxt, size.width, 0, size.width, radius, radius);//右上角
    CGContextClosePath(cxt);
    CGContextDrawPath(cxt, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
    [self insertSubview:imageView atIndex:0];
}

- (UIImage *)snapShot {
    [self snapshotViewAfterScreenUpdates:YES];
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
