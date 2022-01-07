//
//  ZZTabbarRentBubbleView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTabbarRentBubbleView.h"
#import "ZZTabBarViewController.h"

@interface ZZTabbarRentBubbleView ()

@property (nonatomic) UIView *bgView;
@property (nonatomic) UILabel *bubbleText;

@end

@implementation ZZTabbarRentBubbleView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGFloat x = rect.size.width - (SCREEN_WIDTH - _pointX - 30);
    //begin point
    CGFloat origin_x = x - 10;
    CGFloat origin_y = rect.size.height - 15;
    //vertex point
    CGFloat line1_x = x;
    CGFloat line1_y = rect.size.height;
    //end point
    CGFloat line2_x = x + 10;
    CGFloat line2_y = rect.size.height - 15;
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArcToPoint(ctx, line1_x, line1_y, line2_x, line2_y, 2);
    CGContextAddLineToPoint(ctx, line1_x, line1_y);
    CGContextAddLineToPoint(ctx, line2_x, line2_y);
    
    CGContextClosePath(ctx);
    UIColor *fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextFillPath(ctx);
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _bgView.layer.cornerRadius = 8;
    _bgView.clipsToBounds = YES;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 15, 0));
    }];
    
    _bubbleText = [[UILabel alloc] init];
    _bubbleText.textColor = [UIColor whiteColor];
    _bubbleText.font = [UIFont systemFontOfSize:14];
    _bubbleText.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_bubbleText];
    [_bubbleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgView);
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
        make.height.equalTo(@20);
    }];
    
    self.rentCount = [ZZUserHelper shareInstance].unreadModel.pd_receive ? [ZZUserHelper shareInstance].unreadModel.pd_receive : 0;
}

- (void)setRentCount:(NSInteger)rentCount {
    _rentCount = rentCount;
    _bubbleText.text = [NSString stringWithFormat:@"当前有%ld条新的可抢任务",rentCount];
    self.hidden = !_isShowSign || rentCount <= 0;
    _isShowSign = NO;
}

@end
