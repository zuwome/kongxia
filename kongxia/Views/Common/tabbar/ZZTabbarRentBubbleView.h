//
//  ZZTabbarRentBubbleView.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTabbarRentBubbleView : UIView

@property (nonatomic, assign) NSInteger rentCount;

@property (nonatomic, assign) CGFloat pointX;
//标记显示，在获取未读数且不为0的时候显示
@property (nonatomic, assign) BOOL isShowSign;

@end

NS_ASSUME_NONNULL_END
