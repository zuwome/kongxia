//
//  QNUploadHelper.h
//  zuwome
//
//  Created by angBiu on 16/9/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNUploadHelper : NSObject

@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);
@property (copy, nonatomic)  void (^singleFailureBlock)(void);

+ (id)shareInstance;

@end
