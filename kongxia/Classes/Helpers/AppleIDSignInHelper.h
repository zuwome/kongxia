//
//  AppleIDLoginHelper.h
//  kongxia
//
//  Created by qiming xiao on 2020/4/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

typedef void(^AppleIDSignInHandler)(NSDictionary *appleIDSignInInfos, NSError *error);

@interface AppleIDSignInHelper : NSObject

@property (nonatomic, assign) BOOL canuserAppleIDSignIn;

- (void)signIn:(AppleIDSignInHandler)handler;

@end

