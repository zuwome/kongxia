//
//  ZZDownloadHelper.h
//  zuwome
//
//  Created by angBiu on 2016/12/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZAFNHelper.h"

@interface ZZDownloadHelper : NSObject

+ (void)downloadWithUrl:(NSString *)urlString
             cachesPath:(NSString *)cachesPath
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
