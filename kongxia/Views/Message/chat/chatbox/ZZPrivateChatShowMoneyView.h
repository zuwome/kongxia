//
//  ZZPrivateChatShowMoneyView.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 私聊收费展示金钱的
 */
@interface ZZPrivateChatShowMoneyView : UIView

//私聊收费的背景
@property(strong,nonatomic) UIImageView *imageView;


/**
 私聊收费的钱数
 */
@property(strong,nonatomic) UILabel *getPrivateChatMoneyLab;

- (void)addAnimationWithFromCGPoint:(CGPoint)fromPoint endPoint:(CGPoint)endPoint andWaitTime:(float)waitTime animationKey:(NSString *)animationKey ;
/**
 添加飞溅的效果
 */
- (void)addSplashAnimation ;
@end
