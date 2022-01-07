//
//  ZZAFNHelper.h
//  zuwome
//
//  Created by angBiu on 16/8/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <AFNetworking.h>
#import <Foundation/Foundation.h>

@interface ZZAFNHelper : AFHTTPSessionManager

+ (id)shareInstance;
+ (AFURLSessionManager *)sharedURLSession;

@end
