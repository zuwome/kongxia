//
//  LoginHelper.h
//  Exercise
//
//  Created by qiming on 2020/10/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginHelper : NSObject

+ (void)setAliAuthenSDK;

+ (instancetype)sharedInstance;

+ (void)showLoginViewIn:(UIViewController *)controller;

- (void)showLoginViewIn:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
