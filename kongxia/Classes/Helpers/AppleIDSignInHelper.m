//
//  AppleIDLoginHelper.m
//  kongxia
//
//  Created by qiming xiao on 2020/4/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "AppleIDSignInHelper.h"

@interface AppleIDSignInHelper()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, copy) AppleIDSignInHandler handler;

@end
 
@implementation AppleIDSignInHelper

- (void)dealloc {
    _handler = nil;
}

- (void)signIn:(AppleIDSignInHandler)handler {
    if (@available(iOS 13.0, *)) {
        [self appleIDSignIn:handler];
    }
    else {
        if (handler) {
            handler(nil, [[NSError alloc] initWithDomain:@"AppleID Sign In"
                                                    code:-999
                                                userInfo:@{
                                                    NSLocalizedDescriptionKey: @"系统版本过低"
                                                }]);
        }
    }
}

- (void)appleIDSignIn:(AppleIDSignInHandler)handler {
    if (@available(iOS 13.0, *)) {
        _handler = handler;
        
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
         // 在用户授权期间请求的联系信息
        request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
            
         //需要考虑用户已经登录过，可以直接使用keychain密码来进行登录-这个很智能 (但是这个有问题)
//        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [[ASAuthorizationPasswordProvider alloc] init];
//        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
        
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
         // 设置授权控制器通知授权请求的成功与失败的代理
        controller.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        controller.presentationContextProvider = self;
         // 在控制器初始化期间启动授权流
        [controller performRequests];
    }
    else {
        if (handler) {
            handler(nil, [[NSError alloc] initWithDomain:@"AppleID Sign In"
                                                    code:-999
                                                userInfo:@{
                                                    NSLocalizedDescriptionKey: @"系统版本过低"
                                                }]);
        }
    }
}

#pragma mark - 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    
    NSMutableDictionary *appleIDSignInInfos = @{}.mutableCopy;
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        NSData *identityToken = credential.identityToken;
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSLog(@"token Str: %@", identityTokenStr);

        NSData *authorizationCode = credential.authorizationCode;
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        NSLog(@"authorizationCode -     %@",authorizationCodeStr);
        
        //授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互。
        NSString *user = credential.user;
        NSLog(@"user   -   %@  %@",user,identityToken);
                
//        appleIDSignInInfos[@"identityToken"] = identityToken;
        appleIDSignInInfos[@"identityToken"] = identityTokenStr;
        appleIDSignInInfos[@"user"] = user;
//        appleIDSignInInfos[@"authorizationCode"] = authorizationCode;
        appleIDSignInInfos[@"authorizationCode"] = authorizationCodeStr;
        
//        NSArray * segments = [jwtStr componentsSeparatedByString:@"."];
//        NSString * base64String = [segments objectAtIndex:1];
//        int requiredLength = (int)(4 *ceil((float)[base64String length]/4.0));
//        int nbrPaddings = requiredLength - (int)[base64String length];
//        if(nbrPaddings > 0) {
//            NSString * pading = [[NSString string] stringByPaddingToLength:nbrPaddings withString:@"=" startingAtIndex:0];
//            base64String = [base64String stringByAppendingString:pading];
//        }
//        base64String = [base64String stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
//        base64String = [base64String stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
//        NSData * decodeData = [[NSData alloc] initWithBase64EncodedData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:0];
//        NSString * decodeString = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[decodeString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    }
    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = (ASPasswordCredential *)authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = psdCredential.user;
        NSString *psd = psdCredential.password;
        NSLog(@"psduser -  %@   %@",psd,user);
        
        appleIDSignInInfos[@"password"] = psd;
        appleIDSignInInfos[@"user"] = user;
    }
    else {
       NSLog(@"授权信息不符");
        NSError *loginError = [[NSError alloc] initWithDomain:@"AppleID Sign In" code:ASAuthorizationErrorUnknown userInfo:@{
            NSLocalizedDescriptionKey : @"授权信息不符"
        }];
        if (_handler) {
            _handler(nil, loginError);
        }
        return;
    }
    
    if (_handler) {
        _handler(appleIDSignInInfos.copy, nil);
    }
    
}

#pragma mark - 授权回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
     NSLog(@"错误信息：%@", error);
     NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
                        
        default:
            break;
    }
    
    NSError *loginError = [[NSError alloc] initWithDomain:@"AppleID Sign In" code:error.code userInfo:@{
        NSLocalizedDescriptionKey : errorMsg
    }];
    if (_handler) {
        _handler(nil, loginError);
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"调用展示window方法：%s", __FUNCTION__);
    // 返回window
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - getters and setters
- (BOOL)canuserAppleIDSignIn {
    if (@available(iOS 13.0, *)) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
