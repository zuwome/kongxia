//
//  ZZStarsView.h
//  zuwome
//
//  Created by angBiu on 2017/3/28.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZStarsView;

@protocol ZZStarsViewDelegate <NSObject>

- (void)starsView:(ZZStarsView *)starsView currentScore:(CGFloat)currentScore;

@end

/**
 星星
 */
@interface ZZStarsView : UIView

@property (nonatomic, assign) CGFloat currentScore;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) CGFloat starWidth;
@property (nonatomic, assign) CGFloat starOffset;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, weak) id<ZZStarsViewDelegate>delegate;

@end
