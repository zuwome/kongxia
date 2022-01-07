//
//  ZZWechatShareHelper.h
//  kongxia
//
//  Created by qiming xiao on 2020/10/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZWechatShareHelper : NSObject

+ (void)shareImage:(UIImage *)image controller:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
