//
//  ZZPrivateChatShowMoneyView.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateChatShowMoneyView.h"
#import "CABasicAnimation+Ext.h"
#import "ZZPrivateDiffusionView.h"
@implementation ZZPrivateChatShowMoneyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.getPrivateChatMoneyLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.frame.size.width<=0) {
        return;
    }
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.getPrivateChatMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-3);
        make.bottom.offset(-25);
        make.left.offset(46);
    }];
    
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"picPaychatEffect2.png"];
    }
    return _imageView;
}

- (UILabel *)getPrivateChatMoneyLab {
    if (!_getPrivateChatMoneyLab) {
        _getPrivateChatMoneyLab = [[UILabel alloc]init];
        _getPrivateChatMoneyLab.textColor = RGBCOLOR(246, 214, 70);
        _getPrivateChatMoneyLab.textAlignment = NSTextAlignmentCenter;
        _getPrivateChatMoneyLab.font = [UIFont fontWithName:@"FuturaBT-Bold" size:18];
        
    }
    return _getPrivateChatMoneyLab;
}

- (void)addAnimationWithFromCGPoint:(CGPoint)fromPoint endPoint:(CGPoint)endPoint andWaitTime:(float)waitTime animationKey:(NSString *)animationKey {
     CAAnimation *animation = [self.layer animationForKey:animationKey];
    if (!animation) {
        [self.layer addAnimation:[CABasicAnimation animtionFromCGPoint:fromPoint toPoint:endPoint andTime:waitTime] forKey:animationKey];
    }else {
        [self.layer removeAnimationForKey:animationKey];
        [self.layer addAnimation:[CABasicAnimation animtionFromCGPoint:fromPoint toPoint:endPoint andTime:waitTime] forKey:animationKey];
    }
}

/**
 添加飞溅的效果
 */
- (void)addSplashAnimation {
    ZZPrivateDiffusionView *diffusionView1 = [[ZZPrivateDiffusionView alloc]initWithFrame:CGRectMake(1, 11, 5, 5)];
    [self addSubview:diffusionView1];
    [diffusionView1 addSplashAnimationWithRepeat:1 fromCGPoint:diffusionView1.center toPoint:CGPointMake(-2, 12)];
    
    
    ZZPrivateDiffusionView *diffusionView2 = [[ZZPrivateDiffusionView alloc]initWithFrame:CGRectMake(8, 5, 5, 5)];
    [self addSubview:diffusionView2];
    [diffusionView2 addSplashAnimationWithRepeat:1 fromCGPoint:diffusionView2.center toPoint:CGPointMake(5, 2)];
    
    
    ZZPrivateDiffusionView *diffusionView3 = [[ZZPrivateDiffusionView alloc]initWithFrame:CGRectMake(20, 4, 4, 4)];
    [self addSubview:diffusionView3];
    [diffusionView3 addSplashAnimationWithRepeat:1 fromCGPoint:diffusionView3.center toPoint:CGPointMake(24, 0)];
    
    
    ZZPrivateDiffusionView *diffusionView4 = [[ZZPrivateDiffusionView alloc]initWithFrame:CGRectMake(29, 10, 4, 4)];
    [self addSubview:diffusionView4];
    
    [diffusionView4 addSplashAnimationWithRepeat:1 fromCGPoint:diffusionView4.center toPoint:CGPointMake(34, 8)];

}


@end
