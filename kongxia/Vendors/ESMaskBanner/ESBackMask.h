//
//  ESBackMask.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ESMaskDirection) {
    ESMaskDirectionLeft = 0,
    ESMaskDirectionRight,
};

@interface ESBackMask : UIView

- (void)setMaskRadius:(CGFloat)maskRadius direction:(ESMaskDirection)maskDirection;

@end
