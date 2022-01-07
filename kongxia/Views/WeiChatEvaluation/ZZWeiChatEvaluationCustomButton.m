//
//  ZZWeiChatEvaluationCustomButton.m
//  test123
//
//  Created by 潘杨 on 2018/2/28.
//  Copyright © 2018年 a. All rights reserved.
//

#import "ZZWeiChatEvaluationCustomButton.h"

@implementation ZZWeiChatEvaluationCustomButton

- (void)drawRect:(CGRect)rect {
    
  

    //创建path
    UIBezierPath * path = [UIBezierPath bezierPath];
    //设置线宽
    path.lineWidth = 0.5;
    //线条拐角
    path.lineCapStyle = kCGLineCapRound;
    //终点处理
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:(CGPoint){0,0}];
    [path addLineToPoint:(CGPoint){SCREEN_WIDTH*0.47,0}];
    [path addLineToPoint:(CGPoint){SCREEN_WIDTH*0.38,SCREEN_HEIGHT*0.08-0.5}];
    [path addLineToPoint:(CGPoint){0,SCREEN_HEIGHT*0.08-0.5}];
    [path closePath];
    //根据坐标点连线
    //  内部颜色
    UIColor *color = HEXCOLOR(0xf5f5f5);
    [color set];
    [path fill];
    //线条颜色
    UIColor *xianTiao = HEXCOLOR(0xD8D8D8);
    [xianTiao set];
    [path stroke];
}

@end
