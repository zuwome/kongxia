//
//  ZZUserShouldNotHideView.h
//  kongxia
//
//  Created by qiming xiao on 2019/9/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZZUserShouldNotHideView : UIView

@property (nonatomic, copy) void(^comfireBlock)(void);

@property (nonatomic, copy) void(^cancelBlock)(void);

@end

NS_ASSUME_NONNULL_END
