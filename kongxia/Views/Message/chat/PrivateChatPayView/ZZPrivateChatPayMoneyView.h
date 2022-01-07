//
//  ZZPrivateChatPayMoneyView.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 金币飞
 */
@interface ZZPrivateChatPayMoneyView : UIImageView

-(instancetype)initWithFrame:(CGRect)frame ImageName:(NSString *)imageName;

/**
 每个金币的掉落时间0.5秒的情况下
 
 @param fromPoint 开始的位置
 @param toPoint  结束的位置
 @param repeat 重复次数
 */
- (void)addFallingAnimationWithFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint repeat:(float)repeat ;
/**
 金币飞行的路径

 @param fromPoint  起点的位置
 @param toPoint    暂停的位置
 @param endPoint   结束的位置
 @param firstTime  第一段开启的时间
 @param secondTime 第二段开启的时间
 @param waitTime   中间等待时间
 */
- (void)addAnimationWithFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint endPoint:(CGPoint)endPoint andFirstTime:(float)firstTime andSecondTime:(float)secondTime waitTime:(float) waitTime waitScalTime:(float)scalTime ;

/**
 扩散效果
 
 @param repeat 扩散的次数
 */
- (void)AddSpreadAnimationWithRepeat:(float)repeat;
@end
